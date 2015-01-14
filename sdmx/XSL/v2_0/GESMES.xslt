<?xml version="1.0"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic"
version="1.0">
	<xsl:output method="text"/>
	<xsl:include href="GESMES_GenericData.xslt"/>
	<xsl:include href="GESMES_Structure.xslt"/>
	<xsl:include href="GESMES_FreeText.xslt"/>	
	
	<xsl:decimal-format name="DEIT" decimal-separator="," grouping-separator="."/>
	<xsl:decimal-format name="FR" decimal-separator="," grouping-separator=" "/>
		
	<xsl:template match="/">UNA:+.? '
UNB+UNOC:3+<xsl:value-of select="*/message:Header/message:Sender/@id"/>+<xsl:choose><xsl:when test="*/message:Header/message:Receiver/@id"><xsl:value-of select="*/message:Header/message:Receiver/@id"/></xsl:when><xsl:otherwise>ZZZ</xsl:otherwise></xsl:choose>+<xsl:value-of select="substring(*/message:Header/message:Prepared,3,2)"/>
				<xsl:value-of select="substring(*/message:Header/message:Prepared,6,2)"/>
				<xsl:value-of select="substring(*/message:Header/message:Prepared,9,2)"/>:<xsl:choose><xsl:when test="string-length(*/message:Header/message:Prepared) > 11"><xsl:value-of select="substring(*/message:Header/message:Prepared,12,2)"/><xsl:value-of select="substring(*/message:Header/message:Prepared,15,2)"/></xsl:when><xsl:otherwise>0000</xsl:otherwise></xsl:choose>+IREF000001++SDMX-EDI<xsl:choose>
					<xsl:when test="*/message:Header/message:Test='true'">
						<xsl:value-of select="'++++1'"/>
					</xsl:when>
				</xsl:choose>'<xsl:apply-templates/>
UNZ+1+IREF000001'
	</xsl:template>

</xsl:stylesheet>
