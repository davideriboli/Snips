---
creato: ven 13/12/2024
tags:
  - linux
  - python
  - mkdocs
---

## Intro

Promemoria installazione M4MKdocs in Linux.

##  Ricetta

### 01 Crea un VENV

Logicamente, nella *directory* che conterrà tutto.

```python
python -m venv VENV
```

### 02 Attiva Venv

Sotto Linux, ci vuole `source`.

```shell
source VENV/bin/activate
```

### 03 Aggiorna PIP

Solo se serve aggiornarlo. Dovrebbe dirlo lui, dopo il primo uso.

```python
pip install --upgrade pip
``` 

### 04 Installa tutto

Controllare sul sito la lista degli elementi davvero necessari.

```python
pip install mkdocs-material mkdocs-material-extensions mkdocs-glightbox Pillow cairosvg
``` 

### 05 Crea il sito

[Così...](https://squidfunk.github.io/mkdocs-material/creating-your-site/). Controlla il *repository* di https://github.com/davideriboli/davideriboli.github.io per uno yaml bello e fatto.


## Riferimenti esterni

-  [MkDocs](https://www.mkdocs.org/)
-  [Material4MkDocs](https://squidfunk.github.io/mkdocs-material/)

---

*Ultima modifica: ven 13/12/2024*
