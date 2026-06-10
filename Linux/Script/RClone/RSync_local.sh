#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
#  biblio_pendrive.sh
#  Copia locale con configurazione interattiva dei percorsi
#  Dipendenza: rsync
# ─────────────────────────────────────────────────────────────────────────────

set -uo pipefail

# ── Colori ANSI ───────────────────────────────────────────────────────────────
RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
BLU='\033[0;34m'
CYN='\033[0;36m'
BLD='\033[1m'
DIM='\033[2m'
RST='\033[0m'

# ── Configurazione fissa ──────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERR_LOG="${SCRIPT_DIR}/.rsync_err.log"
OUT_LOG="${SCRIPT_DIR}/logpendrive.txt"
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
echo -e "${BLD}${CYN}   💾  Copia su dispositivo esterno                          ${RST}"
sep2
info "Avviato : ${START_TS}"
echo
sep
echo

# ── Controllo dipendenze ──────────────────────────────────────────────────────
if ! command -v rsync &>/dev/null; then
    err "rsync non trovato nel PATH."
    echo -e "     Installa con: ${DIM}sudo pacman -S rsync${RST}  oppure  ${DIM}sudo apt install rsync${RST}"
    echo
    exit 1
fi

# ── Prompt interattivi ────────────────────────────────────────────────────────
echo -e "  ${BLD}Configura il trasferimento${RST}"
echo -e "  ${DIM}Usa Tab per l'autocompletamento. Invio per accettare il percorso suggerito.${RST}"
echo

DEFAULT_SRC="/run/media/stormy/Extreme SSD/Chiaro/Biblio"

read -e -r \
    -p "$(echo -e "  ${BLU}Sorgente     :${RST} ")" \
    -i "$DEFAULT_SRC" \
    INPUT_SRC
LOCAL_SRC="${INPUT_SRC%/}"    # rimuovi eventuale trailing slash

echo

read -e -r \
    -p "$(echo -e "  ${BLU}Destinazione :${RST} ")" \
    INPUT_DEST
LOCAL_DEST="${INPUT_DEST%/}"

echo
sep

# ── Validazione input ─────────────────────────────────────────────────────────
if [[ -z "$LOCAL_SRC" ]]; then
    echo
    err "Il percorso sorgente non può essere vuoto."
    echo
    exit 1
fi

if [[ -z "$LOCAL_DEST" ]]; then
    echo
    err "Il percorso di destinazione non può essere vuoto."
    echo
    exit 1
fi

# ── Riepilogo e conferma ──────────────────────────────────────────────────────
echo
echo -e "  ${BLD}Riepilogo operazione:${RST}"
echo -e "  ${BLU}Sorgente     :${RST} ${BLD}${LOCAL_SRC}${RST}"
echo -e "  ${BLU}Destinazione :${RST} ${BLD}${LOCAL_DEST}${RST}"
echo
read -r -p "$(echo -e "  Confermi? ${BLD}[S/n]${RST} ")" CONFIRM
CONFIRM="${CONFIRM:-S}"

if [[ ! "$CONFIRM" =~ ^[Ss]$ ]]; then
    echo
    warn "Operazione annullata."
    echo
    sep2
    echo
    exit 0
fi

echo
sep
echo

# ── Verifica sorgente ─────────────────────────────────────────────────────────
if [[ ! -d "$LOCAL_SRC" ]]; then
    err "Directory sorgente non trovata: ${LOCAL_SRC}"
    echo -e "     Verifica il percorso e che il dispositivo sia montato."
    echo
    exit 1
fi

ok "Sorgente verificata."

# ── Verifica che il dispositivo di destinazione sia raggiungibile ─────────────
# Risale l'albero fino al primo parent esistente per testare il mount point
DST_PARENT="$LOCAL_DEST"
while [[ ! -d "$DST_PARENT" ]] && [[ "$DST_PARENT" != "/" ]]; do
    DST_PARENT="$(dirname "$DST_PARENT")"
