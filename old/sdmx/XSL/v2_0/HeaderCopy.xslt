<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message"
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" 
exclude-result-prefixes="xsl message common"
version="1.0">
     <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
     <xsl:strip-space elements="*"/>
     <xsl:template mode="CopyHeader" match="*">
          <xsl:param name="KeyFamID">notPassed</xsl:param>
          <xsl:element name="Header">
               <xsl:apply-templates mode="copy-no-ns" select="message:ID"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:Test"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:Truncated"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:Name"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:Prepared"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:Sender"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:Receiver"/>
               <xsl:choose>
                    <xsl:when test="message:KeyFamilyRef">
                         <xsl:apply-templates mode="copy-no-ns" select="message:KeyFamilyRef"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:element name="KeyFamilyRef">
                              <xsl:value-of select="$KeyFamID"/>
                         </xsl:element>
                    </xsl:otherwise>
               </xsl:choose>
               <xsl:apply-templates mode="copy-no-ns" select="message:KeyFamilyAgency"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:DataSetAgency"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:DataSetID"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:DataSetAction"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:Extracted"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:ReportingBegin"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:ReportingEnd"/>
               <xsl:apply-templates mode="copy-no-ns" select="message:Source"/>
          </xsl:element>
     </xsl:template>
     <xsl:template mode="copy-no-ns" match="*">
          <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
               <xsl:copy-of select="@*"/>
               <xsl:apply-templates mode="copy-no-ns"/>
          </xsl:element>
     </xsl:template>
</xsl:stylesheet>
