echo launching myvrcworld
echo starting Flask
start cmd.exe /k "venv\Scripts\activate.bat"
echo launching obs display
python -m webbrowser http://localhost:5000/myvrcworld.html

cmd /k