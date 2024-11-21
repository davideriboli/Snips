---
title: Sopravvivere a Sublime Merge, Git e GitHub
pub date: 2024-11-21 | 11:08
tags:
  - linux
  - linux
  - git
  - github
---

Per tutte le operazioni quotidiane, uso [Sublime Merge](https://www.sublimemerge.com/) che però in certe versioni non riesce a storare stabilmente le credenziali di accesso a GitHub e chiede i dati di *login* ad ogni *push*.

Ne sono uscito (sotto Arch/Endeavour Linux), per prima cosa dicendo a Merge di usare il Git di sistema e non il proprio (vedi preferenze avanzate in Merge e comando `which git` per conoscere il *path* del Git di sitema) e poi installando  il *Credential Manager* con:

```bash
yay -S git-credential-manager-bin
```

Ho impostato la variabile che fa scrivere i dati di login sul proprio computer in formato testo, non criptato. Attenzione: logicamente la procedura è da evitarsi se gestite *repository* che esigono sicurezza. In compenso, non fa mai capricci.

```bash
git config --global credential.credentialStore plaintext
```

Poi fuoco alle polveri con:

```bash
git config --global credential.helper store --replace-all
```

Al primo *push* o *pull*, se appare un *pop-up* di sistema con la richiesta di credenziali, nel campo *password* non bisogna inserire la *password* ma il *token* di autenticazione. A essere onesti a me è apparso prima un pop-up di sistema e poi una richiesta di autenticazione via oAuth e *browser*.

È più che probabile che abbia fatto un casino micidiale, però per adesso funziona.