done

if [[ "$DST_PARENT" == "/" ]]; then
    err "Impossibile raggiungere la destinazione: ${LOCAL_DEST}"
    echo -e "     Verifica che il dispositivo sia inserito e montato."
    echo
    exit 1
fi

ok "Dispositivo di destinazione raggiungibile."

# ── Verifica spazio disponibile ───────────────────────────────────────────────
SRC_SIZE_KB=$(du -sk "$LOCAL_SRC" 2>/dev/null | cut -f1 || echo 0)
DST_AVAIL_KB=$(df -k "$DST_PARENT" 2>/dev/null | awk 'NR==2 {print $4}' || echo 0)

if (( DST_AVAIL_KB < SRC_SIZE_KB )); then
    SRC_HR=$(du -sh "$LOCAL_SRC" 2>/dev/null | cut -f1)
    DST_HR=$(df -h "$DST_PARENT" 2>/dev/null | awk 'NR==2 {print $4}')
    err "Spazio insufficiente nella destinazione."
    echo -e "     Richiesto: ${BLD}${SRC_HR}${RST} — Disponibile: ${BLD}${DST_HR}${RST}"
    echo
    exit 1
fi

ok "Spazio disponibile verificato."

# ── Crea directory di destinazione se necessario ──────────────────────────────
if [[ ! -d "$LOCAL_DEST" ]]; then
    warn "Directory destinazione assente — creazione in corso..."
    mkdir -p "$LOCAL_DEST" || {
        err "Impossibile creare: ${LOCAL_DEST}"
        exit 1
    }
    ok "Directory creata."
fi

echo
sep
echo

# ── Inizializza log errori temporaneo ─────────────────────────────────────────
> "$ERR_LOG"

# ── Trasferimento ─────────────────────────────────────────────────────────────
echo -e "  ${BLD}Avvio copia...${RST}  ${DIM}(Ctrl+C per interrompere in modo sicuro)${RST}"
echo

EXIT_CODE=0
rsync \
    --archive \
    --info=progress2,stats1 \
    --human-readable \
    --partial \
    --partial-dir=".rsync-partial" \
    "${LOCAL_SRC}/" "${LOCAL_DEST}/" \
    2>"$ERR_LOG" \
    || EXIT_CODE=$?

echo
sep

# ── Analisi log errori ────────────────────────────────────────────────────────
# rsync exit codes rilevanti:
#   0  = successo totale
#   23 = trasferimento parziale (alcuni file falliti)
#   24 = alcuni file spariti durante il trasferimento (quasi sempre innocuo)
#
# rsync scrive su stderr le righe di errore nel formato:
#   rsync: [sender] open "/path/to/file" failed: Permission denied (13)
#   rsync: [Receiver] recv_generator: mkdir "/path/to/dir" failed: ...

END_TS="$(date '+%Y-%m-%d %H:%M:%S')"
declare -a FAILED=()
ERROR_COUNT=0

