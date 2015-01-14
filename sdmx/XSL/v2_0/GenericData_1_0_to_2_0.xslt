<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:m1="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message"
xmlns:g1="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic"
xmlns:cmn1="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common"
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message"
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic"
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
exclude-result-prefixes="m1 g1 cmn1 xsl">
	<!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
	<xsl:import href="NamespaceCopy_1_0_to_2_0.xslt"/>
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<!-- Input Parameters -->
	<!-- Message URI: (optional) The location of the SDMX 2.0 Message Schema. This is used to make the validation of the output message simpler. If it is not passed, no schema location will be set) -->
	<xsl:param name="MessageURI">notPassed</xsl:param>
	
	<xsl:variable name="SchemaLoc">
		<xsl:choose>
			<xsl:when test="$MessageURI != 'notPassed'">
				<xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message </xsl:text>
				<xsl:value-of select="$MessageURI"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>notPassed</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Root Level Transformation -->
	<xsl:template match="/m1:GenericData">
		<GenericData>
			<xsl:if test="$SchemaLoc != 'notPassed'">
				<xsl:attribute name="xsi:schemaLocation"><xsl:value-of select="$SchemaLoc"/></xsl:attribute>
			</xsl:if>
			<!-- Copy All -->
			<xsl:apply-templates mode="copy-no-ns" select="*"/>
		</GenericData>
	</xsl:template>
		     
</xsl:stylesheet>
