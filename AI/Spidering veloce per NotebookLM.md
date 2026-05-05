---
creato: mar 05/05/2026
tags:
  - linux
  - notebooklm
  - bash
  - web
---

## Intro

Due trucchi per recuperare al volo tutti i link di un sito, da dare in pasto a NotebookLM

##  Ricetta

Esempio pratico: voglio creare un NotebookLM con tutta la documentazione di [Gemini-CLI](https://geminicli.com/docs/) come fonte.

Sono circa 100 pagine, con URL che cominciano tutte con https://geminicli.com/docs/.

Il primo comando genera un file di testo “gemini_docs_links.txt” con tutte le URL esistenti:

```shell
wget --spider --recursive --level=inf --no-parent -U "Mozilla/5.0" -e robots=off "https://geminicli.com/docs/" 2>&1 | grep -oP '^--.+?--  \Khttps://geminicli.com/docs/[^"#\s]+' | sort -u > gemini_docs_links.txt
```

Il file però è facile che risulti pieno di doppioni del genere:

```txt
https://geminicli.com/docs/changelogs/latest
https://geminicli.com/docs/changelogs/latest/
```

Sebbene molti server aggiungano lo slash internamente, la versione senza è considerata più moderna e pulita per la gestione di documentazione tecnica ed è quella preferita da NotebookLM. Per ripulire il file, gli si tira in testa questo:

```bash
sed 's|/$||' gemini_docs_links.txt | sort -u > gemini_docs_links_clean.txt
```

**Spiegazione del comando:**

- `sed 's|/$||'`: Cerca il carattere `/` alla fine della riga (`$`) e lo sostituisce con il nulla (lo cancella).
    
- `sort -u`: Dopo aver rimosso lo slash, le due righe diventano identiche; `sort -u` le fonde in un'unica voce univoca.
---

*Ultima modifica: mar 05/05/2026*