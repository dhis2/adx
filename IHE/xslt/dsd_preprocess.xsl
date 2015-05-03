<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mes="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message"
    
    exclude-result-prefixes="xs"
    version="1.0">

<!-- 
     Stylesheet to pre-process an SDMX 2.1 DSD to pull in external references 
-->
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" indent="yes" />

   <!-- The default action is to just copy each node to output - identity template --> 
   <xsl:template match="/ | @* | node()">
         <xsl:copy>
               <xsl:apply-templates select="@* | node()" />
         </xsl:copy>
   </xsl:template>

<!-- Copy in external references where indicated --> 
    <xsl:template match="*[@isExternalReference = 'true' and @structureURL]">
        <xsl:message>
            External reference for <xsl:value-of select="name()"/> fetched from <xsl:value-of select="@structureURL"/>
        </xsl:message>
        <xsl:variable name="elementName" select="name()"/>
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="agencyID" select="@agencyID"/>
        <xsl:variable name="version" select="@version"/>
        <xsl:copy-of select="document(@structureURL)//*[name()=$elementName
            and @id=$id and @agencyID=$agencyID and @version=$version]" />
    </xsl:template>
</xsl:stylesheet>