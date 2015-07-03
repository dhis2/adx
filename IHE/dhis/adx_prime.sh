#!/bin/bash
# A short test script to test adx import to dhis
# It uses dhis2-tools to start and stop the test instance
# It should be easily modified to suit your test environment

DBNAME=adxtest
DBOWNER=twenty
# The name of the dhis instance
DHISNAME=twenty
# The url of the test instance
DHISURL="http://localhost:8081/twenty"

echo "Shutdown instance if running"
dhis2-shutdown twenty
sleep 3
# Start with a blank database
echo "Setting up database"
dropdb adxtest
createdb -O twenty adxtest
# Load some sample metadata
cat adx_sample.sql |psql adxtest
psql -c "REASSIGN OWNED BY $USER TO twenty" adxtest

echo "starting dhis2"
dhis2-startup twenty

echo "wait a while for tomcat to get its listening port open"
sleep 10

echo "Posting adx data - will take a while as dhis2 starts up"
curl -u admin:district -X POST -H "Content-Type: application/xml" -d @data.xml "$DHISURL/ohie/dataValueSets?dataElementIdScheme=code&orgUnitIdScheme=code" |xmllint --format -

