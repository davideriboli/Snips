---
tags: [chromeos, chromebook, performance, webgl, cablesgl]
os: chromeos
aggiornato: 2025-06-24
---

## Intro

Tutte le flag di chrome per spingere con cables.gl.

##  Ricetta

### Lista di Riferimento dei Chrome Flags

Per accedere: digitare `chrome://flags` nella barra degli indirizzi. Poi casella di ricerca per trovare il nome esatto del flag.

#### Categoria 1: Massime Prestazioni Grafiche e Rendering

_(Ideale per `cables.gl`, gaming, video editing e altre attività graficamente intensive)_

- **`#ignore-gpu-blocklist`** (Nome completo: **Override software rendering list**)
    
    - **A cosa serve**: Forza l'accelerazione hardware tramite GPU su tutto, senza eccezioni. È il flag più potente per garantire che la GPU sia sempre utilizzata al massimo.
    - **Quando usarlo**: Sempre attivo se il tuo scopo principale sono le performance grafiche. Disattivalo solo se noti artefatti visivi o crash su siti specifici.
    - **Impostazione Consigliata**: `Enabled`
- **`#enable-vulkan`**
    
    - **A cosa serve**: Abilita l'uso dell'API grafica Vulkan, più moderna e performante di OpenGL per molte applicazioni.
    - **Quando usarlo**: Attivalo per avere un potenziale boost prestazionale con giochi e app 3D (come `cables.gl`). Se un'app specifica mostra problemi grafici, prova a disattivarlo.
    - **Impostazione Consigliata**: `Enabled`
- **`#enable-skia-graphite`**
    
    - **A cosa serve**: Abilita Graphite, il nuovo motore di rendering di Skia (la libreria grafica 2D di Chrome) che utilizza la GPU in modo più efficiente.
    - **Quando usarlo**: Per sperimentare il rendering di nuova generazione. Può migliorare le performance generali dell'interfaccia e delle app 2D. È molto sperimentale.
    - **Impostazione Consigliata**: `Enabled` (da testare con cautela)
- **`#enable-gpu-rasterization`**
    
    - **A cosa serve**: Affida alla GPU il compito di trasformare i contenuti delle pagine in pixel, alleggerendo il carico sulla CPU.
    - **Quando usarlo**: Praticamente sempre. È una delle ottimizzazioni di base per le performance.
    - **Impostazione Consigliata**: `Enabled` (spesso è già il default)
- **`#enable-zero-copy`**
    
    - **A cosa serve**: Ottimizza il trasferimento di dati tra CPU e GPU, riducendo la latenza.
    - **Quando usarlo**: Utile in combinazione con la rasterizzazione GPU per limare ulteriormente le performance.
    - **Impostazione Consigliata**: `Enabled`

#### Categoria 2: Prestazioni Generali e Fluidità di Navigazione

_(Utili per l'uso quotidiano del Chromebook, per rendere tutto più reattivo)_

- **`#smooth-scrolling`**
    
    - **A cosa serve**: Anima lo scorrimento delle pagine, rendendolo più fluido e meno "scattoso".
    - **Quando usarlo**: Sempre, per un'esperienza di navigazione più piacevole.
    - **Impostazione Consigliata**: `Enabled`
- **`#back-forward-cache`**
    
    - **A cosa serve**: Salva una "istantanea" completa della pagina precedente/successiva in memoria, rendendo la navigazione con i tasti "indietro" e "avanti" istantanea.
    - **Quando usarlo**: Sempre. Aumenta drasticamente la velocità di navigazione percepita.
    - **Impostazione Consigliata**: `Enabled`
- **`#enable-parallel-downloading`**
    
    - **A cosa serve**: Suddivide i file che scarichi in più parti scaricate simultaneamente, accelerando il download.
    - **Quando usarlo**: Sempre, per scaricare file più velocemente.
    - **Impostazione Consigliata**: `Enabled`
- **`#calculate-native-win-occlusion`**
    
    - **A cosa serve**: Dice a Chrome di non sprecare risorse per calcolare e renderizzare i contenuti delle finestre che sono completamente coperte da altre finestre.
    - **Quando usarlo**: Sempre. È un ottimo modo per risparmiare CPU e batteria quando lavori con molte finestre sovrapposte.
    - **Impostazione Consigliata**: `Enabled`

#### Categoria 3: Funzionalità Sperimentali e Power-User

_(Per sbloccare feature non ancora rilasciate ufficialmente)_

- **`#ash-debug-shortcuts`**
    
    - **A cosa serve**: Abilita una serie di scorciatoie da tastiera per "smanettoni", che permettono di visualizzare i bordi degli elementi dell'interfaccia, i refresh dello schermo e altre informazioni di debug.
    - **Quando usarlo**: Quando vuoi curiosare "sotto il cofano" dell'interfaccia di ChromeOS o se stai sviluppando. Da non tenere attivo per l'uso normale.
    - **Impostazione Consigliata**: `Enabled` (con cautela)
- **`#enable-lens-region-search`**
    
    - **A cosa serve**: Ti permette di selezionare un'area dello schermo per effettuare una ricerca con Google Lens, proprio come faresti su Android.
    - **Quando usarlo**: Se usi spesso la ricerca per immagini e vuoi un'integrazione a livello di sistema operativo.
    - **Impostazione Consigliata**: `Enabled`
