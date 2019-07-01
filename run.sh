#!/bin/sh
  
# check if folder exists
SRC = '/tmp/app'
if [ -d $SRC && -w $SRC ]
  then
      rm -r $SRC/*
      echo "previuous app deleted"
  else
      echo "Error deleting previous release"
      exit(2)
fi

# unzip artifact
unzip /tmp/yelpCamp.zip -d /tmp/app

# run the app
cd /tmp/app
node app.js
