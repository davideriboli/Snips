#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
#  pcloud_download.sh
#  Download ottimizzato PCloud → SSD esterno — rete universitaria
#  Dipendenza: rclone (https://rclone.org)
# ─────────────────────────────────────────────────────────────────────────────

set -uo pipefail
# Nota: -e (exit on error) è deliberatamente omesso: gestiamo noi
# l'exit code di rclone, senza delegarlo al comportamento implicito della shell.

# ── Colori ANSI ───────────────────────────────────────────────────────────────
RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
BLU='\033[0;34m'
CYN='\033[0;36m'
BLD='\033[1m'
DIM='\033[2m'
RST='\033[0m'

# ── Configurazione ────────────────────────────────────────────────────────────
REMOTE_SRC="PCloud:Biblio"
LOCAL_DEST="/run/media/stormy/Extreme SSD/Chiaro/Biblio"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RAW_LOG="${SCRIPT_DIR}/.rclone_raw.log"      # log temporaneo grezzo (nascosto)
OUT_LOG="${SCRIPT_DIR}/logdown.txt"           # log finale leggibile
START_TS="$(date '+%Y-%m-%d %H:%M:%S')"

# ── Helper grafici ────────────────────────────────────────────────────────────
sep()  { echo -e "${DIM}─────────────────────────────────────────────────────────${RST}"; }
sep2() { echo -e "${BLD}${CYN}═════════════════════════════════════════════════════════${RST}"; }

ok()   { echo -e "  ${GRN}${BLD}✔${RST}  $*"; }
warn() { echo -e "  ${YLW}${BLD}⚠${RST}  $*"; }
err()  { echo -e "  ${RED}${BLD}✖${RST}  $*"; }
info() { echo -e "  ${DIM}$*${RST}"; }

# ── Header ────────────────────────────────────────────────────────────────────
echo
sep2
echo -e "${BLD}${CYN}   📥  PCloud → Extreme SSD  ·  Biblioteca                  ${RST}"
sep2
info "Avviato   : ${START_TS}"
echo -e "  ${BLU}Sorgente  :${RST} ${REMOTE_SRC}"
echo -e "  ${BLU}Dest.     :${RST} ${LOCAL_DEST}"
echo
sep
echo

# ── Controllo dipendenze ──────────────────────────────────────────────────────
if ! command -v rclone &>/dev/null; then
    err "rclone non trovato nel PATH."
    echo -e "     Installa da https://rclone.org e riprova."
    echo
    exit 1
fi

# ── Verifica / crea directory di destinazione ─────────────────────────────────
if [[ ! -d "$LOCAL_DEST" ]]; then
    warn "Directory di destinazione assente — creazione in corso..."
    mkdir -p "$LOCAL_DEST" || {
        err "Impossibile creare: ${LOCAL_DEST}"
        exit 1
    }
    ok "Directory creata."
    echo
fi

# ── Verifica connessione al remote ────────────────────────────────────────────
info "Verifica connessione a PCloud..."
if ! rclone lsd "PCloud:" &>/dev/null; then
    err "Remote 'PCloud' non raggiungibile."
    echo -e "     Controlla 'rclone config' e la connessione di rete."
    echo
    exit 1
fi
ok "PCloud raggiungibile."
echo
sep
echo

# ── Inizializza log temporaneo ────────────────────────────────────────────────
> "$RAW_LOG"

# ── Trasferimento ─────────────────────────────────────────────────────────────
echo -e "  ${BLD}Avvio trasferimento...${RST}  ${DIM}(Ctrl+C per interrompere in modo sicuro)${RST}"
echo

EXIT_CODE=0
rclone copy                         \
    --progress                      \
    --buffer-size       64M         \
    --transfers         4           \
    --checkers          8           \
    --multi-thread-streams  4       \
    --multi-thread-cutoff   50M     \
    --low-level-retries 20          \
    --retries           10          \
    --retries-sleep     30s         \
    --stats             15s         \
    --timeout           10m         \
    --tpslimit          8           \
    --log-file          "$RAW_LOG"  \
    --log-level         ERROR       \
    "$REMOTE_SRC" "$LOCAL_DEST"     \
    || EXIT_CODE=$?

