@echo off
echo installer started
echo checking for existing installation...
if NOT EXIST static\ GOTO correctdir
echo static found
FOR /F %%i IN ('cd') DO set ADDRESS=%%~nxi
echo %ADDRESS%
if %ADDRESS% == "myvrcworld" GOTO stayput
echo we are in myvrcworld
cd ..
:stayput
:correctdir
if EXIST myvrcworld GOTO previousinstall
echo fresh install
echo creating program folder
mkdir myvrcworld
cd myvrcworld
::@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
Python\python.exe --version
if ERRORLEVEL 1 GOTO NOPYTHON  
goto :HASPYTHON  
:NOPYTHON
echo nopython
echo downloading python via powershell
echo installing python...
curl -LJO "https://github.com/T-Ev/myvrcworld/raw/main/Python.zip"
mkdir Python
powershell.exe -nologo -noprofile -command "& { Expand-Archive -Path Python.zip -DestinationPath %cd%\Python }"
echo python installer closed
VERIFY > nul
Python\python.exe --version
if ERRORLEVEL 1 GOTO PYTHONFAIL
goto :PYTHONSUCCESS
:PYTHONFAIL
echo --------
echo ACTION REQURED: This script doesn't have permission to download python 3. Please download manually from https://www.python.org/downloads/ then rerun this installer.
EXIT /B

:PYTHONSUCCESS
echo python installed successfully

:HASPYTHON
echo haspython... continuing
mkdir static
@REM cd static
@REM curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/static/myvrcworld.html"
@REM cd ..
echo installing venv...
Python\python.exe -m venv venv
echo downloading and installing activation script
cd venv\Scripts
del activate.bat
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/activate.bat"
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/activate-install.bat"
cd ..
cd ..
echo downloading launcher
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/launcher.bat"
cd ..
:previousinstall
cd myvrcworld
echo downloading overlay
cd static
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/static/myvrcworld.html"
cd ..
echo downloading primary script
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/myvrcworld.py"
echo launching local server
start cmd.exe /k "venv\Scripts\activate-install.bat"
echo Ready to launch myvrcworld?
TIMEOUT /T 10
echo launching obs display
Python\python.exe -m webbrowser http://localhost:5000/myvrcworld.html
echo installation successful!
echo to launch this app in the future use launcher.bat in the folder myvrcworld
echo you can now close this window :)
cmd /k