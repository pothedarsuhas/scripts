'''
uri example
    'mongodb://green:cyphercrypt123@dev.cyphercrypttech.com:27017/?authSource=green_crackers'

outputDir example
    '/backups/mongo/'

basis for this script
    'mongodump --host dev.cyphercrypttech.com --port 27017 --username green
    --password cyphercrypt123 --db green_crackers --out /Users/suhaspothedar/backup/'

syntax to use this script 
    python mongobackup.py <uri> <outputDir>
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
