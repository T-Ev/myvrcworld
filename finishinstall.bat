@echo off
echo creating program folder
mkdir myvrcworld
cd myvrcworld
mkdir static
cd static
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/static/myvrcworld.html"
cd ..
echo installing venv...
python -m venv venv
echo downloading and installing activation script
cd venv\Scripts
del activate.bat
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/activate.bat"
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/activate-install.bat"
cd ..
cd ..
::cd ..
::xcopy /Y myvrcworld.py myvrcworld\
::cd myvrcworld
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/myvrcworld.py"
echo downloading launcher
curl -LJO "https://raw.githubusercontent.com/T-Ev/myvrcworld/main/launcher.bat"
echo launching local server
start cmd.exe /k "venv\Scripts\activate-install.bat"
echo Ready to launch myvrcworld?
TIMEOUT /T 6
echo launching obs display
python -m webbrowser http://localhost:5000/myvrcworld.html
echo installation successful!
echo to launch this app in the future use launcher.bat in the folder myvrcworld
cmd /k