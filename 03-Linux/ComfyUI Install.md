---
tags: [linux, ai, python, comfyui, pytorch]
os: linux
aggiornato: 2026-02-09
---

## Intro

Installazione (quasi) rapida di ComfyUI. Da ricontrollare sulle guide ufficiali se la data dell’ultimo aggiornamento si discosta dall’attuale di più di 30 giorni.

##  Ricetta

```python
python3 -m venv venv
```

```python
source venv/bin/activate
```
 
```python
 pip install --upgrade pip
```

Attenzione alla versione di CUDA (controllare sulla guida ufficiale).

```python
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu130
```
  
```bash
git clone https://github.com/comfyanonymous/ComfyUI.git && cd ComfyUI
```

```python
pip install -r requirements.txt
```

Per il *manager*, entrare in “Custom Nodes” e poi:

```bash
git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
```

Start (dall’interno della cartella ComfyUI, dopo aver attivato il VENV)

```python
python main.py
```

Chi attiva il VENV lo disattivi prima di uscire.

```python
deactivate
```

## Riferimenti esterni

- [ComfyUI Wiki - Linux Install](https://comfyui-wiki.com/en/install/install-comfyui/install-comfyui-on-linux)
- [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager)
