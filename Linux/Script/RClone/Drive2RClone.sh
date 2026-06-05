#!/usr/bin/env bash
set -euo pipefail

# Configurazione Path (Invertiti per Download)
REMOTE_SRC="DR-GDrive:Biblio/Temp"
LOCAL_DEST="/home/stormy/BackUp/Up"

echo "📥 Avvio download massivo e ottimizzato da Google Drive..."
echo "☁️ Sorgente Cloud: $REMOTE_SRC"
echo "📂 Destinazione locale: $LOCAL_DEST"
echo "------------------------------------------------"

rclone copy -P \
    --buffer-size 128M \
    --transfers 4 \
    --checkers 8 \
    --multi-thread-streams 4 \
    --multi-thread-cutoff 250M \
    "$REMOTE_SRC" "$LOCAL_DEST"

echo "------------------------------------------------"
echo "✅ Download completato con successo."