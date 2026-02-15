# Self-hosted infrastructure

I haven't figured out how to create IAC for Raspberry Pi so here are the manual steps.

## Raspberry Pi

I use a Raspberry Pi 4 Model B, 4GB.

### Raspberry Pi Imager

In order to put software on your SD-card I use Raspberry Pi [Imager](https://www.raspberrypi.org/software/).

- Raspberry Pi OS Lite (64-bit)
- Control + Shift + X to open advanced menu
  - Set hostname: rxtl.local
  - Enable SSH. Allow public-key authentication only. In my case I had a key under ~/.ssh/id_ed25519.pub
  - If you're running on an older Raspberry Pi, it might not support 5GHz band when configuring the WiFi.

### Network

- When using `Raspberry Pi Imager`, the password field of the network can be cached to some old value, even after updating it.
- You need to manually update it in the `network-configuration` on the boot disc.
- You will probably need to mount the disk with write permissions `sudo mount -o remount,rw /run/media/${USER}/boot_image`

### SSH

What you set the username to is the path you SSH into. For example if the username is pi:

```
ssh pi@rxtl.local
```

#### Configure user group to not need root

```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```
