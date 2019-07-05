cd /tmp && curl -uadmin:AP4yc6KiPJbd7q36GqhzhxVHzFB -O http://34.244.56.79:8081/artifactory/generic-local/yelpCamp.zip
unzip yelpCamp.zip -d /tmp/app > /dev/null
cd /tmp/app &&  nohup node app/app.js