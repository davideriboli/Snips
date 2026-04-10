---
creato: sab 27/12/2025
tags:
  - linux
  - bash
  - google
  - rsync
---

## Intro

Tutte le procedure per gestire correttamente gli upload verso G-Drive con RSync e poi come montare G-Drive in una cartella dedicata, per la gestione interna dei contenuti.

##  Ricetta

## 1. Installare Rclone

```bash
sudo pacman -S rclone
```


## 2. Configurazione del Remote (Google Drive)

Digita `rclone config`.

Scegli `n` per "New remote".

Nome: scrivi `gdrive` (usalo minuscolo per comodità negli script).

Storage: cerca il numero corrispondente a **Google Drive** (solitamente è intorno al 18, ma controlla la lista). Ultimamente è al 22.

**Client ID & Secret:** Lascia vuoti (premi Invio) per usare quelli di default, a meno che tu non voglia creare le tue credenziali su Google Cloud Console per velocità ancora superiori (bypassando i limiti condivisi).

**Scope:** Scegli `1` (Full access to all files).

**Edit advanced config?** Digita `n`.

**Use auto config?** Digita `y`. Si aprirà il browser sul tuo XPS: effettua il login e autorizza rclone.

## 3. Script bash

Questo è ottimizzato per il mio MSI, Va ricontrollato con Gemini per verificarne l’impatto sulle varie architetture. Lo script prende tutti i file e le cartelle che trova nella cartella “Decollo” e li carica sulla cartella “Atterraggio” che deve essere stata creata in G-Drive.

```bash
#!/bin/bash
# ==============================================================================
# SCRIPT: Decollo_Master_v6.0 (Vector Edition)
# ARCHITETTURA: MSI Vector GP68HX | i9-13950HX (32 threads) | 32GB RAM
# OBIETTIVO: Upload High-Throughput su EndeavourOS (Kernel 6.12-LTS)
# ==============================================================================

SOURCE="$HOME/Decollo"
DEST="gdrive:Atterraggio"
LOG_FILE="$HOME/decollo_report.log"
LOG_OLD="$HOME/decollo_report.log.old"

# --- 1. ROTAZIONE LOG ---
if [ -f "$LOG_FILE" ]; then
    mv "$LOG_FILE" "$LOG_OLD"
fi

# --- 2. VERIFICA SORGENTE ---
if [ ! -d "$SOURCE" ] || [ -z "$(ls -A "$SOURCE")" ]; then
   echo "📭 Nulla da decollare in $SOURCE."
   exit 0
fi

clear
echo "================================================================"
echo "🚀 DECOLLO V6.0 | MSI VECTOR GP68HX (POWER MODE)"
echo "================================================================"
echo "📂 CPU: i9-13950HX (32 Thread rilevati)"
echo "🧠 RAM: 32GB - Buffer ottimizzati"
echo "----------------------------------------------------------------"

# --- 3. ESECUZIONE TURBO (MSI OPTIMIZED) ---
# Abbiamo raddoppiato i trasferimenti simultanei e i buffer
rclone copy "$SOURCE" "$DEST" \
    --progress \
    --stats 1s \
    --human-readable \
    --transfers 16 \
    --checkers 32 \
    --drive-chunk-size 256M \
    --buffer-size 256M \
    --multi-thread-streams 16 \
    --use-mmap \
    --checksum \
    --fast-list \
    --create-empty-src-dirs \
    --log-file="$LOG_FILE" \
    --log-level INFO \
    --low-level-retries 20

# --- 4. GESTIONE ESITO ---
IF_ERROR=$?

echo -e "\n----------------------------------------------------------------"
if [ $IF_ERROR -eq 0 ]; then
    echo "✅ MISSIONE COMPLETATA: Potenza MSI sfruttata al 100%."
    notify-send "Rclone Vector" "Upload completato con successo!" --icon=emblem-success
else
    echo "❌ ANOMALIA RILEVATA (Codice: $IF_ERROR)"
    notify-send "Rclone Vector" "Errore durante il decollo" --urgency=critical
fi
```


## 4. Montaggio file system

Con questo sistema si può montare l’intero G-Drive in una cartella del file-system locale. Non va bene per i trasferimenti massivi di file (per quelli, usare lo script precedente), ma è ideale per mettere in ordine i contenuti.

1. Creare la cartella locale

```bash
mkdir -p ~/G-Drive
```

2. Script di montaggio manuale

```bash
rclone mount gdrive: ~/G-Drive \
    --vfs-cache-mode full \
    --vfs-cache-max-size 100G \
    --vfs-cache-max-age 48h \
    --vfs-read-ahead 1G \
    --buffer-size 512M \
    --dir-cache-time 1000h \
    --poll-interval 15s \
    --drive-pacer-min-sleep 10ms \
    --attr-timeout 1000h \
    --vfs-read-chunk-size 64M \
    --vfs-read-chunk-size-limit 2G \
    --transfers 8 \
    --daemon
```

3. Mount permanente

- Crea la directory per i servizi (se non esiste): `mkdir -p ~/.config/systemd/user/`
- Crea il file del servizio: `gedit ~/.config/systemd/user/rclone-gdrive.service`
- Incolla questo blocco:

```TOML
[Unit]
Description=Rclone Google Drive Mount (Vector Optimized)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
# Parametri calibrati per i9-13950HX e 32GB RAM
ExecStart=/usr/bin/rclone mount gdrive: %h/G-Drive \
    --vfs-cache-mode full \
    --vfs-cache-max-size 100G \
    --vfs-cache-max-age 48h \
    --vfs-read-ahead 1G \
    --buffer-size 512M \
    --dir-cache-time 1000h \
    --poll-interval 15s \
    --vfs-read-chunk-size 64M \
    --vfs-read-chunk-size-limit 2G \
    --transfers 8 \
    --no-modtime
ExecStop=/usr/bin/fusermount3 -u %h/G-Drive
Restart=on-failure

[Install]
WantedBy=default.target
```

4. Applicazione modifiche

```bash
systemctl --user daemon-reload
```

```bash
systemctl --user restart rclone-gdrive.service
```

5. Smontaggio sicuro (molto importante: permette a RClone di terminare le operazioni in corso, prima di chiudere)

```bash
systemctl --user stop rclone-gdrive.service
```

6. Se per qualche motivo il servizio si blocca (accade raramente con il kernel 6.12-LTS), il comando "hard" per liberare la cartella è:

```bash
fusermount3 -u ~/G-Drive
```

---

*Ultima modifica: sab 27/12/2025*