---
creato: dom 28/12/2025
tags:
  - linux
  - pandoc
  - latex
---

## Intro

Installazione di tutto il necessario, con qualche trucco : )

##  Ricetta

**1. Aggiornamento preliminare** 

```bash
sudo pacman -Syu
```

**2. Installazione mirata (No Bloatware)** Invece di scaricare mezza internet (come capita spesso con questa roba), installiamo lo schema "medium" potenziato. Questo copre il 99% dei casi d'uso accademici e di Obsidian senza saturare il disco.

```bash
sudo pacman -S pandoc-cli texlive-basic texlive-latex texlive-latexextra texlive-fontsrecommended texlive-fontsextra librsvg texlive-xetex
```

**3. Il "Senior Mentor" Trick**

Per trasformazioni "al volo" da terminale senza preoccuparti di "Manca il pacchetto .sty", vale installare anche **Tectonic**. È un motore LaTeX moderno scritto in Rust che scarica i pacchetti mancanti automaticamente mentre compila.

```bash
sudo pacman -S tectonic
```

_Nota: Obsidian userà `pdflatex` (installato in fase 1), ma per gli script manuali, Tectonic è superiore._

**4. Font utili**

```bash
sudo pacman -S libertine otf-libertinus
```

**5. Rigenera i formati**

Anche dopo l'installazione, a volte i file `.fmt` non vengono generati automaticamente. Dobbiamo forzare la mano al sistema per "costruire" i motori.

```bash
sudo fmtutil-sys --all
```

---

*Ultima modifica: dom 28/12/2025*