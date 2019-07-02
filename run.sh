#!/bin/sh
# stop node app
echo 'running: $ killall node'
sudo pkill node
if [ $? -eq 0 ]; then
  echo 'node app killed'
fi
echo checking app is not running: ...
echo 'running $ ps aux | grep'
ps aux | grep node

# check if folder exists
SRC='/tmp/app'
if [ -w  $SRC ]
  then
      rm -r $SRC/*
      echo previuous app deleted
  else 
     mkdir /tmp/app
fi

# unzip artifact
if  [ -e '/tmp/yelpCamp.zip' ]
then
  unzip -d /tmp/yelpCamp.zip > /dev/null
  if [ $? -ne 0 ]; then
    echo 'Error unzipping artifact'
    exit 4
  fi
else
  echo could not find release cantidate
  exit 3
fi

# run the app
cd /tmp/app
nohup node app.js > /tmp/yelpCamp.log &
cat /tmp/yelpCamp.log
