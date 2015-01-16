# ADX definition, samples and tests

ADX is an data exchange profile being prepared by QRPH 
technical committtee of IHE.net.  This repository in no way represents
the official work of that committee.  What I have here is a scratchpad
for testing and sharing various ideas.

## What is here?
1. Under the sdmx directory there is an SDMX 2.0 Data Structure Definition (DSD)
which defines the structure of ADX data.
2. Under the xslt directory are 2 transforms which operate on the DSD to generate
the schema to validate an ADX data message. These are a W3C XSD schema and an ISO 
Schematron schema.
3. Under the sample directory there are various valid and invalid ADX files for
testing against tyhe schema.

## Process description
The structure of ADX data is represented by an SDMX profile of a Data Structure Definition.

The W3C schema for ADX can be derived from the DSD with:
```bash
xsltproc xslt/dsd2adx.xsl sdmx/ADXStructure.xml > schema/adx.xsd
```

The Schematron schema can be derived with:
```bash
xsltproc xslt/dsd2adxsch.xsl sdmx/ADXStructure.xml > schema/adx.sch
```

Sample messages can be validated with:
```bash
xmllint --noout --schema schema/adx.xsd sample/adx_sample.xml 
xmllint --noout --schematron schema/adx.sch sample/adx_sample.xml
``` 
