---
title: Ubuntu Survival Kit
pub date: Wed 12 06 2024 | 18:30
tags:
  - linux/ubuntu
---

### Steps after install

```shell
sudo ubuntu-drivers devices
```

```shell
sudo apt install ubuntu-restricted-extras gnome-tweaks gnome-shell-extension-manager curl neofetch bpytop clang cargo libc6-i386 libc6-x32 libu2f-udev samba-common-bin exfat-fuse default-jdk wget unrar git gstreamer1.0-vaapi unzip ntfs-3g p7zip gcc make curl bzip2 tar
```

### Snap alternatives

```shell
sudo apt install gdebi libfuse2 flatpak

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### Hide snap folder

```shell
echo snap >> ~/.hidden
```

### Icon in Bar Minimize on click

```shell
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
```

### Auto-CPU Freq

```shell
git clone https://github.com/AdnanHodzic/auto-cpufreq.git

cd auto-cpufreq && sudo ./auto-cpufreq-installer
```

Then GUI start to launch the daemon.

### Flameshot cure

Edit /etc/gdm3/custom.conf and remove comment from:

```text
#WaylandEnable=false
```

### Rhythmbox Settings Path

```text
~/.local/share/rhythmbox/rhythmdb.xml
```
