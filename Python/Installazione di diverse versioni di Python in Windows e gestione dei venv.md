---
tags:
  - python
  - windows
---
Si possono installare tutte le versioni di Python che si vuole, se si tiene tutto in ordine. Io installo a livello root in cartelle univoche, senza spazi né punti nei nomi. Al momento, sulla mia macchina ho Python 3.10 e Python 3.11.5 così sistemati:

- Python 3.10 in C:\Apps\Python310 (mio _default_; installato con aggiunta a PATH)
- Python 3.11.5 in C:\Apps\Python311

> [!PATH]
> Durante l'installazione con installer è sempre possibile aggiungere la versione di Python installata alle variabili di sistema PATH. Questo va fatto _solo_ per la versione che si userà di _default_ e non va ripetuto per tutte. È comunque possibile aggiungerne poi altre a mano

Per verificare quante e quali versioni di Python ci sono nel sistema:

```python
py --list
```

Per creare un _venv_ con Python 3.10

```python
py -3.10 -m venv _NomedelVenv_
```

Per creare un _venv_ con Python 3.11

```python
py -3.11 -m venv _NomedelVenv_
```

Per attivare un _venv_ 

```shell
cd CartellaVenv
Scripts/activate
```

Per controllare che versione di Python  è attiva nel _venv_

```python
python --version
```

Per disattivare un _venv_ attivo

```python
deactivate
```
