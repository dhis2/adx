# ADX version 2 - Using FHIR

## Background ##

In 2015 we defined a [profile](http://wiki.ihe.net/index.php/Aggregate_Data_Exchange) for aggregate data exchange which was loosely based on SDMX.  In this 2017 cycle the QRPH Technical Committee was tasked with updating ADX to cater for

 1. the specification of a transport mechanism and
and 
 2. the specification of a fully descriptive exchange of metadata required for ADX data exchange.

Early discussuion suggested we might look to FHIR for things like ValueSets.  That investigation into FHIR has led to the discovery of the FHIR [Questionnaire](https://www.hl7.org/fhir/questionnaire.html) Resource.  Early investigation and discussion within the FHIR community suggests that we might be able to profitably profile the Questionnaire to describe the metadata we need.

An IHE profile is not specifically targetted at DHIS2, but clearly it is our interest to ensure that what we create is a good match for DHIS2 resources.

## What is here?
There is a lot of old stuff which represent earlier ideas under test and samples which are simply bundled under old.

The IHE related work from 2015 is placed under IHE2015.

The new FHIR related work is under IHE2017.

