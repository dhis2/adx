## Process description
(This section needs updating)
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
~                                                                                     
