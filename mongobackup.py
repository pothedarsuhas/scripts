'''
requirements
- pymongo
- mongoclient

uri example
    'mongodb://<username>:<password>@<hostnameorip>:27017/?authSource=<dbname>'

example uri 
> mongodb://username:password@hostname or ip:port/?authSource=backenddb 

example outputDir
> /backups/mongo/

basis for this script
    'mongodump --host <hostname/ip> --port 27017 --username <username>
    --password <********> --db green_crackers --out <backupDir>'

basis
> mongodump --host <hostname or ip> --port <port> --username <username> --password <password> --db <databasename> --out <outputDir>


syntax 
> python mongobackup.py <uri> <outputDir>

example
> python mongobackup.py mongodb://<username>:<password>@<hostnameorip>:27017/?authSource=<dbname> /backups/mongo/
'''

import os
import time
import sys

# configs:
interval_m = 1
uri = sys.argv[1]
outputs_dir = sys.argv[2]


uri = uri.split(':')

username = uri[1][2:]
password = uri[2].split('@')[0]
host = uri[2].split('@')[1]
port =uri[-1].split('/')[0]

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
print("I will backup your mongo db every {0} minutes".format(interval_m))

while True:
  time.sleep(interval_m * 60)
  run_backup()
