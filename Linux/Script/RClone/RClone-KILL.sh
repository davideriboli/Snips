#!/bin/bash
# 1. Kill forzato dei processi
pkill -9 rclone 2>/dev/null

# 2. Pulizia forzata del mount point (se presente)
fusermount3 -u -z ~/GDrive 2>/dev/null

notify-send "RClone" "Sistema nuclearizzato con successo."