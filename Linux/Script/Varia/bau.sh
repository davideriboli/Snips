#!/bin/bash

# =================================================================
# SCRIPT: riboli_fixed_v2.sh
# OS: EndeavourOS (Arch Linux)
# STATUS: Senior Specialist Approved
# =================================================================

# Palette Verde Matrix/Hacker
GREEN='\033[0;32m'
BRIGHT_GREEN='\033[1;32m'
DARK_GREEN='\033[2;32m'
NC='\033[0m'

# Setup Terminale
tput civis # Nasconde il cursore
clear

cleanup() {
    tput cnorm # Ripristina il cursore
    clear
    exit
}

trap cleanup SIGINT

# --- Calcolo Dinamico Spazi ---
# Generiamo il titolo in una variabile per misurarne l'altezza
TITLE=$(figlet -f slant "Prof. Riboli")
TITLE_HEIGHT=$(echo "$TITLE" | wc -l)

# Coordinate dinamiche
INFO_START=$((TITLE_HEIGHT + 1))
LOG_START_LINE=$((INFO_START + 5))
MAX_LOGS=6

draw_static_interface() {
    clear
    # 1. Titolo ASCII
    tput cup 0 0
    echo -e "${BRIGHT_GREEN}$TITLE${NC}"
    
    # 2. Informazioni di Stato (Sotto il titolo)
    tput cup $INFO_START 0
    echo -e "${GREEN}################################################################"
    echo -e "${BRIGHT_GREEN}STATO: ELABORAZIONE DATI IN CORSO... PROT. 0xAF42"
    echo -e "${BRIGHT_GREEN}NON SPEGNERE! NON TOCCARE! - SISTEMA DI SICUREZZA ATTIVO"
    echo -e "${GREEN}################################################################${NC}"
    
    # 3. Separatore per i log
    tput cup $((LOG_START_LINE - 1)) 0
    echo -e "${DARK_GREEN}--- LOG DI SISTEMA REAL-TIME ---${NC}"
}

run_simulation() {
    local activities=(
        "Analisi flussi energetici..."
        "Sincronizzazione database riservato..."
        "Ottimizzazione kernel Prof. Riboli..."
        "Mapping settori memoria volatile..."
        "Criptazione tunnel SSH-7..."
        "Controllo integrità filesystem..."
        "Verifica checksum neurale..."
        "Data Merge Cloning..."
        "Addestramento modello..."
    )

    local current_row=$LOG_START_LINE

    while true; do
        local task=${activities[$RANDOM % ${#activities[@]}]}
        local addr="0x$(head -c 3 /dev/urandom | xxd -p | tr '[:lower:]' '[:upper:]')"
        local timestamp=$(date +"%H:%M:%S")

        # Scrittura log in posizione fissa
        tput cup $current_row 0
        tput el # Pulisce la riga
        echo -e "${DARK_GREEN}[$timestamp]${NC} ${GREEN}TASK:${NC} $task ${DARK_GREEN}[ADDR: $addr]${NC}"

        # Ciclo delle righe di log
        ((current_row++))
        if [ $current_row -ge $((LOG_START_LINE + MAX_LOGS)) ]; then
            current_row=$LOG_START_LINE
        fi

        # Lento e solenne (da 3 a 6 secondi)
        sleep $(( (RANDOM % 4) + 3 ))
    done
}

# --- Esecuzione ---
# Controllo dipendenze rapido
if ! command -v figlet &> /dev/null; then
    sudo pacman -S --needed figlet xxd --noconfirm
fi

draw_static_interface
run_simulation