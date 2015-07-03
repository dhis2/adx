#!/bin/bash

DBNAME=adxtest
DBOWNER=twenty
DHISNAME=twenty

echo "Shutdown instance if running"
dhis2-shutdown twenty
sleep 3
echo "Setting up database"
dropdb adxtest
createdb -O twenty adxtest
cat adx_sample.sql |psql adxtest
psql -c "REASSIGN OWNED BY $USER TO twenty" adxtest

echo "starting dhis2"
dhis2-startup twenty

echo "wait a while for tomcat to get its listening port open"
sleep 10

echo "Posting adx data - will take a while as dhis2 starts up"
curl -u admin:district -X POST -H "Content-Type: application/xml" -d @data.xml 'http://localhost:8081/twenty/ohie/dataValueSets?dataElementIdScheme=code&orgUnitIdScheme=code' |xmllint --format -

