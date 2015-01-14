<?xml version="1.0"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:saxon="http://icl.com/saxon" 
extension-element-prefixes="saxon"
version="1.0">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" saxon:indent-spaces="5"/>
<xsl:strip-space elements="*"/>

<xsl:template match="/"><xsl:copy-of select="."/></xsl:template>

<!--
<xsl:template match="/">
    <xsl:copy><xsl:apply-templates select="*|@*|comment()|processing-instruction()|text()" mode="copyall"/></xsl:copy>
</xsl:template>

<xsl:template mode="copyall" match="*|@*|comment()|processing-instruction()|text()">
    <xsl:copy><xsl:apply-templates mode="copyall" select="*|@*|comment()|processing-instruction()|text()"/></xsl:copy>
</xsl:template>
-->
</xsl:stylesheet>