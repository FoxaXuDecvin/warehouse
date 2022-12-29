@echo off

:: MaxSupport Creative 8 Task Download
:: Set Download URL ---about %A-URL% %B-URL% %C-URL% Until %E-URL%
:: Set Save Path ---about %A-SavePath% %B-SavePath% Until %E-SavePath%
:: Set %Enginemode%  ---%enginemode%  default -auto
:: Set %tasknum% Work for download file Number


ver | find "6." > NUL && set OSCheck=LowVer
ver | find "10.0" >NUL && set OSCheck=HighVer

if %tasknum%==1 goto SetADownload
if %tasknum%==2 goto SetADownload
if %tasknum%==3 goto SetADownload
if %tasknum%==4 goto SetADownload
if %tasknum%==5 goto SetADownload
if %tasknum%==6 goto SetADownload
if %tasknum%==7 goto SetADownload
if %tasknum%==8 goto SetADownload
goto NumOut

:startservice
title task.download.file (%NowNum% / %tasknum%)
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
if exist %temp%\DownloadReport.dat (
    del /q %temp%\DownloadReport.dat
)
if not exist %SavePath% (
    echo=FAILED >>%temp%\DownloadReport.dat
    goto ExitPart
)
echo=TRUE >>%temp%\DownloadReport.dat
goto %afterdownloadreturn%


:CU-Download
set BackEngine=CU-Download-Skip
if %OSCheck%==HighVer goto WarningSafe
:CU-Download-Skip
certutil -urlcache -split -f %URL% %SavePath%
if exist %temp%\DownloadReport.dat (
    del /q %temp%\DownloadReport.dat
)
if not exist %SavePath% (
    echo=FAILED >>%temp%\DownloadReport.dat
    goto ExitPart
)
echo=TRUE >>%temp%\DownloadReport.dat
goto %afterdownloadreturn%


:BA-Download
set BackEngine=BA-Download-Skip
if %OSCheck%==HighVer goto WarningSafe
:BA-Download-Skip
bitsadmin /transfer myDownloadJob /download /priority normal %URL% %SavePath%
if exist %temp%\DownloadReport.dat (
    del /q %temp%\DownloadReport.dat
)
if not exist %SavePath% (
    echo=FAILED >>%temp%\DownloadReport.dat
    goto ExitPart
)
echo=TRUE >>%temp%\DownloadReport.dat
goto %afterdownloadreturn%

:ExitPart
if exist %temp%\Download-OCCUPY (
    del /q %temp%\Download-OCCUPY
)
title task.download.file (Complete)
ping 127.0.0.1 -n 2 >nul
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

:SetADownload
set NowNum=1
set URL=%A-URL%
set SavePath=%A-SavePath%
set afterdownloadreturn=SetBDownload
goto startservice

:SetBDownload
set NowNum=2
if %tasknum%==1 goto ExitPart
set URL=%B-URL%
set SavePath=%B-SavePath%
set afterdownloadreturn=SetCDownload
goto startservice

:SetCDownload
set NowNum=3
if %tasknum%==2 goto ExitPart
set URL=%C-URL%
set SavePath=%C-SavePath%
set afterdownloadreturn=SetDDownload
goto startservice

:SetDDownload
set NowNum=4
if %tasknum%==3 goto ExitPart
set URL=%D-URL%
set SavePath=%D-SavePath%
set afterdownloadreturn=SetEDownload
goto startservice

:SetEDownload
set NowNum=5
if %tasknum%==4 goto ExitPart
set URL=%E-URL%
set SavePath=%E-SavePath%
set afterdownloadreturn=SetFDownload
goto startservice

:SetFDownload
set NowNum=6
if %tasknum%==5 goto ExitPart
set URL=%F-URL%
set SavePath=%F-SavePath%
set afterdownloadreturn=SetGDownload
goto startservice

:SetGDownload
set NowNum=7
if %tasknum%==6 goto ExitPart
set URL=%G-URL%
set SavePath=%G-SavePath%
set afterdownloadreturn=SetHDownload
goto startservice

:SetHDownload
set NowNum=8
if %tasknum%==7 goto ExitPart
set URL=%H-URL%
set SavePath=%H-SavePath%
set afterdownloadreturn=ExitPart
goto startservice


:NumOut
cls
echo= Error Download Task Number: %tasknum% Over max support
echo= Max Support Creat 8 Download Task
echo= Press any key to Exit
pause >nul
exit