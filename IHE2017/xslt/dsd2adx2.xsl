<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:str="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure"
    exclude-result-prefixes="xs" version="1.0">

    <xsl:output encoding="UTF-8" xml:space="preserve" method="xml" indent="yes"/>

<!--  
        This stylesheet is a normative part of the ADX profile (urn:ihe:qrph:adx:2015)
        
        When applied to an ADX conformant SDMX Data Structure Definition it emits
        a W3C XML Schema document sutiable for validation of ADX data payloads.
-->

<!-- ===============================================================================
     Variable declarations
     =============================================================================== -->
    <!-- Dimension nodes -->
    <xsl:variable name="dimensions" select="//str:Dimension"/>

    <!-- Jurisdiction specific Dimensions at group level -->
    <xsl:variable name="outerDimensions"
        select="$dimensions[//str:Group[@id='OUTER_DIMENSIONS']/descendant::Ref/@id = @id
          and @id != 'orgUnit']"/>

    <!-- Jurisdiction specific Dimensions at dataValue level -->
    <xsl:variable name="innerDimensions"
        select="$dimensions[not (//str:Group[@id='OUTER_DIMENSIONS']/descendant::Ref/@id = @id )
          and str:ConceptIdentity/Ref/@id != 'dataElement']"/>
    
    <!-- Mandatory dimensions -->
    <xsl:variable name="orgUnitDimension" select="$dimensions[@id='orgUnit']" />
    <xsl:variable name="dataElementDimension" select="$dimensions[@id='dataElement']" />
    
    <!-- Reference to the orgUnit code list -->
    <xsl:variable 
        name="orgUnitCLRef" 
        select="$orgUnitDimension/str:LocalRepresentation/str:Enumeration/Ref" />

    <!-- Construction of the orgUnit type name -->
    <xsl:variable name="orgUnitType"
        select="concat($orgUnitCLRef/@id,'_',$orgUnitCLRef/@agencyID,'_',
          $orgUnitCLRef/@version,'_Type')" />
 
    <!-- Reference to the dataElement code list -->
    <xsl:variable 
        name="dataElementCLRef" 
        select="$dataElementDimension/str:LocalRepresentation/str:Enumeration/Ref" />
    
    <!-- Construction of the dataElement type name -->
    <xsl:variable name="dataElementType"
        select="concat($dataElementCLRef/@id,'_',
          $dataElementCLRef/@agencyID,'_',$dataElementCLRef/@version,'_Type')" />
    
<!-- ===============================================================================
     Root Template Match
     =============================================================================== -->
    
    <xsl:template match="/">

        <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns="urn:ihe:qrph:adx:2015"
            xmlns:common="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common"
            targetNamespace="urn:ihe:qrph:adx:2015" elementFormDefault="qualified">

            <!--  Copyright notice -->

            <xs:annotation>
                <xs:documentation> This is an example of a tightly constrained schema which should
                    validate an adx data document which has been formed in compliance with the
                    sample SDMX DSD. </xs:documentation>
            </xs:annotation>
            
            <xs:import namespace="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common"
                schemaLocation="sdmx/SDMXCommon.xsd"/>
            
            <!-- generate enumerated types for dimensions -->
            <xsl:apply-templates select="//str:Codelist"/>
            
            <!-- generate dateTime type -->
            <xsl:apply-templates select="//str:TimeDimension" />
            
            <!-- generate complex types -->
            <xsl:call-template name="adx" />
            <xsl:call-template name="group" />
            <xsl:call-template name="dataValue" />
            
            <xs:element name="adx" type="adxType"/>
            
        </xs:schema>
    </xsl:template>
    
<!-- ================================================================================
     Complex Element types

     1. ADX Root element type
     ================================================================================= -->
    <xsl:template name="adx">
        <xs:complexType name="adxType">
            <xs:sequence maxOccurs="unbounded">
                <xs:element name="group" type="groupType"/>
            </xs:sequence>
            <xs:attribute name="exported" use="required" type="xs:dateTime"/>
            <xs:anyAttribute processContents="skip"/>
        </xs:complexType>
    </xsl:template>

