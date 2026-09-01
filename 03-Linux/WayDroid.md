Guida operativa completa all'installazione, configurazione e gestione del ciclo di vita di **Waydroid** su sistemi Arch-based (**EndeavourOS**) in ambiente Wayland.

---

## 1. Installazione

### 1.1 Installazione pacchetti di sistema
Waydroid è disponibile sia nei repository ufficiali che tramite AUR helper (`yay`):

```bash
# Installazione da repository ufficiali (consigliato su EndeavourOS)
sudo pacman -S waydroid

# In alternativa, tramite AUR helper
yay -S waydroid

# (Opzionale) Utility grafica e helper da AUR
yay -S waydroid-helper-bin
```

### 1.2 Inizializzazione con Google Play Services (GAPPS)
Inizializza l'ambiente scaricando l'immagine certificata con OpenGApps integrato (necessario per la sincronizzazione cloud di Google e app come Daylio):

```bash
# Inizializzazione standard
sudo waydroid init -s GAPPS

# (In caso di riconfigurazione da zero o reset totale)
sudo waydroid init -f -s GAPPS
```

---

## 2. Avvio e Controllo Esecuzione

### 2.1 Flusso di avvio standard
Per l'avvio ordinario sono necessari due passaggi (demone root + sessione Wayland utente):

```bash
# 1. Avvia il container di sistema
sudo systemctl start waydroid-container

# 2. Avvia la sessione grafica utente (in ambiente Wayland)
waydroid session start
```

### 2.2 Apertura interfaccia o singole applicazioni
Interfaccia completa (App Drawer Android):
  ```bash
  waydroid show-full-ui
  ```

---

## 3. Spegnimento e Chiusura

### 3.1 Chiusura rapida della sessione
Chiude la GUI Android e i processi utente, lasciando il servizio container attivo:
```bash
waydroid session stop
```

### 3.2 Arresto completo (rilascio totale di RAM e risorse)
Spegne sia la sessione che il container di sistema:
```bash
# Ferma la sessione grafica
waydroid session stop

# Ferma il container systemd
sudo systemctl stop waydroid-container
```

---

## 4. Gestione del Servizio al Boot

Configurazione del comportamento del demone `waydroid-container` all'avvio del sistema:

```bash
# Abilita l'avvio automatico al boot
sudo systemctl enable waydroid-container

# Disabilita l'avvio automatico al boot (avvio solo su richiesta)
sudo systemctl disable waydroid-container
```

---

## 5. Correzioni e Ottimizzazioni

### 5.1 Disabilitare il trigger di Google Assistant con il tasto Super
Per evitare che il tasto `Super` (Windows) apra l'assistente vocale all'interno del container:

```bash
waydroid shell settings put secure assistant '""'
waydroid shell settings put secure voice_interaction_service '""'
```

### 5.2 Riavvio rapido del container
Utile in caso di modifiche ai servizi o freeze applicativi:
```bash
waydroid session stop
sudo systemctl restart waydroid-container
```

### 5.3 Ispezione e comandi utili
Stato del container e della sessione:
  ```bash
  waydroid status
  ```

Elenco di tutti i package Android installati:
  ```bash
  waydroid app list
  ```

Esecuzione comandi nella shell Android:
  ```bash
  waydroid shell "<comando>"
  ```