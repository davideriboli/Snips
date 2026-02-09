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