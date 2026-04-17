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

## Authentication

MediaMTX is configured with two users. Credentials are stored in `/etc/mediamtx/mediamtx.yml` on the server.

| User     | Permission | Used by               |
| -------- | ---------- | --------------------- |
| `obs`    | publish    | OBS (RTMP ingest)     |
| `viewer` | read       | Jellyfin (HLS output) |

To change passwords, edit `/etc/mediamtx/mediamtx.yml` on the server and restart the service:

```bash
systemctl --user restart mediamtx.service
```

## OBS Configuration

In OBS → Settings → Stream:

- **Service:** Custom
- **Server:** `rtmp://<server-ip>:1935/live?user=obs&pass=<obs-password>`
- **Stream Key:** (leave blank)

### Troubleshooting

**`Failed to open OpenH264: Unknown error occurred`** when starting a stream — this happens when OBS is running as a Flatpak. The Flatpak sandbox blocks access to system codecs. Launch OBS from the terminal instead (`obs`), or add a native launcher:

```bash
cp /usr/share/applications/com.obsproject.Studio.desktop ~/.local/share/applications/com.obsproject.Studio.desktop
sed -i 's|^Exec=obs|Exec=/usr/bin/obs|' ~/.local/share/applications/com.obsproject.Studio.desktop
update-desktop-database ~/.local/share/applications/
```

This overrides the Flatpak launcher in GNOME Search with the native binary.

## Jellyfin Live TV Setup

Jellyfin's M3U Tuner needs a channel list file — a small text file that tells Jellyfin what streams exist. Create it on the server:

```bash
cat > /srv/jellyfin/movies/channels.m3u << 'EOF'
#EXTM3U
#EXTINF:-1 tvg-id="live" tvg-name="OBS Live",OBS Live
http://viewer:<viewer-password>@<server-ip>:8888/live/index.m3u8
EOF
```

This file is placed in `/srv/jellyfin/movies/` because that directory is already mounted into the Jellyfin container as `/media/movies`.

Then in Jellyfin:

1. Dashboard → Live TV → Tuner Devices → Add
2. Select **M3U Tuner**
3. Set **File or URL** to `/media/movies/channels.m3u`
4. Leave **User Agent** blank

The stream will appear as a channel called "OBS Live" once OBS is broadcasting.