<!-- ================================================================================
     2.  groupType
     ================================================================================= -->
     <xsl:template name="group">
        <xs:complexType name="groupType">
            <xs:sequence maxOccurs="unbounded">
                <xs:element name="dataValue" type="DataValueType"/>
            </xs:sequence>
            <xs:attribute name="orgUnit" use="required" type="{$orgUnitType}"/>
            <xs:attribute name="period" use="required" type="periodType"/>

            <xsl:apply-templates select="$outerDimensions" />

            <xs:anyAttribute processContents="skip"/>
        </xs:complexType>
     </xsl:template>
    
<!-- ================================================================================
     3.  dataValueType
     ================================================================================= -->
    <xsl:template name="dataValue">
        <xs:complexType name="DataValueType">
                <xs:sequence maxOccurs="1" minOccurs="0">
                    <xs:element name="annotation" />
                </xs:sequence>
                
                <xs:attribute name="dataElement" use="required" type="{$dataElementType}"/>
                <xs:attribute name="value" use="required" type="xs:decimal"/>

                <xsl:apply-templates select="$innerDimensions" />

                <xs:anyAttribute processContents="skip"/>
                
            </xs:complexType>
    </xsl:template>

<!-- ================================================================================
     Type restrictions derived from SDMX DSD Codelists
     ================================================================================= -->
    <xsl:template match="str:Codelist">
        <xsl:variable name="type" select="concat(@id,'_',@agencyID,'_',@version,'_Type')"/>
        <xs:simpleType name="{$type}">
            <xs:restriction base="xs:token">
                <xsl:for-each select="str:Code">
                    <xs:enumeration value="{@id}"/>
                </xsl:for-each>
            </xs:restriction>
        </xs:simpleType>
    </xsl:template>

<!-- ================================================================================
     Time dimension type
     ================================================================================= -->
    <xsl:template match="str:TimeDimension">
        <xsl:variable name="timeFormat" select="str:LocalRepresentation/str:TextFormat"/>
        <xs:simpleType name="periodType">
            <xsl:choose>
                <xsl:when test="$timeFormat/@textType='DateTime'">
                    <xs:restriction base="xs:dateTime"/>
                </xsl:when>
                <xsl:when test="$timeFormat/@textType='TimeRange'"> 
                    <xs:restriction base="common:TimeRangeType"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>
                        Only SDMX DateTime and TimeRange are supported types
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xs:simpleType>
    </xsl:template>
    
<!-- ================================================================================
     Produce attributes for dimension
     ================================================================================= -->
    <xsl:template match="str:Dimension">
        <xsl:variable name="conceptID" select="str:ConceptIdentity/Ref/@id"/>
        <xsl:variable name="conceptSchemeID" select="str:ConceptIdentity/Ref/@maintainableParentID"/>
        
        <xsl:choose>
            <!-- if there is a LocalRepresentation, use that -->
            <xsl:when test="str:LocalRepresentation">
                <xsl:variable name="codelist" select="str:LocalRepresentation/str:Enumeration/Ref"/>
                <xsl:variable name="type"
                    select="concat($codelist/@id,'_',$codelist/@agencyID,'_',$codelist/@version,'_Type')"/>
                <xs:attribute name="{$conceptID}" type="{$type}" use="optional"/>
            </xsl:when>
            <!-- otherwise lookup the CoreRepresentation for the Concept -->
            <xsl:otherwise>
                <xsl:variable name="concept"
                    select="//str:ConceptScheme[
                    @id=$conceptSchemeID]/str:Concept[@id=$conceptID]"/>
                <xsl:variable name="codelist"
                    select="$concept/str:CoreRepresentation/str:Enumeration/Ref"/>
                <xsl:variable name="type"
                    select="concat($codelist/@id,'_',$codelist/@agencyID,'_',$codelist/@version,'_Type')"/>
                <xs:attribute name="{$conceptID}" type="{$type}" use="optional"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        
</xsl:stylesheet>