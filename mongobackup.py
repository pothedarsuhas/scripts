'''
requirements
- mongoclient installed on your system

note - this script takes variables from the environment 

basis for this script
    'mongodump --host <hostname/ip> --port 27017 --username <username>
    --password <********> --db green_crackers --out <backupDir>'

basis
> mongodump --host <hostname or ip> --port <port> --username <username> --password <password> --out <outputDir>


syntax 
> python mongobackup.py &

'''

import os
import time
import sys

# configs:
interval_m = 60
username = os.environ['MONGO_ADMIN_USER']
password = os.environ['MONGO_ADMIN_PASSWORD']
host = os.environ['MONGO_HOST']
port = os.environ['MONGO_PORT']
outputs_dir = os.environ['MONGO_OUTPUT_DIR']

def render_output_locations():
  return outputs_dir + time.strftime("%d-%m-%Y-%H:%M:%S")

def run_backup():
    command = "mongodump"
    command += " --host " + host
    command += " --port " + port
    command += " --username " + username
    command += " --password " + password
    command += " --out " + render_output_locations()
    os.system(command)

print("mongo backup process started")
print("Backing up MongoDB every {0} Minutes".format(interval_m))

while True:
  time.sleep(interval_m * 60)
  run_backup()
