---
tags:
  - mkdocs
  - mkdocs/material
  - site
  - generator
  - python
  - windows
---
Più o meno tutto come in Linux... [vedi [[Material-MkDocs-in-Arch-Linux]]] ovvero

- crea una directory;
- entraci e crea un _venv_;
- attiva il _venv_ con

```python
NomeVenv\Scripts\activate
```

- se serve, aggiorna PIP;
- installa il necessario con:

```python
pip install mkdocs-material mkdocs-material-extensions mkdocs-glightbox Pillow cairosvg
``` 

Il problema è Cairo, che sotto Win non va. Per risolverlo, la cosa più veloce è scaricare il kit GTK-4_Windows-Runtime da [qui](https://github.com/tschoonj/GTK-for-Windows-Runtime-Environment-Installer/releases). Se ne può anche fare a meno, ma il sistema darà errore se si è attivato il [plugin delle social card](https://squidfunk.github.io/mkdocs-material/setup/setting-up-social-cards/).

Vedi: https://github.com/squidfunk/mkdocs-material/discussions/3074