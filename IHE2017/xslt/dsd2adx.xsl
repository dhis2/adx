<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:str="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure"
    exclude-result-prefixes="xs" version="1.0">

    <xsl:output encoding="UTF-8" xml:space="preserve" method="xml" indent="yes"/>

<!-- ===============================================================================
     Variable declarations
     =============================================================================== -->
    <!-- Dimension nodes -->
    <xsl:variable name="dimensions" select="//str:DimensionList/str:Dimension"/>

    <!-- Jurisdiction specific Dimensions at group level -->
    <xsl:variable name="outerDimensions"
        select="$dimensions[//str:Group[@id='OUTER_DIMENSIONS']/descendant::Ref/@id = @id
        and @id != 'orgUnit']"/>

    <!-- Jurisdiction specific Dimensions at dataValue level -->
    <xsl:variable name="innerDimensions"
        select="$dimensions[not (//str:Group[@id='OUTER_DIMENSIONS']/descendant::Ref/@id = @id )
        and str:ConceptIdentity/Ref/@id != 'dataElement']"/>

    <!-- Reference to the orgUnit code list -->
    <xsl:variable 
        name="orgUnitCLRef" 
        select="$dimensions[str:ConceptIdentity/Ref/@id='orgUnit']/str:LocalRepresentation/str:Enumeration/Ref" />

    <xsl:variable name="orgUnitType"
        select="concat($orgUnitCLRef/@id,'_',$orgUnitCLRef/@agencyID,'_',$orgUnitCLRef/@version,'_Type')" />
 
    <!-- Reference to the dataElement code list -->
    <xsl:variable 
        name="dataElementCLRef" 
        select="$dimensions[str:ConceptIdentity/Ref/@id='dataElement']/str:LocalRepresentation/str:Enumeration/Ref" />
    
    <xsl:variable name="dataElementType"
        select="concat($dataElementCLRef/@id,'_',$dataElementCLRef/@agencyID,'_',$dataElementCLRef/@version,'_Type')" />
 
    <xsl:variable name="dataSetId" 
        select="//str:DataStructure/@id"/>
    
    <!-- ===============================================================================
     Template Match
     =============================================================================== -->
    
    <xsl:template match="/">

        <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns="http://ihe.net/quality/schema/adx"
            xmlns:common="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common"
            targetNamespace="http://ihe.net/quality/schema/adx" elementFormDefault="qualified">

            <!--  Copyright notice -->

            <xs:annotation>
                <xs:documentation> This is an example of a tightly constrained schema which should
                    validate an adx data document which has been formed in compliance with the
                    sample SDMX DSD. </xs:documentation>
            </xs:annotation>
            
            <xs:import namespace="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common"
                schemaLocation="sdmx/SDMXCommon.xsd"/>

            <!-- TODO: restrict the allowable SDMX timeperiod types (there are too many)
    <xs:simpleType name="adxTimePeriodType">
    <xs:restriction base="common:ObservationalTimePeriodType">
      ...
    </xs:restriction>
  </xs:simpleType>
-->

<!-- ================================================================================
     Type restrictions derived from SDMX DSD Codelists
     ================================================================================= -->
            <xsl:for-each select="//str:Codelist">
                <xsl:variable name="type" select="concat(@id,'_',@agencyID,'_',@version,'_Type')"/>
                <xs:simpleType name="{$type}">
                    <xs:restriction base="xs:token">
                        <xsl:for-each select="str:Code">
                            <xs:enumeration value="{@id}"/>
                        </xsl:for-each>
                    </xs:restriction>
                </xs:simpleType>
            </xsl:for-each>

<!-- ================================================================================
    ADX Root element type
    ================================================================================= -->
            <xs:complexType name="adxType">
                <xs:sequence maxOccurs="unbounded">
                    <xs:element name="group" type="groupType"/>
                </xs:sequence>
                <xs:attribute name="exported" use="required" type="xs:dateTime"/>
                <xs:anyAttribute processContents="skip"/>
            </xs:complexType>

<!-- ================================================================================
     Element types derived from SDMX DSD DataStructure
     ================================================================================= -->
            <xs:complexType name="groupType">
                <xs:sequence maxOccurs="unbounded">
                    <xs:element name="dataValue" type="DataValueType"/>
                </xs:sequence>
                <xs:attribute name="dataSet" use="required" type="xs:string" fixed="{$dataSetId}"/>
                <xs:attribute name="orgUnit" use="required" type="{$orgUnitType}"/>
                <xs:attribute name="period" use="required" type="common:ObservationalTimePeriodType"/>
                
                <xsl:for-each select="$outerDimensions">
                    <xsl:variable name="concept" select="str:ConceptIdentity/Ref/@id"/>
                    <xsl:variable name="codelist" select="str:LocalRepresentation/str:Enumeration/Ref"/>  
                    <xsl:variable name="type" select="concat($codelist/@id,'_',$codelist/@agencyID,'_',$codelist/@version,'_Type')"/>

                    <xs:attribute name="{$concept}" type="{$type}" use="required"/>

                </xsl:for-each>

                <xs:anyAttribute processContents="skip"/>
            </xs:complexType>

            <xs:complexType name="DataValueType">
                <xs:sequence maxOccurs="1" minOccurs="0">
                    <xs:element name="annotation" />
                </xs:sequence>
                
                <xs:attribute name="dataElement" use="required" type="{$dataElementType}"/>
                <xs:attribute name="value" use="required" type="xs:decimal"/>

                <xsl:for-each select="$innerDimensions">
                    <xsl:variable name="concept" select="str:ConceptIdentity/Ref/@id"/>
                    <xsl:variable name="codelist" select="str:LocalRepresentation/str:Enumeration/Ref"/>  
                    <xsl:variable name="type" select="concat($codelist/@id,'_',$codelist/@agencyID,'_',$codelist/@version,'_Type')"/>
                    
                    <xs:attribute name="{$concept}" type="{$type}" use="optional"/>

                </xsl:for-each>

                <xs:anyAttribute processContents="skip"/>
                
            </xs:complexType>

<!-- ================================================================================
     ADX document root 
     ================================================================================= -->
            <xs:element name="adx" type="adxType"/>

        </xs:schema>
    </xsl:template>

</xsl:stylesheet>