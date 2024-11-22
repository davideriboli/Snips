---
creato: ven 22/11/2024
tags:
  - linux
---

## Intro

Istruzioni e qualche trucco per risparmiare tempo con le installazioni/manutenzioni di Arch ed Endeavour Os. 

##  Ricette

```insta-toc
- Intro
- Ricette
    - Pacman
        - Pacman Search
        - Pacman Install
        - Pacman Uninstall (trash even non requested dependencies)
        - Pacman System Upgrade
        - Pacman Check Cache Space
        - Pacman Trash All Cache
        - Pacman Spring Cleaning
        - Pacman Remove Orphans
    - Installazioni Base
        - Sublime Text and Sublime Merge
        - Text
        - Net
        - Tools and GUI
        - Graph
        - Fonts
        - Nautilus tools
    - Varia
        - Processing in Sublime and Nodebox
        - Rainy Day
        - Gestione Bluetooth su Endeavour
- Riferimenti esterni
```

### Pacman

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

#### Pacman Remove Orphans

```shell
sudo pacman -Qtdq | pacman -Rns -

```

---

### Installazioni Base

#### Sublime Text and Sublime Merge

```shell
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

sudo pacman -Syu sublime-merge sublime-text
```

#### Text

```shell
yay -S libreoffice-fresh libreoffice-fresh-it hunspell hunspell-it hyphen hyphen-it libmythes mythes-it masterpdfeditor-free onlyoffice-bin obsidian zotero-bin gpt4all-chat-git
```

#### Net

```shell
yay -S pcloud-drive filezilla papirus-filezilla-theme freedownloadmanager zapzap signal-desktop surfshark-client chromium mailspring-bin
```

#### Tools and GUI

```shell
yay -S resources bpytop tilix nord-tilix papirus-icon-theme papirus-folders papirus-folders-nordic enpass-bin solanum gnome-calendar ticktick flipclock gnome-browser-connector
```

#### Graph

```shell
yay -S gimp inkscape converseen xsane-gimp gimp-help-it gimp-nufraw gimp-plugin-gmic gimp-plugin-registry imagemagick caesium-image-compressor-bin upscayl-bin
```

#### Fonts

```shell
yay -S font-manager adobe-source-serif-fonts adobe-source-sans-fonts otf-bodoni ttf-ms-win11-auto noto-fonts-lite && sudo fc-cache
```

*Nota: inserire la procedura corretta per liberarsi degli stramaledettissimi Noto.*

#### Nautilus tools

```shell
yay -S  nautilus-checksums-git nautilus-admin-gtk4 nautilus-mediainfo nautilus-open-any-terminal python-nautilus nautilus-image-converter

```

### Varia

#### Processing in Sublime and Nodebox

```shell
#Assuming Processing in /home/stormy/App/Processing and Sublime Processing estension installed
export PATH=$PATH:/home/stormy/App/Processing && sudo ln -s /home/stormy/App/Processing/processing-java /bin/processing-java

git clone https://github.com/nodebox/nodebox
ant run 
```

#### Rainy Day

```shell
yay -S leafpad cozy-audiobooks calibre mcomix radiotray-ng gfeeds-git
```

#### Gestione Bluetooth su Endeavour

```shell
sudo systemctl start bluetooth # to start it for the session will stay disabled after reboot.

sudo systemctl enable bluetooth # to enable per default, will run after every boot.
```

---

## Riferimenti esterni

- [A Complete Idiot’s Guide To Endeavour OS Maintenance / Update / Upgrade](https://forum.endeavouros.com/t/a-complete-idiots-guide-to-endeavour-os-maintenance-update-upgrade/25184)

---

*Ultima modifica: ven 22/11/2024*
