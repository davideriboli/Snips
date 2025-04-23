---
creato: mer 23/04/2025
tags:
  - windows
  - video
---

## Intro

Lavorando con Resolume o Touchdesigner sotto Windows 11,  esce a ripetizione uno stramaledetto *popup* che invita a cercare sullo store un'app adatta al *gamingoverlay*.

Anche disabilitando completamente la stupida Xbox bar, il *popup* continua a rompere le palle.

##  Ricetta

Il solo modo efficace che ho trovato consiste nell'aggiungere due istruzioni al registro via Powershell (non da *admin*).

```shell
reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR /f /t REG_DWORD /v "AppCaptureEnabled" /d 0
```

```shell
reg add HKEY_CURRENT_USER\System\GameConfigStore /f /t REG_DWORD /v "GameDVR_Enabled" /d 0
```

## Riferimenti esterni

- https://answers.microsoft.com/en-us/windows/forum/all/how-to-stop-the-ms-gamingoverlay-popup/2b9c3309-b347-4bbf-85a7-376a301fb0a5

---

*Ultima modifica: mer 23/04/2025*