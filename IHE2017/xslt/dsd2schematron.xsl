<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:str="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure"
    xmlns:com="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    exclude-result-prefixes="xs" version="1.0">

    <xsl:output encoding="UTF-8" xml:space="preserve" method="xml" indent="yes"/>

<!--  
        This stylesheet is a normative part of the ADX profile (urn:ihe:qrph:adx:2015)
        
        When applied to an ADX conformant SDMX Data Structure Definition it emits
        a W3C XML Schema document sutiable for validation of ADX data payloads.
-->

<!-- ===============================================================================
     Variable declarations
     ================================================================ -->

    <!-- The dataSet identifier -->
    <xsl:variable name="dataSetId" 
        select="//str:DataStructure/@id"/>
    
    <xsl:variable name="customConcepts" 
        select="//str:ConceptScheme[not(@id='ADX_MANDATORY_CONCEPTS')]/str:Concept/@id" />
    
<!-- ===============================================================================
     Root Template Match
     =============================================================================== -->
    
    <xsl:template match="/">

        <sch:schema >
            
            <sch:ns uri="urn:ihe:qrph:adx:2015" prefix="adx"/>
            <xsl:apply-templates select="//str:Codelist[@id='CL_DataElements']"/>
                                  
        </sch:schema>
    </xsl:template>
    
    <xsl:template match="str:Codelist">
        <sch:pattern >
            <sch:title>Validating ADX aggregations</sch:title>
            <sch:p> The ADX xsd schema validates that correct codes are used in code lists. Applying
                this set of rules in addition ensures that datavalues are reported with the correct
                disaggregations. </sch:p>

            <xsl:apply-templates select="str:Code"/>

        </sch:pattern>
    </xsl:template>
    
    <xsl:template match="str:Code">
        <xsl:variable name="apos">'</xsl:variable>
        <xsl:variable name="code" select="@id"/>
        <xsl:variable name="context" select="concat('adx:dataValue[@dataElement=',$apos,$code,$apos,']')"/>
        <xsl:variable name="disaggs" select="com:Annotations/com:Annotation[@id='Disaggregation']/com:AnnotationText"/>
        
        <sch:rule context="{$context}">
            <!--<sch:assert test="not(@sex or @ageGroup)">
                @ageGroup or @sex attribute not permitted for dataElement "MAL01"
            </sch:assert>-->
            
            <xsl:for-each select="$customConcepts">
                <xsl:choose>
                    <xsl:when test=".=$disaggs">
                        <xsl:variable name="test" select="concat('@',.)"/>
                        <sch:assert test="{$test}">
                            <xsl:value-of select="concat('@',.,' must be present on element ',$code)"/>
                        </sch:assert>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="test" select="concat('@',.)"/>
                        <sch:assert test="not({$test})">
                            <xsl:value-of select="concat('@',.,' is not permitted on element ',$code)"/>
                        </sch:assert>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </sch:rule>    
        
    </xsl:template>

</xsl:stylesheet>
