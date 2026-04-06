# MediaMTX

A zero-dependency media relay server that accepts streams via RTMP, RTSP, SRT, or WebRTC and automatically converts between protocols. Used here to bridge OBS (RTMP output) to Jellyfin Live TV (HLS input).

## Pipeline

```
OBS → RTMP → MediaMTX (:1935) → HLS (:8888) → Jellyfin Live TV tuner
```

MediaMTX is a relay, not a transcoder. OBS must encode as **H264 + AAC** (the default OBS settings) so Jellyfin and browsers can consume the stream directly.

## Ports

| Port | Protocol | Purpose           |
| ---- | -------- | ----------------- |
| 1935 | RTMP     | OBS stream ingest |
| 8888 | HTTP     | HLS output        |
| 8554 | RTSP     | RTSP output       |
| 8889 | HTTP     | WebRTC output     |

Host networking is used so all ports are available on the host without explicit mapping.

## Deployment

```bash
../../deploy.sh mediamtx root@<server-ip>
```

## OBS Configuration

In OBS → Settings → Stream:

- **Service:** Custom
- **Server:** `rtmp://<server-ip>:1935/live`
- **Stream Key:** (leave blank or use any value)

## Jellyfin Live TV Setup

After deploying, add the HLS stream as a Live TV tuner in Jellyfin:

1. Jellyfin → Dashboard → Live TV → Tuner Devices → Add
2. Select **M3U Tuner**
3. Set the URL to `http://<server-ip>:8888/live/index.m3u8`

The stream will appear as a channel once OBS is broadcasting.