echo
sep

# ── Analisi log errori ────────────────────────────────────────────────────────
END_TS="$(date '+%Y-%m-%d %H:%M:%S')"
declare -a FAILED=()
ERROR_COUNT=0

# Formato tipico rclone: "2024/01/01 12:00:00 ERROR : nome_file.pdf: messaggio"
# Usiamo BASH_REMATCH + parameter expansion per estrarre il percorso
# senza dipendenze esterne (no awk, no perl).
if [[ -s "$RAW_LOG" ]]; then
    while IFS= read -r line; do
        if [[ "$line" =~ ERROR[[:space:]]+:[[:space:]](.+) ]]; then
            fragment="${BASH_REMATCH[1]}"
            fname="${fragment%%: *}"   # tronca al primo ": " → nome file pulito
            if [[ -n "$fname" ]]; then
                FAILED+=("$fname")
                ERROR_COUNT=$(( ERROR_COUNT + 1 ))
            fi
        fi
    done < "$RAW_LOG"
fi

# ── Report terminale ──────────────────────────────────────────────────────────
echo
if [[ "$EXIT_CODE" -eq 0 && "$ERROR_COUNT" -eq 0 ]]; then

    ok "${BLD}Download completato senza errori."
    info "Completato: ${END_TS}"
    rm -f "$RAW_LOG"

    # Log minimo anche a buon fine (utile come registro)
    {
        printf "=== RCLONE DOWNLOAD LOG — %s ===\n\n" "$END_TS"
        printf "Esito        : OK — nessun errore\n"
        printf "Sorgente     : %s\n" "$REMOTE_SRC"
        printf "Destinazione : %s\n" "$LOCAL_DEST"
        printf "Avviato      : %s\n" "$START_TS"
        printf "Completato   : %s\n" "$END_TS"
    } > "$OUT_LOG"

else

    err "${BLD}Trasferimento completato con errori."
    info "Completato: ${END_TS} — Exit code: ${EXIT_CODE}"
    echo

    if [[ "$ERROR_COUNT" -gt 0 ]]; then
        warn "${BLD}File irrimediabilmente non trasferiti: ${ERROR_COUNT}"
        echo
        # Mostra in terminale (max 15 voci per non saturare l'output)
        SHOW_LIMIT=15
        for i in "${!FAILED[@]}"; do
            if (( i >= SHOW_LIMIT )); then break; fi
            echo -e "    ${RED}•${RST} ${FAILED[$i]}"
        done
        if (( ERROR_COUNT > SHOW_LIMIT )); then
            echo -e "    ${DIM}... e altri $(( ERROR_COUNT - SHOW_LIMIT )) file."
            echo -e "    Vedi il log completo: ${OUT_LOG}${RST}"
        fi
        echo
    fi

    echo -e "  ${YLW}⚠  Log completo salvato in:${RST} ${BLD}${OUT_LOG}${RST}"

    # ── Scrivi logdown.txt ────────────────────────────────────────────────────
    {
        printf "=== RCLONE DOWNLOAD LOG — %s ===\n\n" "$END_TS"
        printf "Esito        : ERRORI RILEVATI\n"
        printf "Sorgente     : %s\n" "$REMOTE_SRC"
        printf "Destinazione : %s\n" "$LOCAL_DEST"
        printf "Avviato      : %s\n" "$START_TS"
        printf "Completato   : %s\n" "$END_TS"
        printf "Exit code    : %s\n" "$EXIT_CODE"
        printf "\n"
        printf "─────────────────────────────────────────────────────────\n"
        printf "FILE NON TRASFERITI (%d totali):\n" "$ERROR_COUNT"
        printf "─────────────────────────────────────────────────────────\n"
        for f in "${FAILED[@]}"; do
            printf "  • %s\n" "$f"
        done
        printf "\n"
        printf "─────────────────────────────────────────────────────────\n"
        printf "LOG GREZZO RCLONE (per diagnostica):\n"
        printf "─────────────────────────────────────────────────────────\n"
        cat "$RAW_LOG"
    } > "$OUT_LOG"

    rm -f "$RAW_LOG"

fi

echo
sep2
echo
