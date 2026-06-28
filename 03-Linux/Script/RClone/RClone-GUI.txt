#!/bin/bash

# --- CONFIGURATION ---
USER="stormy"
PASS="secret123"

# Notifica l'avvio (Feedback visivo per Stormy)
notify-send "RClone Web GUI" "Avvio del server di controllo in corso..."

# Esecuzione del comando
# Usiamo --rc-serve per assicurarci che la GUI sia servita correttamente
rclone rcd --rc-web-gui --rc-user "$USER" --rc-pass "$PASS"