<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:msg="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message"
	xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure"
    exclude-result-prefixes="xs msg structure"
    version="1.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    
    <xsl:variable name="dimensions" 
        select="//structure:Dimension/@conceptRef"/>
    <xsl:variable name="timeDimension" 
        select="//structure:TimeDimension/@conceptRef"/>

    <xsl:template match="/msg:Structure">
        
        <schema xmlns="http://purl.oclc.org/dsdl/schematron" >
            
            <pattern id="attribute">
                <rule context="dataValue">
                    
                    <xsl:for-each select="$dimensions">
                        <xsl:element name="assert">
                            <xsl:attribute name="test">
                                <xsl:text>(count( ancestor-or-self::node()[@</xsl:text>
                                <xsl:value-of select='.'/>
                                <xsl:text>]) = 1 )</xsl:text>
                            </xsl:attribute>
                            <xsl:text>
                            </xsl:text>
                             <xsl:text>A dataValue must have a @</xsl:text><xsl:value-of select="."/>
                            <xsl:text> attribute only if not defined at outer layer
                            </xsl:text>
                        </xsl:element>
                    </xsl:for-each>
                    
                    <xsl:element name="assert">
                        <xsl:attribute name="test">
                            <xsl:text>(count( ancestor-or-self::node()[@</xsl:text>
                            <xsl:value-of select='$timeDimension'/>
                            <xsl:text>]) = 1 )</xsl:text>
                        </xsl:attribute>
                        <xsl:text>
                            </xsl:text>
                        <xsl:text>A dataValue must have a @</xsl:text><xsl:value-of select="$timeDimension"/>
                        <xsl:text> attribute only if not defined at outer layer
                            </xsl:text>
                    </xsl:element>
                    
                </rule>
            </pattern>
            
        </schema>

    </xsl:template>

</xsl:stylesheet>