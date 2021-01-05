@echo off
echo installer started
python --version
if ERRORLEVEL 1 GOTO NOPYTHON  
goto :HASPYTHON  
:NOPYTHON  
echo nopython
echo downloading python via powershell
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/installer-powershell2.ps1"
::Powershell.exe -File X:installer-powershell.ps1 -version 3.9.1
echo installing python...
powershell -File installer-powershell2.ps1
echo Wait for Python install to finish in seperate window then proceed...
pause

:HASPYTHON 
echo haspython... continuing
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/finishinstall.bat"
start cmd.exe \k "finishinstall.bat"
cmd /k