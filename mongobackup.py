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

from pymongo import MongoClient
import sys
import os

client = MongoClient(str(sys.argv[1]))

uri = str(sys.argv[1])
outputDir = str(sys.argv[2])

uri = uri.split(':')

username = uri[1][2:]
password = uri[2].split('@')[0]
hostname = uri[2].split('@')[1]
port =uri[-1].split('/')[0]

databases = client.database_names()

for database in databases:
    os.system("mongodump --host " + hostname + " --port " + port + 
    " --username " + username + " --password " + password + " --db " 
    + database + " --out " + outputDir)
