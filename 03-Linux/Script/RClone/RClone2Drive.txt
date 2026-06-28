#!/usr/bin/env bash
set -euo pipefail

# Configurazione Path e Remote
LOCAL_PATH="/home/stormy/BackUp/Up"
REMOTE_DEST="DR-GDrive:Biblio/Temp"

echo "🚀 Avvio upload massivo e ottimizzato..."
echo "📂 Sorgente locale: $LOCAL_PATH"
echo "☁️ Destinazione Cloud: $REMOTE_DEST"
echo "------------------------------------------------"

rclone copy -P \
    --drive-chunk-size 128M \
    --buffer-size 64M \
    --transfers 4 \
    --checkers 8 \
    --drive-acknowledge-abuse \
    "$LOCAL_PATH" "$REMOTE_DEST"

echo "------------------------------------------------"
echo "✅ Trasferimento completato con successo."
