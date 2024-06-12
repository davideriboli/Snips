---
tags: [linux/arch, linux/endeavour]
---
#### Gimp and plugins

```shell
yay -S gimp xsane-gimp gimp-help-it gimp-nufraw gimp-plugin-gmic gimp-plugin-saveforweb
```

#### LibreOffice with synonyms, dictionaries and hyphenation

```shell
sudo pacman -S libreoffice-fresh libreoffice-fresh-it hunspell hunspell-it hyphen hyphen-it libmythes mythes-it thunderbird thunderbird-i18n-it

```

#### Some more fonts

```shell
yay -S ttf-ms-fonts ttf-ms33558 ttf-ms-win11-auto-other

```

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
pacman -Rsun softwaretouninstall
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

#### Sublime Text and Sublime Merge

```shell
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

sudo pacman -Syu sublime-merge sublime-text
```

#### Obsidian and Zettlr

```shell
yay -S obsidian zettlr pandoc texlive-bin texlive-core
```

#### Various Tools

```shell
git clone https://aur.archlinux.org/gnome-browser-connector.git; cd gnome-browser-connector

makepkg -si

yay -S pcloud-drive font-manager uget-integrator-chromium uget-integrator-firefox ffmpeg imagemagick handbrake tilix masperpdfeditor-free bpytop converseen filezilla papirus-filezilla-theme
```