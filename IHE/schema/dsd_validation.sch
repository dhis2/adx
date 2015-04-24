<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    
    <title>Validation of ADX Data Structure Definition</title>
    
    <ns prefix="mes" uri="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message" />
    <ns prefix="str" uri="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure" />
    <ns prefix="com" uri="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common" />
    
    <pattern>
        <title>Check mandatory concepts</title>
        <rule context="mes:Structures">
            
            <assert
                test="str:Concepts/str:ConceptScheme[
                @id='ADX_MANDATORY_CONCEPTS' and @agencyID='IHE' and @version='1.0']"
                >There must be a ConceptScheme with @id='ADX_MANDATORY_CONCEPTS' and
                @agencyID='IHE' and @version='1.0' </assert>
            
            <assert test="count(str:DataStructures/str:DataStructure)=1" >
                There must be exactly one DataStructure defined in the DSD
            </assert>
        </rule>
    </pattern>
    
</schema>