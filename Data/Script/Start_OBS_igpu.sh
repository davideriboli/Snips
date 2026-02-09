#!/bin/bash
# Script per avviare OBS sulla iGPU Intel per preservare la RTX 4090
set -e

# Controllo se OBS è già in esecuzione
if pgrep "obs" > /dev/null; then
    echo "OBS è già attivo. Chiudilo prima di riavviare."
    exit 1
fi

echo "Inizializzazione OBS su iGPU Intel..."
# Forza l'uso della iGPU e avvia
__NV_PRIME_RENDER_OFFLOAD=0 __GLX_VENDOR_LIBRARY_NAME=mesa obs