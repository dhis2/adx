<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:d="http://dhis2.org/schema/dxf/2.0"
    exclude-result-prefixes="xs" version="1.0">

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="d:dataSetElement/d:categoryCombo"/>

    <xsl:template match="d:dataElement/d:categoryCombo">
        <xsl:choose>
            <xsl:when test="../../d:categoryCombo">
                <xsl:copy-of select="../../d:categoryCombo"/>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
