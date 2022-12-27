@echo off

:: Set Download URL ---%URL%
:: Set Save Path ---%SavePath%
:: Set %Enginemode%  ---%enginemode%  default -auto

if exist %temp%\DownloadReport.dat (
    del /q %temp%\DownloadReport.dat
)

ver | find "6." > NUL && set OSCheck=LowVer
ver | find "10.0" >NUL && set OSCheck=HighVer

title task.download.file
if %enginemode%==auto goto AutoMode
if %enginemode%==powershell goto PS-Download
if %enginemode%==certutil goto CU-Download
if %enginemode%==bitsadmin goto BA-Download
cls
echo= Unknown Engine
pause 
exit

:AutoMode
set DE=BA
ver | find "6." > NUL && set DE=CU
ver | find "10.0" >NUL && set DE=PS

if %DE%==PS goto PS-Download
if %DE%==CU goto CU-Download
goto BA-Download

:PS-Download
set BackEngine=PS-Download-Skip
if %OSCheck%==LowVer goto WarningSupport
:PS-Download-Skip
powershell curl -o %SavePath% %URL% 
if not exist %SavePath% (
    echo=FAILED >>%temp%\DownloadReport.dat
    goto ExitPart
)
echo=TRUE >>%temp%\DownloadReport.dat
goto ExitPart

:CU-Download
set BackEngine=CU-Download-Skip
if %OSCheck%==HighVer goto WarningSafe
:CU-Download-Skip
certutil -urlcache -split -f %URL% %SavePath%
if not exist %SavePath% (
    echo=FAILED >>%temp%\DownloadReport.dat
    goto ExitPart
)
echo=TRUE >>%temp%\DownloadReport.dat
goto ExitPart

:BA-Download
set BackEngine=BA-Download-Skip
if %OSCheck%==HighVer goto WarningSafe
:BA-Download-Skip
bitsadmin /transfer myDownloadJob /download /priority normal %URL% %SavePath%
certutil -urlcache -split -f %URL% %SavePath%
if not exist %SavePath% (
    echo=FAILED >>%temp%\DownloadReport.dat
    goto ExitPart
)
echo=TRUE >>%temp%\DownloadReport.dat
goto ExitPart

:ExitPart
if exist %temp%\Download-OCCUPY (
    del /q %temp%\Download-OCCUPY
)
exit

:WarningSafe
cls
echo= ---------------------------------- Warning -------------------------------------------
echo=    Your OS is Windows 10 or 11. you are trying to use %enginemode% engine to download
echo=    For Windows 10 or 11. we recommend use PowerShell Engine Download. It best option
echo= And also in the Windows 10 or 11 OS Windows Defender Will may intercept Your Download Operate
echo=
echo=     You have 3 option
echo=   y -- Continue  n -- Cancel  ps -- Use PowerShell Download
set/p "dialog=y/n/ps>"
if %dialog%==y goto %BackEngine%
if %dialog%==n goto ExitPart
if %dialog%==ps goto PS-Download
goto WarningSafe

:WarningSupport
cls
echo= ---------------------------------- Warning -------------------------------------------
echo=           We cannot make sure Your Windows support use PowerShell Download
echo=               PowerShell Not Every Verion Support Download Function. 
echo=                     We recommend you select other Engine
echo=  
echo=    you have 4 option
echo=   y -- Continue  n -- Cancel  cu -- Use Certutil Download  ba -- Use Bitsadmin Download
set/p "dialog=y/n/cu/ba>"
if %dialog%==y goto %BackEngine%
if %dialog%==n goto ExitPart
if %dialog%==cu goto CU-Download
if %dialog%==ba goto BA-download
goto WarningSupport