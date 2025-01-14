---
creato: mar 14/01/2025
tags:
  - android
  - hack
---

## Intro

Procedura per ottenere il *root* su telefono Nothing Phone 2a+

La procedura è descritta in maniera ragionevolmente particolareggiata: se non capite alcuni passaggi o il senso di alcuni strumenti, non proseguite. Il rischio di danneggiare il telefono, anche in modo irreparabile è abbastanza alto.

*La procedura annulla ogni garanzia e in ogni caso non sono responsabile di alcuna conseguenza catastrofica possa dipendere dalle vostre scelte, tipo telefoni bloccati per l'eternità, schede SD bruciate, guerre termonucleari o invasioni aliene a causa del malfunzionamento dell'applicazione di allarme in caso di emergenze.*

##  Ricetta

### Ingredienti

- Ultima versione stabile del [Magisk Manager](https://github.com/topjohnwu/Magisk/releases/tag/v28.1), installata sul telefono da *rootare*.
- La *init boot image* giusta per la versione di OS installata. Al momento in cui scrivo, l'archivio più completo è quello di [Spike0en](https://github.com/spike0en/nothing_archive) (di cui ho creato un *fork* che cerco di tenere aggiornato, disponibile attraverso il mio [account GitHub](https://github.com/davideriboli/Nothing-Images)).
- Ultima versione disponibile dei [Platform Tools](https://developer.android.com/tools/releases/platform-tools) di Android/Google.
- Mediatek USB Driver installati. Faccenda spinosa: tutte le guide in giro dicono di eseguire il *root* coi semplici *driver* Google. A me non ha funzionato e l'unica soluzione è stata [cercare i driver Mediatek](https://xdaforums.com/t/mediatek-all-tools-and-drivers-help-thread-windows-only.4696665/). Quelli usati da me nel gennaio 2025, sono [qui](MTK_Driver_Auto_Installer_SP_Drivers_20160804.7z).

### Procedimento

1. Passare sul telefono la *init boot image* giusta e *patcharla* col Magisk Manager, seguendo il percorso `Install -> Select and Patch a File`. Scaricare sul computer l'immagine *patchata*.
2. Sbloccate le *Developer Options* del telefono e poi attivate le due opzioni `OEM unlocking`  e `USB debugging`. Se il telefono è ancora collegato al PC, oppure al primo collegamento via cavo USB, apparirà un *popup* dove si chiede conferma che quel computer possa davvero eseguire *debugging* su quel telefono. Logicamente, la risposta giusta è *Sì*.
3. Per comodità, tenete la cartella dei *Platform Tools* in Scrivania. Apritela e nella barra di navigazione di Explorer scrivete `cmd`. Si apre un terminale che punta all'interno della cartella.
4. Assicuratevi che telefono e PC comunichino davvero con questo comando. Al 99%, dovrete eseguirlo due volte.
   
```shell
adb devices
```

5. Reboot del telefono in modalità bootloader. Il telefono si spegne e si riaccende. Dopo aver inviato in comando, non fate nulla fino a quando non rivedete la schermata di Nothing sul cellulare.
   
```shell
adb reboot bootloader
```

6. Verificate di nuovo la connessione con:
   
```shell
fastboot devices
```

7. Tenete in mano il telefono, collegato al PC. Sbloccate il bootloader col comando qui sotto e appena vi viene richiesto dal telefono, premete il bottone giusto del volume per confermare lo sblocco.
   
```shell
fastboot flashing unlock
```

8. Scoprite qual è lo slot disponibile (probabilmente il *b*) con:
   
```shell
fastboot getvar current-slot
```

9. Mettete la *init boot image* *patchata* nella cartella dei *Platform Tools* e lanciate questo comando. Qui presume che lo slot sia *b* e il file *patchato* si chiami "magisk.img" ma se così non fosse, mettete i dati giusti per voi:
   
```shell
   fastboot flash init_boot_b magisk.img
```

10. Reboot finale con questo comando. Il telefono si accenderà dopo una totale inizializzazione, come se fosse nuovo di fabbrica. Avete perso tutti i vostri dati, perché avete seguito la guida senza averla letta tutta prima, né aver fatto un *backup*? Oops... non fatelo mai più!

```shell
fastboot reboot
```

11. Aprite Magisk, terminate tutte le procedure di installazione ed è fatta.

## Addenda

Se avete deciso di applicare il root al telefono sapete cosa state facendo, perché e quali app vi servono. Rimane comunque il problema della autenticazione del dispositivo con Google, senza la quale i pagamenti in NFC non sono possibili e le app molto esigenti, tipo bancarie e PA non girano. Io ho risolto attivando Zygisk in Magisk, poi nascondendo Magisk a quasi tutti i processi Google, via *blocklist* interna e infine installando [MMRL via F-Droid](https://f-droid.org/it/packages/com.dergoogler.mmrl/). Poi, via MMRL il modulo [PlayIntegrityFix di Chiteroman](https://github.com/chiteroman/PlayIntegrityFix).

Per rimettere tutto a posto, seguite il paragrafo relativo, sulla guida linkata al primo punto qui sotto.

## Riferimenti esterni

- [Bootloader unlock and rooting with Magisk](https://xdaforums.com/t/guide-bootloader-unlock-and-rooting-with-magisk.4662722/)
- [Gruppo Telegram](https://t.me/NothingPhone2a)

---

*Ultima modifica: mar 14/01/2025*