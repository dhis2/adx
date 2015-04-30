<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
    queryBinding="xslt"
    xmlns:h="http://www.w3.org/1999/xhtml">
    
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
                There shall be a single mes:Structures element in the message.
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
            
            <let name="ADX_Concepts" value="str:Concepts/str:ConceptScheme[
                @id='ADX_MANDATORY_CONCEPTS' and @agencyID='IHE_QRPH']"/>
            
            <assert
                test="count($ADX_Concepts)=1">
                There shall be a ConceptScheme with @id='ADX_MANDATORY_CONCEPTS' and
                @agencyID='IHE_QRPH'.
            </assert>

        </rule>
    </pattern>
    
    <pattern>
        <title>Testing for mandatory concepts</title>
        <p>An ADX profiled DSD is required to provide concepts for
        dataElement, orgUnit, period and value within the mandatory
        ADX concept scheme.</p>
        
        <rule context="str:Concepts/str:ConceptScheme[
            @id='ADX_MANDATORY_CONCEPTS' and @agencyID='IHE_QRPH']">
            
            <assert
                test="count(str:Concept)=4">
                There are 4 mandatory concepts.
            </assert>
            
            <assert
                test="count(str:Concept[@id='dataElement'])=1">
                There shall be a concept with @id='dataElement'.
            </assert>
            
            <assert
                test="count(str:Concept[@id='orgUnit'])=1">
                There shall be a concept with @id='orgUnit'.
            </assert>
            
            <assert
                test="count(str:Concept[@id='period'])=1">
                There shall be a concept with @id='period'.
            </assert>

            <assert
                test="count(str:Concept[@id='value'])=1">
                There shall be a concept with @id='value'.
            </assert>
            
        </rule>
    </pattern>
        
    <pattern>
        <title>Testing for mandatory dimensions</title>
        
        <let name="components" value="str:DataStructureComponents" />
        <let name="dimensions" value="$components/str:DimensionList"/>
        
        <rule context="str:DataStructure/str:DataStructureComponents">
            
            <assert test="count(str:DimensionList)=1">
                There shall be a DimensionList
            </assert>
            
            <assert test="count(str:Group[@id='OUTER_DIMENSIONS'])=1">
                There shall be a group with @id='OUTER_DIMENSIONS'
            </assert>            
        
        </rule>
        
        <rule context="str:DimensionList">
            <let name="dataElementDimension" value="str:Dimension[@id='dataElement']" />
            <let name="orgUnitDimension"     value="str:Dimension[@id='orgUnit']" />
            <let name="periodDimension"      value="str:TimeDimension[@id='TIME_PERIOD']" />
            
            <assert test="count($dataElementDimension)=1">
                There shall be a dimension with @id='dataElement'. 
            </assert>
            
            <assert test="count($orgUnitDimension)=1">
                There shall be a dimension with @id='orgUnit'. 
            </assert>

            <assert test="count($periodDimension)=1">
                There shall be a TimeDimension with @id='TIME_PERIOD'. 
            </assert>

            <assert 
                test="($dataElementDimension)/str:ConceptIdentity/Ref/@id='dataElement'">
                @id of dataElement concept reference must be 'dataElement'.
            </assert>
            
            <assert 
                test="($dataElementDimension)/str:ConceptIdentity/Ref/@maintainableParentID='ADX_MANDATORY_CONCEPTS'">
                @maintainableParentID of dataElement dimension concept reference 
                must be 'ADX_MANDATORY_CONCEPTS'.
            </assert>
                        
            <assert 
                test="($orgUnitDimension)/str:ConceptIdentity/Ref/@id='orgUnit'">
                @id of orgUnit concept reference must be 'dataElement'.
            </assert>

            <assert 
                test="($orgUnitDimension)/str:ConceptIdentity/Ref/@maintainableParentID='ADX_MANDATORY_CONCEPTS'">
                @maintainableParentID of mandatory dimensions concept reference 
                must be 'ADX_MANDATORY_CONCEPTS'.
            </assert>
            
            <assert 
                test="($periodDimension)/str:ConceptIdentity/Ref/@id='period'">
                @id of orgUnit concept reference must be 'period'.
            </assert>
            
            <assert 
                test="($periodDimension)/str:ConceptIdentity/Ref/@maintainableParentID='ADX_MANDATORY_CONCEPTS'">
                @maintainableParentID of period dimension concept reference 
                must be 'ADX_MANDATORY_CONCEPTS'.
            </assert>
            
            <assert test="count($dataElementDimension/str:LocalRepresentation)=1">
                dataElement dimension must provide LocalRepresentation.
            </assert>        
            
            <assert test="count($orgUnitDimension/str:LocalRepresentation)=1">
                orgUnit dimension must provide LocalRepresentation.
            </assert>        
            
            <let name="periodFormat" value="$periodDimension/str:LocalRepresentation/str:TextFormat/@textType"/>

            <assert test="$periodFormat='TimeRange' or $periodFormat='DateTime'">
                The time period format must be either 'TimeRange' or 'DateTime'.
            </assert>        
            
        </rule>
        
        <rule context="str:Group[@id='OUTER_DIMENSIONS']">
            
            <assert test="count(str:GroupDimension/str:DimensionReference/Ref[@id='orgUnit'])=1" >
                The orgUnit dimension must be in the 'OUTER_DIMENSIONS' group.
            </assert>
            
            <assert test="count(str:GroupDimension/str:DimensionReference/Ref[@id='TIME_PERIOD'])=1" >
                The period dimension must be in the 'OUTER_DIMENSIONS' group.
            </assert>

            <assert test="count(str:GroupDimension/str:DimensionReference/Ref[@id='dataElement'])=0" >
                The period dimension must be in the 'OUTER_DIMENSIONS' group.
            </assert>
            
        </rule>
        
    </pattern>
    
</schema>