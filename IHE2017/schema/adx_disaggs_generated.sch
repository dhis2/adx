<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
  xmlns:str="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure" 
  xmlns:com="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common" >
  
  <sch:ns uri="urn:ihe:qrph:adx:2015" prefix="adx"/>
  
  <sch:pattern>
    <sch:title>Validating ADX aggregations</sch:title>
    <sch:p> The ADX xsd schema validates that correct codes are used in code lists. Applying
                this set of rules in addition ensures that datavalues are reported with the correct
                disaggregations. </sch:p>
    <sch:rule context="adx:dataValue[@dataElement='MAL01']">
      <sch:assert test="not(@ageGroup)">@ageGroup is not permitted on element MAL01</sch:assert>
      <sch:assert test="not(@sex)">@sex is not permitted on element MAL01</sch:assert>
      <sch:assert test="not(@mechanism)">@mechanism is not permitted on element MAL01</sch:assert>
    </sch:rule>
    <sch:rule context="adx:dataValue[@dataElement='MAL02']">
      <sch:assert test="not(@ageGroup)">@ageGroup is not permitted on element MAL02</sch:assert>
      <sch:assert test="not(@sex)">@sex is not permitted on element MAL02</sch:assert>
      <sch:assert test="not(@mechanism)">@mechanism is not permitted on element MAL02</sch:assert>
    </sch:rule>
    <sch:rule context="adx:dataValue[@dataElement='MAL03']">
      <sch:assert test="not(@ageGroup)">@ageGroup is not permitted on element MAL03</sch:assert>
      <sch:assert test="not(@sex)">@sex is not permitted on element MAL03</sch:assert>
      <sch:assert test="not(@mechanism)">@mechanism is not permitted on element MAL03</sch:assert>
    </sch:rule>
    <sch:rule context="adx:dataValue[@dataElement='MAL04']">
      <sch:assert test="@ageGroup">@ageGroup must be present on element MAL04</sch:assert>
      <sch:assert test="@sex">@sex must be present on element MAL04</sch:assert>
      <sch:assert test="not(@mechanism)">@mechanism is not permitted on element MAL04</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
