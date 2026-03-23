---
creato: lun 23/03/2026
tags:
  - linux
  - audio
---

## Intro

Procedure base per l’installazione di Reaper e plugin nativi in Linux.

##  Ricette

### 1. Installazione Software Core & Plugin

Utilizza i repository ufficiali (`extra`) per massima stabilità. Oppure ricerca via `yay -Ss`

```bash
# DAW ed Estensioni Fondamentali
sudo pacman -S reaper sws reapack

# Suite di Processing Professionale (LSP e x42)
sudo pacman -S lsp-plugins x42-plugins
```

### 2. Ottimizzazione Sistema (Realtime Priority)

Indispensabile per evitare glitch (Xruns) su architetture Intel 13th Gen (vale per l’MSI; verificare con Brian se è necessario in altri contesti hardware.

1. **Configurazione Limiti:** Crea/modifica il file `/etc/security/limits.d/99-realtime-privileges.conf` con questo contenuto:

    
    ```txt
    @realtime - rtprio 98
    @realtime - memlock unlimited
    @realtime - nice -11
    ```
    
1. **Permessi Utente:** Assicurati che il tuo utente appartenga al gruppo `realtime`:
    
    ```bash
    sudo groupadd realtime
    sudo usermod -aG realtime $USER
    ```
    
    _(Nota: Richiede riavvio del sistema)._


### 3. Configurazione Motore Audio (PipeWire-JACK)

Sull'MSI Vector, la modalità **JACK** è l'unica stabile che permette il routing simultaneo (Browser + DAW + Bluetooth).

1. **Forza lo Standard Broadcast (48kHz):**
    
    ```bash
    pw-metadata -n settings 0 clock.force-rate 48000
    ```
    
2. **Impostazioni REAPER (Preferences > Audio > Device):**
    
    - **Audio System:** `JACK`
        
    - **Disable power management if supported:** `Spuntato` (Evita il parking dei core CPU).
        
    - **Lock process memory with mlockall():** `Spuntato` (Previene lo swap della RAM audio).

---

*Ultima modifica: lun 23/03/2026*