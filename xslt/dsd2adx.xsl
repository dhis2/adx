<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:msg="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message"
	xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure"
    exclude-result-prefixes="xs"
    version="1.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    
    <xsl:template match="/msg:Structure">
        <xsl:variable name="primaryMeasure" 
            select="//structure:Keyfamily[@id='ADX']/structure:PrimaryMeasure/@conceptref"/>

        <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"
            xmlns:vc="http://www.w3.org/2007/XMLSchema-versioning" vc:minVersion="1.1">
            
            <xs:element name="dataValueSet" type="dataValueSetType"/>
            
            <xs:complexType name="dataValueSetType">
                <xs:sequence>
                    <xs:element name="dataValue" type="dataValueType" maxOccurs="unbounded"/>
                </xs:sequence>
                <xs:anyAttribute processContents="skip"/>
            </xs:complexType>
            
            <xs:complexType name="dataValueType">
                <xs:attribute name="{$primaryMeasure}" use="required" />
                <xs:anyAttribute processContents="skip"/>
            </xs:complexType>

        </xs:schema>
            
    </xsl:template>

</xsl:stylesheet>