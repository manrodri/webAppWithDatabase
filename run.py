import os
import sys
import subprocess
from zipfile import ZipFile
import logging

"""

print('killing node process...')
os.system('sudo pkill node')



# # stop node app
# echo 'running: $ killall node'
# sudo pkill node
# if [ $? -eq 0 ]; then
#   echo 'node app killed'
# fi
# echo checking app is not running: ...
# echo 'running $ ps aux | grep'
# ps aux | grep node

# check if folder exists

app_folder ='/tmp/app'
if os.path.exists(app_folder):
  for afile in os.listdir(app_folder):
    os.remove(afile)
else:
  os.mkdir('/tmp/app')


file_name = os.path.join('/tmp', 'yelpCamp.zip')
with ZipFile(file_name, 'r') as zip: 
    # printing all the contents of the zip file 
    zip.printdir() 
    # extracting all the files 
    print('Extracting ...') 
    zip.extractall() 
  


# # unzip artifact
# if  [ -e '/tmp/yelpCamp.zip' ]
# then
#   unzip  /tmp/yelpCamp.zip  -d /tmp/app > /dev/null
#   if [ $? -ne 0 ]; then
#     echo 'Error unzipping artifact'
#     exit 4
#   fi
# else
#   echo could not find release cantidate
#   exit 3
# fi

# run the app
#cd /tmp/app
cmd = ['nohup', 'node', 'app.js', '>', '/tmp/yelpCamp.log', '&']
subprocess.run(cmd, shell=True)
with open('/tmp/yelpCamp.log', 'r') as f:
  for line in f:
    print(line)
#cat /tmp/yelpCamp.log
"""
print ('Running the app: GODD LUCK!')
