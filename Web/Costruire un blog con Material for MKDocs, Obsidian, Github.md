---
title: MK-Docs Blog
pub date: 2024-11-21 | 09:51
tags:
  - github
  - linux
  - mkdocs
  - mkdocs/material
  - python
  - tools
---
# ===============================
# IL POST È IN COSTRUZIONE
# ===============================

## Aggiorna il sistema

```bash
sudo pacman -Syu
```

## Installa dipendenze di base

```bash
sudo pacman -S base-devel git python python-pip nodejs npm
```

# ===============================
# PYTHON E MKDOCS
# ===============================

## Installa Python tools

```bash
sudo pacman -S python-setuptools python-wheel
```

## Crea una cartella base e costruisci un VENV

```bash
cd NomeCartellaBaseBlog
python -m venv .venv #Nota che il venv è invisibile
source .venv/bin/activate
```

## Installa MkDocs e Material theme

```bash
pip install --user mkdocs mkdocs-material
```