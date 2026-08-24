---
title: EndeavourOS Ubuntu-Look & GNOME Setup Protocol
date: 2026-08-24
target_hardware: MSI Vector GP68 / Asus TUF
os: EndeavourOS (Arch-based)
desktop: GNOME / Wayland
tags:
  - linux
  - arch
  - endeavour-os
  - gnome
  - customization
  - obsidian-vault
---

# EndeavourOS Ubuntu-Look & GNOME Setup Protocol

Guida di configurazione chirurgica per trasformare l'ambiente desktop **GNOME / Wayland** su **EndeavourOS** replicando l'estetica, la tipografia, l'ergonomia visiva e la suite di estensioni di Ubuntu, preservando la purezza e le prestazioni dello stack Arch-based (zero Snap bloat).

---

## 1. Stack Tipografico (Ubuntu Fonts)

### Installazione Font
Installazione dei pacchetti ufficiali dal repository Arch:

```bash
sudo pacman -S --needed ttf-ubuntu-font-family
# Opzionale: font monospazio con ligature per dev
yay -S --needed ttf-ubuntu-mono-nerd
```

### Configurazione dconf / GSettings
Iniezione dei parametri di rendering e assegnazione delle famiglie tipografiche:

```bash
# Interfaccia e Documenti
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
gsettings set org.gnome.desktop.interface document-font-name 'Ubuntu 11'

# Editor e Terminale Monospace
gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 13'

# Barre del Titolo
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Ubuntu Bold 11'

# Ottimizzazione Subpixel Rendering e Hinting
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.interface font-hinting 'slight'
```

---

## 2. Icone, Temi e Accent Color

### Installazione Suite Yaru
Compilazione e installazione della suite Yaru (icone, temi e suoni di sistema) via AUR:

```bash
yay -S --needed yaru-icon-theme yaru-gtk-theme yaru-sound-theme
```

### Iniezione Temi e Accent Color Canonical
Applicazione del tema scuro, icone e colore d'accento arancione nativo libadwaita:

```bash
# Tema Icone Yaru Dark
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-dark'

# Tema GTK per app legacy GTK3/4
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'

# Accent Color Arancione Ubuntu (GNOME libadwaita)
gsettings set org.gnome.desktop.interface accent-color 'orange'

# Controlli Finestra completi a destra (Riduci, Ingrandisci, Chiudi)
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

# Tema Audio ed Eventi Sonori
gsettings set org.gnome.desktop.sound theme-name 'Yaru'
gsettings set org.gnome.desktop.sound event-sounds true
```

---

## 3. Dock Laterale & System Tray

### Installazione Pacchetti Base
```bash
yay -S --needed gnome-shell-extension-dash-to-dock gnome-shell-extension-appindicator gnome-tweaks
```

### Configurazione Dash to Dock (Ubuntu Layout)
```bash
# Abilita estensioni
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

# Setup Dock Laterale a tutta altezza
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
```

---

## 4. Elenco Completo GNOME Extensions

Di seguito l'inventario esaustivo delle estensioni utente rilevate sul sistema, suddivise per stato operativo e con identificatori/comandi di installazione AUR:

| Nome Estensione | Stato | Identificatore GNOME / Pacchetto AUR | Funzione Principale |
| :--- | :---: | :--- | :--- |
| **Alphabetical App Grid** | `ATTIVA` | `alphabetical-app-grid@stuarthayhurst` (`gnome-shell-extension-alphabetical-app-grid`) | Ordinamento alfabetico automatico della griglia applicazioni |
| **AppIndicator and KStatusNotifierItem Support** | `ATTIVA` | `appindicatorsupport@rgcjonas.gmail.com` (`gnome-shell-extension-appindicator`) | Supporto icone system tray nel top panel (Wave, Signal, Discord) |
| **Bluetooth Battery Meter** | `ATTIVA` | `bluetooth-battery-meter@maniacx.github.com` | Monitoraggio livello batteria periferiche Bluetooth connesse |
| **Claude Code Usage Monitor** | `ATTIVA` | `claude-code-usage-monitor@...` | Monitoraggio consumi token/API per sessioni CLI Claude Code |
| **Dash to Dock** | `ATTIVA` | `dash-to-dock@micxgx.gmail.com` (`gnome-shell-extension-dash-to-dock`) | Trasformazione della dash in barra laterale fissa a schermo intero |
| **GNOME Shell Cast** | `ATTIVA` | `gnome-shell-cast@...` | Integrazione streaming/casting Chromecast e protocolli remoti |
| **Hide Activities Button** | `ATTIVA` | `hide-activities-button@...` | Rimozione della scritta/pulsante "Attività" dalla top bar |
| **Night Theme Switcher** | `ATTIVA` | `nightthemeswitcher@romainvigier.fr` | Switch automatico tema chiaro/scuro in base a alba/tramonto |
| **Pomodoro Timer** | `ATTIVA` | `pomodoro@...` (`gnome-shell-pomodoro`) | Timer integrato per time management con tecnica pomodoro |
| **RebootToUEFI** | `ATTIVA` | `reboot-to-uefi@...` | Riavvio diretto nel firmware UEFI/BIOS dal menu di sistema |
| **Shutdown Timer** | `DISATTIVA` | `shutdown-timer@...` | Pianificazione spegnimento o sospensione programmata |
| **Top Panel Logo** | `ATTIVA` | `top-panel-logo@...` | Icona/Logo personalizzato nel pannello superiore |
| **Touchpad Switcher** | `ATTIVA` | `touchpad-switcher@...` | Toggle rapido attivazione/disattivazione trackpad laptop |
| **Vitals** | `ATTIVA` | `Vitals@corecoding.com` (`gnome-shell-extension-vitals`) | Monitoraggio hardware in tempo reale (CPU, RAM, Temp, Fan GPU) |
| **Weather or Not** | `ATTIVA` | `weather-or-not@...` | Indicatore meteo compatto e previsioni sul top panel |

---

## 5. Script di Bootstrap Automatico

Per applicare l'intero stack su una nuova installazione o ripristino di EndeavourOS:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "[+] Installazione font, temi e suite Yaru..."
sudo pacman -S --needed ttf-ubuntu-font-family gnome-tweaks
yay -S --needed yaru-icon-theme yaru-gtk-theme yaru-sound-theme \
    gnome-shell-extension-dash-to-dock gnome-shell-extension-appindicator \
    gnome-shell-extension-alphabetical-app-grid gnome-shell-extension-vitals

echo "[+] Applicazione configurazioni dconf..."
# Font
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
gsettings set org.gnome.desktop.interface document-font-name 'Ubuntu 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 13'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Ubuntu Bold 11'
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.interface font-hinting 'slight'

# Aspetto e Layout
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
gsettings set org.gnome.desktop.interface accent-color 'orange'
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
gsettings set org.gnome.desktop.sound theme-name 'Yaru'
gsettings set org.gnome.desktop.sound event-sounds true

# Dock
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true

echo "[+] Abilitazione estensioni core..."
gnome-extensions enable dash-to-dock@micxgx.gmail.com || true
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com || true

echo "[✓] Setup completato con successo. Effettua un logout per rendere attive tutte le estensioni."
```
