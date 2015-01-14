<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

<pattern id="attribute">
    <rule context="dataValue">
        <assert test="(count( ancestor-or-self::node()[@dataElement]) = 1 )"  
            >A dataValue must have a @dataElement attribute only if not defined at outer layer</assert>
        
        <assert test="(count( ancestor-or-self::node()[@orgUnit]) = 1 )"  
            >A dataValue must have a @orgUnit attribute only if not defined at outer layer</assert>
        
        <assert test="(count( ancestor-or-self::node()[@period]) = 1 )"
            >A dataValue must have a @period attribute only if not defined at outer layer</assert>
    </rule>
</pattern>

</schema>