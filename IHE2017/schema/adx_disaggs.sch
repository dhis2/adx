<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <sch:ns uri="urn:ihe:qrph:adx:2015" prefix="adx"/>
    <sch:pattern>
        <sch:title>Validating ADX aggregations</sch:title>
        <sch:p>
            The ADX xsd schema validates that correct codes are used in
            code lists.  Applying this set of rules in addition ensures
            that datavalues are reported with the correct disaggregations.
        </sch:p>
        
        <sch:rule context="adx:dataValue[@dataElement='MAL01']">
            <sch:assert test="not(@sex or @ageGroup)">
                @ageGroup or @sex attribute not permitted for dataElement "MAL01"
            </sch:assert>
        </sch:rule>
        <sch:rule context="adx:dataValue[@dataElement='MAL02']">
            <sch:assert test="not(@sex or @ageGroup)">
                @ageGroup or @sex attribute not permitted for dataElement "MAL02"                
            </sch:assert>
        </sch:rule>
        <sch:rule context="adx:dataValue[@dataElement='MAL03']">
            <sch:assert test="not(@sex or @ageGroup)">
                @ageGroup or @sex attribute not permitted for dataElement "MAL03"
            </sch:assert>
        </sch:rule>
        <sch:rule context="adx:dataValue[@dataElement='MAL04']">
            <sch:assert test="@sex and @ageGroup">
                dataElement "MAL04" requires @agegroup and @sex disaggregation
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>