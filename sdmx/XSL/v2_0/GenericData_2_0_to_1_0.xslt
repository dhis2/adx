<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:m2="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message"
xmlns:g2="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic"
xmlns:cmn2="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common"
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message"
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic"
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
exclude-result-prefixes="m2 g2 cmn2 xsl">
	<!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
	<xsl:import href="NamespaceCopy_2_0_to_1_0.xslt"/>
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<!-- Input Parameters -->
	<!-- Message URI: (optional) The location of the SDMX 1.0 Message Schema. This is used to make the validation of the output message simpler. If it is not passed, no schema location will be set) -->
	<xsl:param name="MessageURI">notPassed</xsl:param>
	
	<xsl:variable name="SchemaLoc">
		<xsl:choose>
			<xsl:when test="$MessageURI != 'notPassed'">
				<xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message </xsl:text>
				<xsl:value-of select="$MessageURI"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>notPassed</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Root Level Transformation -->
	<xsl:template match="/m2:GenericData">
		<GenericData>
			<xsl:if test="$SchemaLoc != 'notPassed'">
				<xsl:attribute name="xsi:schemaLocation"><xsl:value-of select="$SchemaLoc"/></xsl:attribute>
			</xsl:if>
			<!-- Header -->
			<xsl:apply-templates mode="copy-no-ns" select="m2:Header"/>
			<!-- Data Set -->
			<xsl:for-each select="m2:DataSet">
				<DataSet>
					<xsl:copy-of select="@keyFamilyURI"/>
					<xsl:apply-templates mode="copy-no-ns" select="*"/>
				</DataSet>
			</xsl:for-each>
		</GenericData>
	</xsl:template>
	
	<!-- Value Copy -->
	<xsl:template mode="copy-no-ns" match="g2:Value">
		<xsl:variable name="NS">
			<xsl:call-template name="ChangeNS">
				<xsl:with-param name="NS" select="namespace-uri(.)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:element name="{name(.)}" namespace="{$NS}">
			<xsl:copy-of select="@*[name() != 'startTime']"/>
			<xsl:apply-templates mode="copy-no-ns"/>
		</xsl:element>
	</xsl:template>

		     
</xsl:stylesheet>
