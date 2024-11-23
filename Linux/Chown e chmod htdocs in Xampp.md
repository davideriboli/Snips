---
creato: sab 23/11/2024
tags:
  - linux
  - web
---

## Intro

Gestione permessi Xampp (se s'incapriccia).

Attenzione: abbassa a zero ogni possibile idea di sicurezza.

##  Ricette

### Recupero proprietà

```shell
sudo chown -R ID:GROUP /opt/lampp/htdocs
``` 

### Permessi scrittura

```shell
sudo chmod -R 777 /opt/lampp/htdocs
``` 

### E se butta male, stessa cosa per WP.

```shell
sudo chmod -R 777 /opt/lampp/htdocs/wordpress
```

---

*Ultima modifica: sab 23/11/2024*
