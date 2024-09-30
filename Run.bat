@echo ~~~~~~~~~Windows Recovery Installer Script by "VermaG" aka DannyD
@echo ~~~~~~~~~  		ver. 1.01
@echo off
pause
@echo off
cls
echo off
:: Initial Setup
del temp.txt 2>nul
echo list vol > temp.txt
echo exit >> temp.txt
diskpart /s temp.txt
del temp.txt

:: Prompt for Number of Recovery Volumes
@echo		=============================================================================================
@echo 	 	-: Enter the Recovery volumeNO.(e.g., 1,2,3...0)
@echo  		-: NOTE:If there is no Recovery volume available above then press Enter and continue.
@echo		=============================================================================================
set /p numVolumes="Waiting for user input" 

:: Create a temporary diskpart script
echo sel vol %numVolumes% > temp.txt
echo del vol >> temp.txt

:: Run the diskpart script
diskpart /s temp.txt

:: Clean up the temporary file
del temp.txt
::
cls
del temp.txt 2>nul
echo list disk > temp.txt
echo exit >> temp.txt
diskpart /s temp.txt
del temp.txt
@echo ================================================================================================================
@echo IMPORTANT NOTE:
@echo If there is a '*' below Gpt column in above section It means your device using GPT style, Else using MRB(legacy).
@echo ================================================================================================================
@echo press 1 for GPT_style
@echo press 2 for MBR_style
@echo press 3 for exit	

:: Main Menu
:BEGIN
CHOICE /N /C:123 /M ""
IF ERRORLEVEL 3 GOTO CHOICE3
IF ERRORLEVEL 2 GOTO CHOICE2
IF ERRORLEVEL 1 GOTO CHOICE1

:CHOICE1
:: UEFI BIOS Recovery Deployment
@echo GPT style recovery deployment
@echo Deploying Recovery...
powershell rm -r C:\Windows\System32\Recovery\
powershell mkdir C:\Windows\System32\Recovery\
reagentc /disable
powershell rm -r C:\Windows\System32\Recovery\ -Force
powershell mkdir C:\Windows\System32\Recovery\ -Force
:: Check if files exist before copying
if exist "%~dp0Input\winre.wim" (
    powershell Copy-Item "%~dp0Input\winre.wim" C:\Windows\System32\Recovery\winre.wim -Force
) else (
    @echo winre.wim not found!
    pause
    GOTO END
)

if exist "%~dp0Input\ReAgent.xml" (
    powershell Copy-Item "%~dp0Input\ReAgent.xml" C:\Windows\System32\Recovery\ReAgent.xml -Force
) else (
    @echo ReAgent.xml not found!
    pause
    GOTO END
)

diskpart /s "%~dp0Ext.dll"
diskpart /s "%~dp0Gpt.dll"
reagentc /enable
cls
reagentc /info
@echo Successfully Deployed.
pause
GOTO END

:CHOICE2
:: Legacy BIOS Recovery Deployment
@echo MBR style recovery deployment
@echo Deploying Recovery...
powershell rm -r C:\Windows\System32\Recovery\
powershell mkdir C:\Windows\System32\Recovery\
reagentc /disable
powershell rm -r C:\Windows\System32\Recovery\ -Force
powershell mkdir C:\Windows\System32\Recovery\ -Force
:: Check if files exist before copying
if exist "%~dp0Input\winre.wim" (
    powershell Copy-Item "%~dp0Input\winre.wim" C:\Windows\System32\Recovery\winre.wim -Force
) else (
    @echo winre.wim not found!
    pause
    GOTO END
)

if exist "%~dp0Input\ReAgent.xml" (
    powershell Copy-Item "%~dp0Input\ReAgent.xml" C:\Windows\System32\Recovery\ReAgent.xml -Force
) else (
    @echo ReAgent.xml not found!
    pause
    GOTO END
)

diskpart /s "%~dp0Ext.dll"
diskpart /s "%~dp0Mbr.dll"
reagentc /enable
cls
reagentc /info
@echo Successfully Deployed.
pause
GOTO END

:CHOICE3
exit

:END
pause
EXIT
