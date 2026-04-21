#!/usr/bin/env python3
"""
Podman socket proxy for Nextcloud AIO.

Two incompatibilities between AIO and Podman's Docker-compat API are patched here:

1. AIO passes seccomp profiles as inline JSON in container creation requests,
   but Podman tries to open that JSON as a file path, failing with "file name
   too long". We intercept POST /containers/create and replace inline seccomp
   JSON with "seccomp=unconfined".

2. Podman advertises Api-Version 1.41 in response headers. Docker CLI 29+
   (bundled in the AIO image) negotiates down to 1.41, but AIO's startup check
   requires >= 1.44 and refuses to boot. We rewrite the Api-Version response
   header to 1.44 so the CLI keeps v1.44 (Podman accepts any version prefix on
   request URLs, so this is safe).
"""
import asyncio
import json
import os
import re

UPSTREAM = "/run/user/0/podman/podman.sock"
LISTEN   = "/run/user/0/podman/podman-aio-proxy.sock"
MIN_API_VERSION = (1, 44)


async def read_headers(reader):
    lines = []
    while True:
        line = await reader.readline()
        if not line:
            return None
        lines.append(line)
        if line == b"\r\n":
            break
    return b"".join(lines)


def patch_container_create(first_line, body_bytes):
    try:
        body = json.loads(body_bytes)
        changed = False

        # Container name comes from ?name= query param in the URL, not the body
        url_name = ""
        for part in first_line.split(" "):
            if "name=" in part:
                for param in part.split("?")[-1].split("&"):
                    if param.startswith("name="):
                        url_name = param[5:]
        name = url_name or body.get("name", "") or body.get("Name", "")
        print(f"[proxy] container create: name={name!r}", flush=True)

        # Replace inline seccomp JSON with "seccomp=unconfined" (Podman can't handle inline JSON as a path)
        opts = body.get("HostConfig", {}).get("SecurityOpt") or []
        new_opts = [
            "seccomp=unconfined" if (
                isinstance(o, str) and o.startswith("seccomp=") and o[8:].lstrip().startswith("{")
            ) else o
            for o in opts
        ]
        if new_opts != opts:
            body["HostConfig"]["SecurityOpt"] = new_opts
            changed = True
            print(f"[proxy] stripped inline seccomp for {name!r}", flush=True)

        if changed:
            return json.dumps(body).encode()
    except Exception as e:
        print(f"[proxy] patch error: {e}", flush=True)
    return body_bytes


def rewrite_api_version(raw_headers):
    def repl(m):
        if (int(m.group(1)), int(m.group(2))) < MIN_API_VERSION:
            return f"Api-Version: {MIN_API_VERSION[0]}.{MIN_API_VERSION[1]}\r\n".encode()
        return m.group(0)
    return re.sub(rb"(?im)^Api-Version: *(\d+)\.(\d+)\r?\n", repl, raw_headers)


async def pipe(reader, writer):
    try:
        while True:
            data = await reader.read(65536)
            if not data:
                break
            writer.write(data)
            await writer.drain()
    except Exception:
        pass


async def handle(client_r, client_w):
    try:
        up_r, up_w = await asyncio.open_unix_connection(UPSTREAM)
    except Exception:
        client_w.close()
        return

    try:
        while True:
            raw_headers = await read_headers(client_r)
            if raw_headers is None:
                break

            headers_str = raw_headers.decode("latin-1")
            first_line  = headers_str.split("\r\n")[0]

            content_length = 0
            for h in headers_str.split("\r\n"):
                if h.lower().startswith("content-length:"):
                    content_length = int(h.split(":", 1)[1].strip())

            body = b""
            if content_length:
                body = await client_r.readexactly(content_length)

            # Patch container create requests
            if "POST" in first_line and "/containers/create" in first_line and body:
                new_body = patch_container_create(first_line, body)
                if new_body != body:
                    raw_headers = re.sub(
                        rb"(?i)content-length: *\d+",
                        f"content-length: {len(new_body)}".encode(),
                        raw_headers,
                    )
                    body = new_body

            up_w.write(raw_headers + body)
            await up_w.drain()

            # Hijacked connections (exec, attach) — pipe bidirectionally
            if b"upgrade" in raw_headers.lower():
                await asyncio.gather(pipe(client_r, up_w), pipe(up_r, client_w))
                return

            # Forward response
            resp_headers = await read_headers(up_r)
            if resp_headers is None:
                break
            resp_headers = rewrite_api_version(resp_headers)
            client_w.write(resp_headers)
            await client_w.drain()

            resp_str = resp_headers.decode("latin-1")
            resp_len = None
            chunked  = False
            for h in resp_str.split("\r\n"):
                if h.lower().startswith("content-length:"):
                    resp_len = int(h.split(":", 1)[1].strip())
                if "chunked" in h.lower():
                    chunked = True

            status_code = resp_str.split("\r\n")[0].split(" ")[1] if resp_str else ""

            if status_code in ("204", "101") or resp_len == 0:
                pass
            elif resp_len is not None:
                data = await up_r.readexactly(resp_len)
                client_w.write(data)
                await client_w.drain()
            elif chunked:
                while True:
                    size_line = await up_r.readline()
                    client_w.write(size_line)
                    size = int(size_line.strip(), 16)
                    if size == 0:
                        trail = await up_r.readline()
                        client_w.write(trail)
                        await client_w.drain()
                        break
                    chunk = await up_r.readexactly(size + 2)  # +2 for trailing \r\n
                    client_w.write(chunk)
                    await client_w.drain()
            else:
                # Unknown length — pipe until connection closes
                await pipe(up_r, client_w)
                return

    except Exception:
        pass
    finally:
        try:
            up_w.close()
        except Exception:
            pass
        try:
            client_w.close()
        except Exception:
            pass


async def main():
    if os.path.exists(LISTEN):
        os.unlink(LISTEN)
    server = await asyncio.start_unix_server(handle, path=LISTEN)
    os.chmod(LISTEN, 0o660)
    async with server:
        await server.serve_forever()


asyncio.run(main())
