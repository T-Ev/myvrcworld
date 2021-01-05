@echo off
echo installer started
reg query "hkcu\software\Python"  
if ERRORLEVEL 1 GOTO NOPYTHON  
goto :HASPYTHON  
:NOPYTHON  
echo nopython
echo downloading python via powershell
Powershell.exe -File X:installer-powershell.ps1 -version 3.9.1

:HASPYTHON 
echo haspython... continuing

echo creating program folder
mkdir myvrcworld
cd myvrcworld
echo installing venv...
python -m venv venv
echo downloading activation script
if exist ..\activate.bat (
    echo it exixts
) else (
    echo it donte
)
echo adding commands to activation Script
xcopy /Y ..\activate-install.bat venv\Scripts\
cd ..
xcopy /Y myvrcworld.py myvrcworld\
cd myvrcworld
echo downloading launcher
echo launching local server
start cmd.exe /k "venv\Scripts\activate-install.bat"
echo launching obs display
python -m webbrowser http://localhost:5000/myvrcworld.html
cmd /k