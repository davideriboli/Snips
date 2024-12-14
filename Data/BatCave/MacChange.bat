@echo off
set adapterName="Wi-Fi"  :: Cambia con il nome della tua scheda di rete
set newMAC=02AA%random:~0,2%%random:~0,2%%random:~0,2%

echo Cambiando MAC Address...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\0001" /v "NetworkAddress" /d %newMAC% /f
netsh interface set interface name=%adapterName% admin=disable
netsh interface set interface name=%adapterName% admin=enable
echo Nuovo MAC Address impostato: %newMAC%
pause
