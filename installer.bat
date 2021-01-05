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
mkdir static
cd static
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/static/myvrcworld.html"
cd ..
echo installing venv...
python -m venv venv
echo downloading activation script
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/activate-install.bat"
echo adding commands to activation Script
xcopy /Y ..\activate-install.bat venv\Scripts\
::cd ..
::xcopy /Y myvrcworld.py myvrcworld\
::cd myvrcworld
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/myvrcworld.py"
echo downloading launcher
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/launcher.bat"
echo launching local server
start cmd.exe /k "venv\Scripts\activate-install.bat"
echo launching obs display
python -m webbrowser http://localhost:5000/myvrcworld.html
cmd /k