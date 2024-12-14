---
creato: sab 14/12/2024
tags:
  - python
  - web
  - windows
---

## Intro

Più o meno tutto come in Linux... [vedi [[Material-MkDocs-in-Arch-Linux]]].

##  Ricetta

### 1 Crea un venv

Logicamente, nella *directory* di lavoro.

```python
python -m venv /path/to/new/virtual/environment
```

### 2 Attiva il VENV

Sotto Win, non serve *source*.

```python
NomeVenv\Scripts\activate
```

### 3 Aggiorna PIP

Solo se serve aggiornarlo. Dovrebbe dirlo lui, dopo il primo uso.

```python
python -m pip install --upgrade pip
```

### 4 Installa quel che  serve

Dopo aver controllato sul sito ufficiale se l'elenco pacchetti è cambiato.

```python
pip install mkdocs-material mkdocs-material-extensions mkdocs-glightbox Pillow cairosvg
``` 

> [!Warning]
> Houston, abbiamo un problema: Cairo, sotto Win non va. Per risolverlo, la cosa più veloce è scaricare il kit GTK-4_Windows-Runtime da [qui](https://github.com/tschoonj/GTK-for-Windows-Runtime-Environment-Installer/releases). Se ne può anche fare a meno, ma il sistema darà errore se si è attivato il [plugin delle social card](https://squidfunk.github.io/mkdocs-material/setup/setting-up-social-cards/).

## Riferimenti esterni

- [Faccenda Cairo](https://github.com/squidfunk/mkdocs-material/discussions/3074)

---

*Ultima modifica: sab 14/12/2024*