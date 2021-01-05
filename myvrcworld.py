import os
import sys
import subprocess
import re
from flask import Flask

from flask import jsonify
import json
import time
import vrcpy
from apscheduler.schedulers.background import BackgroundScheduler
app = Flask(__name__,
            static_url_path='', 
            static_folder='static',
            template_folder='templates')
apikey="JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26"
CHARACTERUPDATETHRESHOLD = 70
_path = "{}\\..\\LocalLow\\VRChat\\VRChat\\".format(os.getenv('APPDATA'))
latest_edited_file = max([f for f in os.scandir(_path)], key=lambda x: x.stat().st_mtime if x.path.find("txt") == -1  else x.stat().st_mtime*5).name
last_filesize = 1
wrld=""
isFirst = True
full_path = "{}{}".format(_path, latest_edited_file)
last_dirsize = len([name for name in os.listdir(_path) if os.path.isfile(os.path.join(_path, name))])
#pattern = '(\d{4}.*)\sLog.*@@(\d),(\d),(\d),(.*)##'
pattern = '(\d{4}.*)\sLog.*\[RoomManager\]\sJoining\s(wrld_.*):'
currentworld="wrld_4432ea9b-729c-46e3-8eaf-846aa0a37fdd"
#init
#init scheduler
def test_job():
    looped_mode()

scheduler = BackgroundScheduler()
job = scheduler.add_job(test_job, 'interval', minutes=0.05)
scheduler.start()
#initialize VRC Api
client = vrcpy.Client()

#initialize routes
@app.route('/')
def root():
    return "The local server is working"

@app.route('/world')
def get_world():
    global wrld
    print(wrld)
    if wrld != "":
        return jsonify({"data":{"name": wrld.name,"authorName":wrld.authorName,"imageUrl":wrld.imageUrl}})
    else:
        return jsonify({"data":{"name": "","authorName":"","imageUrl":""}})

@app.route('/worldid')
def get_worldid():
    return "Current World Id: {}".format(currentworld)


# other utility funcitons
def resetLogFile():
    print("resetting log file")
    global latest_edited_file
    global full_path
    global last_filesize
    latest_edited_file = max([f for f in os.scandir(_path)], key=lambda x: x.stat().st_mtime if x.path.find("txt") == -1  else x.stat().st_mtime*5).name
    full_path = "{}{}".format(_path, latest_edited_file)
    print(full_path)
    last_filesize = 1

def looped_mode():
    global last_filesize
    global last_dirsize
    #print("loop started")
    if os.stat(full_path).st_size >=last_filesize+CHARACTERUPDATETHRESHOLD:
        qfile_changed()
    elif len([name for name in os.listdir(_path) if os.path.isfile(os.path.join(_path, name))]) != last_dirsize:
        print("new file")
        last_dirsize = len([name for name in os.listdir(_path) if os.path.isfile(os.path.join(_path, name))])
        resetLogFile()

def qfile_changed():
    print('File Changed!!!')
    global last_filesize
    last_filesize = parse_data(full_path, last_filesize)

def parse_data(source_path, start_index):
    print("Parsing Data")
    global currentworld
    global world
    global wrld
    global isFirst
    end_index = os.stat(full_path).st_size
    #if end_index - start_index > 20000:#5000
    if isFirst == True:
        isFirst = False
        start_index = end_index# - 5000
    #     print("too much data")
    if end_index - start_index > 50: # make sure at least a full line has been written
        start_index = start_index - 0  #grab previous data to help with alignment
        if start_index < 0:
            start_index = 0        
        with open(full_path, encoding="utf-8") as fin:
            fin.seek(start_index)
            try:
                data = fin.read(end_index - start_index)
            except:
                print("ERROR - File unreadable")
        chopped = data.split("\\n\\n\\n")
        filteredChop = [re.search(pattern, s, re.I | re.U).groups() for s in chopped if re.search(pattern, s)]
        #asyncio.set_event_loop(eventloop)
        for line in filteredChop:
            objtoSend = {}
            currentworld = line[1]
            print(currentworld)
            try:
                client.login("CR_SOAKER_1", "B0t-R0w-waste")
                wrld = client.fetch_world(currentworld)
                print("DOWNLOADING WORLD DATA")
                print(wrld)
                print(wrld.imageUrl)
                print(wrld.authorName)
                print(wrld.name)
                client.logout()
            except:
                print("Rate limited")
    else:
        print("no new data")
        start_index = end_index
    return end_index

looped_mode()