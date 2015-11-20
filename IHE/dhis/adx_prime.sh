#!/bin/bash
# A short test script to test adx import to dhis
# It uses dhis2-tools to start and stop the test instance
# It should be easily modified to suit your test environment

DBNAME=twenty
DBOWNER=twenty
# The name of the dhis instance
DHISNAME=twenty
# The url of the test instance
DHISURL="http://localhost:8080/twenty"

echo "Shutdown instance if running"
dhis2-shutdown $DHISNAME
sleep 3
# Start with a blank database
echo "Setting up database"
dropdb $DBNAME
createdb -O $DBOWNER $DBNAME
# Load some sample metadata
cat adx_sample.sql |psql $DBNAME
psql -c "REASSIGN OWNED BY $USER TO $DBOWNER" $DBNAME

echo "starting dhis2"
dhis2-startup $DHISNAME

echo "wait a while for tomcat to get its listening port open"
sleep 10

echo "Posting adx data - will take a while as dhis2 starts up"
curl -u admin:district -X POST -H "Content-Type: application/xml" -d @data.xml "$DHISURL/ohie/dataValueSets?dataElementIdScheme=CODE&orgUnitIdScheme=CODE" |xmllint --format -

