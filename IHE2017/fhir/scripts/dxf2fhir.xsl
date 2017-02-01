<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:d="http://dhis2.org/schema/dxf/2.0"
    xmlns="http://hl7.org/fhir" exclude-result-prefixes="xs" version="1.0">

    <xsl:output indent="yes" method="xml"/>
    
    <xsl:variable name="map" select="document('type_map.xml')/map"/>
    
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model">
            <xsl:text>href="schema/questionnaire.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron</xsl:text>
        </xsl:processing-instruction>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="d:dataSet">
        <Questionnaire xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://hl7.org/fhir schema/questionnaire.xsd">

            <id value="{@id}"/>
            <status value="published"/>
            <title value="{d:displayName}"/>

            <xsl:apply-templates select="d:dataSetElements"/>
        </Questionnaire>
    </xsl:template>

    <xsl:template match="d:dataElement">
        <item id="{@id}">
            <text value="{d:displayName}"/>
            <type value="group"/>
            <xsl:apply-templates select="d:categoryCombo"/>
        </item>
    </xsl:template>

    <xsl:template match="d:categoryOptionCombo">
        <xsl:variable name="de" select="ancestor::d:dataElement"/>
        <xsl:variable name="id" select="concat($de/@id, '.', @id)"/>
        <xsl:variable name="map" select="document('type_map.xml')/d:map" />
        <xsl:variable name="type" select="$map/d:type[@dhis=$de/d:valueType]/@fhir"/>
        
        <item id="{$id}">
            <text value="{@name}"/>
            <type value="{document('type_map.xml')/d:map/d:type[@dhis=$de/d:valueType]/@fhir}"/>
        </item>
    </xsl:template>

</xsl:stylesheet>
