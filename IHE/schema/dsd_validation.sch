<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt">
    
    <title>Validation of ADX Data Structure Definition</title>
    <p>An ADX profiled Data Structure Definition (DSD) is 
        (i)   a well formed XML document and
        (ii)  a valid SDMX 2.1 Strucure message and
        (iii) is further subject to additional constraints expressed in
        this schematron schema.
    </p>
    
    <p>The following are namespaces defined in SDMX 2.1 which are used in
    an ADX profiled DSD</p>
    <ns prefix="mes" uri="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message" />
    <ns prefix="str" uri="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure" />
    <ns prefix="com" uri="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common" />
    
    <pattern>
        <title>Testing that Structures are all present</title>
        <rule context="mes:Structure">
            <assert test="count(mes:Structures)=1">
                There shall be a single str:Structures element in the message.
            </assert>
        </rule>
        
        <rule context="mes:Structures" >
            <assert test="count(str:Codelists)=1">
                There shall be a single Codelists element.
            </assert>
            
            <assert test="count(str:Concepts)=1">
                There shall be a single Concepts element.
            </assert>
            
            <assert test="count(str:DataStructures/str:DataStructure)=1">
                There shall be a single DataStructure element.
            </assert>

            <assert test="str:DataStructures/str:DataStructure/@id='ADX'">
                The DataStructure element @id attribute shall be 'ADX'  
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <title>Testing for mandatory concepts</title>
        <p>An ADX profiled DSD is required to provide concepts for
        dataElement, orgUnit, period and value within the mandatory
        ADX concept scheme.</p>
        
        <rule context="str:Concepts">
            
            <let name="ADX_Concepts" value="str:ConceptScheme[
                @id='ADX_MANDATORY_CONCEPTS' and @agencyID='IHE']"/>
            
            <assert
                test="count($ADX_Concepts)=1">
                There shall be a ConceptScheme with @id='ADX_MANDATORY_CONCEPTS' and
                @agencyID='IHE'.
            </assert>
            
            <assert
                test="$ADX_Concepts/str:Concept[@id='dataElement']">
                There shall be a concept with @id='dataElement'.
            </assert>
            
            <assert
                test="$ADX_Concepts/str:Concept[@id='orgUnit']">
                There shall be a concept with @id='orgUnit'.
            </assert>
            
            <assert
                test="$ADX_Concepts/str:Concept[@id='period']">
                There shall be a concept with @id='period'.
            </assert>

            <assert
                test="$ADX_Concepts/str:Concept[@id='value']">
                There shall be a concept with @id='value'
            </assert>
            
        </rule>
    </pattern>
    
    <pattern>
        <title>Testing for mandatory dimensions</title>
        
        <rule context="str:DataStructure">
            <let name="components" value="str:DataStructureComponents" />
            <let name="dimensions" value="$components/str:DimensionList"/>
            
            <assert test="$dimensions">
                There shall be a DimensionList
            </assert>
            
            <assert test="$dimensions/str:Dimension[@id='dataElement']">
                There shall be a dimension with @id='dataElement' 
            </assert>
            
            <assert test="$dimensions/str:Dimension[@id='orgUnit']">
                There shall be a dimension with @id='orgUnit' 
            </assert>

            <assert test="$dimensions/str:Dimension[@id='orgUnit']">
                There shall be a dimension with @id='orgUnit' 
            </assert>
            
            <assert test="$components/str:Group[@id='OUTER_DIMENSIONS']">
                There shall be a group with @id='OUTER_DIMENSIONS'
            </assert>            
        </rule>
        
        <rule context="str:Dimension[@id='dataElement']">
            <let name="ref" value="str:ConceptIdentity/Ref"/>
            
            <assert test="$ref/@id='dataElement'">
                @id of dataElement dimension concept reference must be 'dataElement'.
            </assert>
            
            <assert test="$ref/@maintainableParentID='ADX_MANDATORY_CONCEPTS'">
                @maintainableParentID of dataElement dimension concept reference 
                must be 'ADX_MANDATORY_CONCEPTS'.
            </assert>
            
            <assert test="$ref/@agencyID='IHE'">
                @agencyId of dataElement dimension concept reference must be 'IHE'.
            </assert>
        </rule>

        <rule context="str:Dimension[@id='orgUnit']">
            <let name="ref" value="str:ConceptIdentity/Ref"/>
            
            <assert test="$ref/@id='orgUnit'">
                @id of dataElement dimension concept reference must be 'dataElement'.
            </assert>
            
            <assert test="$ref/@maintainableParentID='ADX_MANDATORY_CONCEPTS'">
                @maintainableParentID of dataElement dimension concept reference 
                must be 'ADX_MANDATORY_CONCEPTS'.
            </assert>
            
            <assert test="$ref/@agencyID='IHE'">
                @agencyId of dataElement dimension concept reference must be 'IHE'.
            </assert>
        </rule>
        
        <rule context="str:TimeDimension">
        </rule>
    </pattern>
    
    
</schema>