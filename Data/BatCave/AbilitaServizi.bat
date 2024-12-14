@echo off

REM Riabilita servizi del gruppo "Gaming e Xbox"
sc config XboxGipSvc start= demand
sc config XboxNetApiSvc start= demand
sc config XblAuthManager start= demand
sc config XblGameSave start= demand
sc config BcastDVRUserService start= demand
sc config GameInputSvc start= demand
sc config WpnService start= demand
sc config WpnUserService start= demand

REM Riabilita servizi del gruppo "Reti e Connettività"
sc config lltdsvc start= demand
sc config NetTcpPortSharing start= demand
sc config fdPHost start= demand
sc config FDResPub start= demand
sc config upnphost start= demand

REM Riabilita servizi del gruppo "Diagnostica e Telemetria"
sc config DiagTrack start= auto
sc config dmwappushservice start= demand
sc config DPS start= auto

REM Riabilita servizi del gruppo "Funzionalità Legacy"
sc config Fax start= demand
sc config TabletInputService start= demand
sc config RetailDemo start= demand
sc config RemoteRegistry start= demand

REM Fine dello script
echo Tutti i servizi richiesti sono stati riabilitati.
pause
