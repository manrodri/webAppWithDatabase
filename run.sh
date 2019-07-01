#!/bin/sh
# stop node app
sudo killall node
# check if folder exists
SRC='/tmp/app'
if [ -w  $SRC ]
  then
      rm -r $SRC/*
      echo previuous app deleted
fi

# unzip artifact
if  [ -e '/tmp/yelpCamp.zip' ]
then
  unzip /tmp/yelpCamp.zip -d /tmp/app
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
node app.js
