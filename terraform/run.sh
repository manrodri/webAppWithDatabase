cd /tmp && curl -uadmin:AP4yc6KiPJbd7q36GqhzhxVHzFB -O http://34.244.56.79:8081/artifactory/generic-local/yelpCamp.zip
unzip yelpCamp.zip -d  > /dev/null
cd /tmp/yelpCampApp &&  nohup node app/app.js > tmp/yelpCamp.log &