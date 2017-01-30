<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:m1="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message"
exclude-result-prefixes="xsl m1"
version="1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template mode="copy-no-ns" match="*">
		<xsl:variable name="NS">
			<xsl:call-template name="ChangeNS">
				<xsl:with-param name="NS" select="namespace-uri(.)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:element name="{name(.)}" namespace="{$NS}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="copy-no-ns">
				<xsl:with-param name="NS">
					<xsl:value-of select="$NS"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="ChangeNS">
		<xsl:param name="NS">notPassed</xsl:param>
		<xsl:choose>
			<xsl:when test="$NS = 'http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message'">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message</xsl:when>
			<xsl:when test="$NS = 'http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure'">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure</xsl:when>
			<xsl:when test="$NS = 'http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic'">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic</xsl:when>
			<xsl:when test="$NS = 'http://www.SDMX.org/resources/SDMXML/schemas/v1_0/utility'">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility</xsl:when>
			<xsl:when test="$NS = 'http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact'">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact</xsl:when>
			<xsl:when test="$NS = 'http://www.SDMX.org/resources/SDMXML/schemas/v1_0/cross'">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross</xsl:when>
			<xsl:when test="$NS = 'http://www.SDMX.org/resources/SDMXML/schemas/v1_0/query'">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/query</xsl:when>
			<xsl:when test="$NS = 'http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common'">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- Header Specific -->
	
	<!-- Map Data Set Action -->
	<xsl:template match="m1:DataSetAction" mode="copy-no-ns">
		<xsl:element name="DataSetAction" namespace="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message">
			<xsl:choose>
				<xsl:when test=". = 'Update'">Replace</xsl:when>
				<xsl:when test=". = 'Delete'">Delete</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>
