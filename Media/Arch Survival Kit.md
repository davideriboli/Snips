---
tags: [linux/arch, linux/endeavour]
---
#### Pacman Search

```shell
pacman -Ss softwaretosearch
``` 

#### Pacman Install

```shell
pacman -S softwaretoinstall
``` 


#### Pacman Uninstall (trash even non requested dependencies)

```shell
pacman -Rs softwaretouninstall
```  

#### Pacman System Update

```shell
pacman -Syy
```  

#### Pacman System Upgrade

```shell
pacman -Syu
```  

#### Pacman Check Cache Space

```shell
du -h /var/cache/pacman/pkg
```  

#### Pacman Trash All Cache

```shell
pacman -Scc
``` 

#### Pacman Spring Cleaning

```shell
pacman -Rcs $(pacman -Qdtq)
```

#### Pacman to remove unused packages (orphans)

```shell
sudo pacman -Qtdq | pacman -Rns -

```

---

#### Tools and GUI

```shell
yay -S resources bpytop tilix nord-tilix papirus-icon-theme papirus-folders papirus-filezilla-themes papirus-folders-nordic enpass-bin solanum gnome-calendar ticktick
```

---

#### Connessione estensioni Gnome

```shell
sudo pacman -Sy gnome-browser-connector
```

---

#### Sublime Text and Sublime Merge

```shell
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

sudo pacman -Syu sublime-merge sublime-text
```

---

#### Graph

```shell
yay -S gimp inkscape converseen xsane-gimp gimp-help-it gimp-nufraw gimp-plugin-gmic gimp-plugin-saveforweb imagemagick caesium-image-compressor-bin upscayl-bin
```

---

#### Text

```shell
yay -S libreoffice-fresh libreoffice-fresh-it hunspell hunspell-it hyphen hyphen-it libmythes mythes-it masterpdfeditor-free onlyoffice-bin obsidian
```

---

#### Fonts

```shell
yay -S font-manager adobe-source-serif-fonts adobe-source-sans-fonts otf-bodoni ttf-ms-win11-auto noto-fonts-lite && sudo fc-cache
```

---

#### Net

```shell
yay -S pcloud-drive filezilla papirus-filezilla-theme freedownloadmanager zapzap signal-desktop surfshark-client
```

---

#### Rainy Day

```shell
yay -S leafpad cozy-audiobooks ttf-bookerly mcomix radiotray-ng gfeeds-git
```

---

#### Processing in Sublime and Nodebox

```shell
#Assuming Processing in /home/stormy/App/Processing and Sublime Processing estension installed
export PATH=$PATH:/home/stormy/App/Processing && sudo ln -s /home/stormy/App/Processing/processing-java /bin/processing-java

git clone https://github.com/nodebox/nodebox
ant run 
```

---

#### Nautilus tools

```shell
yay -S  nautilus-checksums-git nautilus-admin-gtk4 nautilus-mediainfo nautilus-open-any-terminal python-nautilus nautilus-image-converter

```

#### Bluetooth

```shell
sudo systemctl start bluetooth # to start it for the session will stay disabled after reboot.

sudo systemctl enable bluetooth # to enable per default, will run after every boot.
```

