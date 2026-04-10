---
creato: ven 10/04/2026
tags:
  - linux
  - trick
  - pdf
---

## Intro

Vari trick in bash

##  Ricetta

### Compressione PDF

**Via Ghostscript** (ottima, impostata col preset `/ebook` che è il miglior compromesso tra leggibilità e peso a 150 dpi).

```bash
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
   -dNOPAUSE -dQUIET -dBATCH \
   -sOutputFile=output_compresso.pdf input_pesante.pdf
```

Breakdown del Payload:

- **`-dPDFSETTINGS`**: Qui decidi quanto vuoi "piallare" il file:
    
    - `/screen`: Bassa risoluzione (72 dpi), peso minimo. Ottimo per anteprime veloci.
        
    - `/ebook`: Risoluzione media (150 dpi), perfetto per la consultazione digitale. **(Consigliato)**.
        
    - `/printer`: Alta qualità (300 dpi), per la stampa.
        
- **`-dCompatibilityLevel=1.4`**: Massima compatibilità (anche con vecchi reader).
    
- **`-dNOPAUSE -dBATCH`**: Evita che Ghostscript si fermi a chiederti conferme tra una pagina e l'altra.

---

**Approccio "Arch-Way" (ocrmypdf)**

Se il PDF è pesante perché è una scansione d'immagine pura (zero testo selezionabile), comprimerlo con `gs` potrebbe non bastare. In quel caso, si usa **ocrmypdf**.

1. **Installazione:** `yay -S ocrmypdf`
    
2. **Esecuzione:**
    
    ```bash
    ocrmypdf --optimize 3 --skip-text input.pdf output_ottimizzato.pdf
    ```
    
    _Il flag `--optimize 3` esegue una compressione lossy aggressiva ma molto intelligente sulle immagini incorporate._

---

*Ultima modifica: ven 10/04/2026*