if [[ -s "$ERR_LOG" ]]; then
    while IFS= read -r line; do
        if [[ "$line" =~ \"(.+)\"[[:space:]]failed ]]; then
            fname="${BASH_REMATCH[1]}"
            fname="${fname#${LOCAL_SRC}/}"
            fname="${fname#${LOCAL_DEST}/}"
            if [[ -n "$fname" ]]; then
                FAILED+=("$fname")
                ERROR_COUNT=$(( ERROR_COUNT + 1 ))
            fi
        fi
    done < "$ERR_LOG"
fi

# ── Report terminale ──────────────────────────────────────────────────────────
echo
if [[ "$EXIT_CODE" -eq 0 && "$ERROR_COUNT" -eq 0 ]]; then

    ok "${BLD}Copia completata senza errori."
    info "Completato: ${END_TS}"
    rm -f "$ERR_LOG"

    {
        printf "=== RSYNC PENDRIVE LOG — %s ===\n\n" "$END_TS"
        printf "Esito        : OK — nessun errore\n"
        printf "Sorgente     : %s\n" "$LOCAL_SRC"
        printf "Destinazione : %s\n" "$LOCAL_DEST"
        printf "Avviato      : %s\n" "$START_TS"
        printf "Completato   : %s\n" "$END_TS"
    } > "$OUT_LOG"

elif [[ "$EXIT_CODE" -eq 24 && "$ERROR_COUNT" -eq 0 ]]; then

    warn "${BLD}Copia completata (exit 24 — alcuni file spariti durante il trasferimento)."
    warn "Causa tipica: file temporanei modificati in corso d'opera. Di norma innocuo."
    info "Completato: ${END_TS}"
    rm -f "$ERR_LOG"

    {
        printf "=== RSYNC PENDRIVE LOG — %s ===\n\n" "$END_TS"
        printf "Esito        : ATTENZIONE — exit code 24 (vanished files)\n"
        printf "Nota         : Solitamente causato da file temporanei. Nessuna azione richiesta.\n"
        printf "Sorgente     : %s\n" "$LOCAL_SRC"
        printf "Destinazione : %s\n" "$LOCAL_DEST"
        printf "Avviato      : %s\n" "$START_TS"
        printf "Completato   : %s\n" "$END_TS"
    } > "$OUT_LOG"

else

    err "${BLD}Copia completata con errori."
    info "Completato: ${END_TS} — Exit code: ${EXIT_CODE}"
    echo

    if [[ "$ERROR_COUNT" -gt 0 ]]; then
        warn "${BLD}File non trasferiti: ${ERROR_COUNT}"
        echo
        SHOW_LIMIT=15
        for i in "${!FAILED[@]}"; do
            if (( i >= SHOW_LIMIT )); then break; fi
            echo -e "    ${RED}•${RST} ${FAILED[$i]}"
        done
        if (( ERROR_COUNT > SHOW_LIMIT )); then
            echo -e "    ${DIM}... e altri $(( ERROR_COUNT - SHOW_LIMIT )) file."
            echo -e "    Vedi il log completo: ${OUT_LOG}${RST}"
        fi
    else
        warn "Errori rilevati ma nessun file specifico identificato."
        echo -e "     Consulta il log grezzo in: ${BLD}${OUT_LOG}${RST}"
    fi

    echo
    echo -e "  ${YLW}⚠  Log completo salvato in:${RST} ${BLD}${OUT_LOG}${RST}"

    {
        printf "=== RSYNC PENDRIVE LOG — %s ===\n\n" "$END_TS"
        printf "Esito        : ERRORI RILEVATI\n"
        printf "Sorgente     : %s\n" "$LOCAL_SRC"
        printf "Destinazione : %s\n" "$LOCAL_DEST"
        printf "Avviato      : %s\n" "$START_TS"
        printf "Completato   : %s\n" "$END_TS"
        printf "Exit code    : %s\n" "$EXIT_CODE"
        printf "\n"
        printf "─────────────────────────────────────────────────────────\n"
        printf "FILE NON TRASFERITI (%d identificati):\n" "$ERROR_COUNT"
        printf "─────────────────────────────────────────────────────────\n"
        if [[ "${#FAILED[@]}" -gt 0 ]]; then
            for f in "${FAILED[@]}"; do
                printf "  • %s\n" "$f"
            done
        else
            printf "  (impossibile identificare i file — vedi log grezzo sottostante)\n"
        fi
        printf "\n"
        printf "─────────────────────────────────────────────────────────\n"
        printf "LOG GREZZO RSYNC (stderr):\n"
        printf "─────────────────────────────────────────────────────────\n"
        cat "$ERR_LOG"
    } > "$OUT_LOG"

    rm -f "$ERR_LOG"

fi

echo
sep2
echo
