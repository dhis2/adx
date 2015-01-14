<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" 
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" 
version="1.0">
     <xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/>
     <xsl:strip-space elements="*"/>
     <!-- Input Parameters -->
     <!-- Rows - If any thing is passed in this, data will be formatted into rows, not columns -->
     <xsl:param name="Rows">notPassed</xsl:param>
     <xsl:param name="ObsStatusName">notPassed</xsl:param>
     <xsl:param name="ObsStatusMissingValue">notPassed</xsl:param>     
     <xsl:template match="/">
          <xsl:choose>
               <!-- Data into rows -->
               <xsl:when test="$Rows != 'notPassed'">
                    <!-- Get Data Parameters -->
                    <xsl:variable name="DataSetAtts" select="/message:GenericData/message:DataSet/generic:Attributes/generic:Value/@concept"/>
                    <xsl:variable name="GroupAtts" select="/message:GenericData/message:DataSet/generic:Group/generic:Attributes/generic:Value/@concept[not(ancestor::generic:Group/preceding-sibling::generic:Group/generic:Attributes/generic:Value/@concept = .)]"/>
                    <xsl:variable name="SeriesDims" select="//generic:Series/generic:SeriesKey/generic:Value/@concept[not(preceding::generic:Series/generic:SeriesKey/generic:Value/@concept = .)]"/>
                    <xsl:variable name="SeriesAtts" select="//generic:Series/generic:Attributes/generic:Value/@concept[not(preceding::generic:Series/generic:Attributes/generic:Value/@concept = .)]"/>
                    <xsl:variable name="Times" select="//generic:Obs/generic:Time[not(preceding::generic:Obs/generic:Time = .)]"/>
                    <xsl:for-each select="$DataSetAtts">"<xsl:value-of select="."/>",</xsl:for-each><xsl:for-each select="$GroupAtts">"<xsl:value-of select="."/>",</xsl:for-each><xsl:for-each select="$SeriesDims">"<xsl:value-of select="."/>",</xsl:for-each><xsl:for-each select="$SeriesAtts">"<xsl:value-of select="."/>",</xsl:for-each><xsl:for-each select="$Times"><xsl:sort/>"<xsl:value-of select="."/>",</xsl:for-each><xsl:text>&#10;</xsl:text>
                    <!-- Create Data -->
                    <xsl:for-each select="/message:GenericData/message:DataSet//generic:Series">
                         <xsl:variable name="Series" select="."/>
                         <xsl:for-each select="$DataSetAtts"><xsl:variable name="DSAtt" select="."/>"<xsl:value-of select="$Series/ancestor::message:DataSet/generic:Attributes/generic:Value[@concept = $DSAtt]/@value"/>",</xsl:for-each><xsl:for-each select="$GroupAtts"><xsl:variable name="GAtt" select="."/>"<xsl:value-of select="$Series/ancestor::generic:Group/generic:Attributes/generic:Value[@concept = $GAtt]/@value"/>",</xsl:for-each><xsl:for-each select="$SeriesDims"><xsl:variable name="SDim" select="."/>"<xsl:value-of select="$Series/generic:SeriesKey/generic:Value[@concept = $SDim]/@value"/>",</xsl:for-each><xsl:for-each select="$SeriesAtts"><xsl:variable name="SAtt" select="."/>"<xsl:value-of select="$Series/generic:Attributes/generic:Value[@concept = $SAtt]/@value"/>",</xsl:for-each><xsl:for-each select="$Times"><xsl:sort/><xsl:variable name="Time" select="."/><xsl:choose><xsl:when test="$ObsStatusName != 'notPassed'"><xsl:choose><xsl:when test="$Series/generic:Obs[generic:Time=$Time]/generic:Attributes/generic:Value[@concept=$ObsStatusName]/@value=$ObsStatusMissingValue">"...",</xsl:when><xsl:otherwise>"<xsl:value-of select="$Series/generic:Obs[generic:Time=$Time]/generic:ObsValue/@value"/>",</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>"<xsl:value-of select="$Series/generic:Obs[generic:Time=$Time]/generic:ObsValue/@value"/>",</xsl:otherwise></xsl:choose></xsl:for-each><xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
               </xsl:when>
               <!-- Data into columns -->
               <xsl:otherwise>
                    <!-- Header Data -->
                    <xsl:text>HEADER DATA&#10;</xsl:text>
                    <xsl:variable name="Header" select="/message:GenericData/message:Header"/>
                    <xsl:text>Message ID:,</xsl:text>"<xsl:value-of select="$Header/message:ID"/>"<xsl:text>&#10;</xsl:text>
                    <xsl:text>Test Message:,</xsl:text>"<xsl:value-of select="$Header/message:Test"/>"<xsl:text>&#10;</xsl:text>
                    <xsl:for-each select="$Header/message:Truncated">
                         <xsl:text>Message Truncated:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:Name">
                         <xsl:text>Message Name:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:Prepared">
                         <xsl:text>Date Prepared:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:Receiver | $Header/message:Sender">
                         <xsl:value-of select="local-name()"/><xsl:text> ID:,</xsl:text>"<xsl:value-of select="@id"/>"<xsl:text>&#10;</xsl:text>
                         <xsl:for-each select="message:Name">
                                   <xsl:value-of select="local-name(..)"/><xsl:text> Name:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                         </xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:KeyFamilyRef">
                         <xsl:text>Key Family:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:KeyFamilyAgency">
                         <xsl:text>Key Family Agency:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:DataSetAgency">
                         <xsl:text>Data Set Agency:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:DataSetID">
                         <xsl:text>Data Set ID:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:DataSetAction">
                         <xsl:text>Data Set Action:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:Extracted">
                         <xsl:text>Extracted:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:ReportingBegin">
                         <xsl:text>Reporting Begin Date:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:ReportingEnd">
                         <xsl:text>Reporting End Date:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="message:Source">
                         <xsl:text>Source:,</xsl:text>"<xsl:value-of select="."/>"<xsl:text>&#10;</xsl:text>                    
                    </xsl:for-each>
                    <xsl:text>&#10;</xsl:text>
                    <!-- Start Data Set -->
                    <xsl:for-each select="/message:GenericData/message:DataSet">
                         <xsl:text>DATA SET&#10;</xsl:text>
                         <xsl:text>KEY FAMILY:,</xsl:text>"<xsl:value-of select="generic:KeyFamilyRef"/>"<xsl:text>&#10;</xsl:text>
                         <!-- Data Set Attributes -->
                         <xsl:if test="generic:Attributes">
                              <xsl:text>DATA SET ATTRIBUTES:&#10;</xsl:text>
                              <xsl:for-each select="generic:Attributes/generic:Value">,"<xsl:value-of select="@concept"/>","<xsl:value-of select="@value"/>"<xsl:text>&#10;</xsl:text></xsl:for-each>
                         </xsl:if>
                         <!-- Groups -->
                         <xsl:for-each select="generic:Group">
                              <xsl:text>GROUP ID:,</xsl:text>"<xsl:value-of select="@type"/>"<xsl:text>&#10;</xsl:text>
                              <!-- Group Attributes -->
                              <xsl:if test="generic:Attributes">
                                   <xsl:text>GROUP ATTRIBUTES:&#10;</xsl:text>
                                   <xsl:for-each select="generic:Attributes/generic:Value">,"<xsl:value-of select="@concept"/>","<xsl:value-of select="@value"/>"<xsl:text>&#10;</xsl:text></xsl:for-each>
                              </xsl:if>
                              <!-- Grouped Series -->
                              <xsl:for-each select="generic:Series">
                                   <!-- Series Attributes -->
                                   <xsl:if test="generic:Attributes">
                                        <xsl:text>SERIES ATTRIBUTES:&#10;</xsl:text>
                                        <xsl:for-each select="generic:Attributes/generic:Value">,"<xsl:value-of select="@concept"/>","<xsl:value-of select="@value"/>"<xsl:text>&#10;</xsl:text></xsl:for-each>
                                   </xsl:if>
                                   <!-- Series Key -->
                                   <xsl:text>SERIES KEY:&#10;</xsl:text>
                                   <xsl:for-each select="generic:SeriesKey/generic:Value">,"<xsl:value-of select="@concept"/>","<xsl:value-of select="@value"/>"<xsl:text>&#10;</xsl:text></xsl:for-each>
                                   <!-- Observations -->
                                   <xsl:text>OBSERVATIONS:&#10;</xsl:text>
                                   <xsl:for-each select="generic:Obs">,"<xsl:value-of select="generic:Time"/>",<xsl:choose><xsl:when test="$ObsStatusName != 'notPassed'"><xsl:choose><xsl:when test="generic:Attributes/generic:Value[@concept=$ObsStatusName]/@value=$ObsStatusMissingValue">"..."</xsl:when><xsl:otherwise>"<xsl:value-of select="generic:ObsValue/@value"/>"</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>"<xsl:value-of select="generic:ObsValue/@value"/>"</xsl:otherwise></xsl:choose><xsl:for-each select="generic:Attributes/generic:Value">,"<xsl:value-of select="@concept"/>: <xsl:value-of select="@value"/>"</xsl:for-each><xsl:text>&#10;</xsl:text></xsl:for-each>                                                              
                                   </xsl:for-each><!-- End Grouped Series -->
                         </xsl:for-each><!-- End Group -->
                         <!-- Ungrouped Series -->
                         <xsl:for-each select="generic:Series">
                              <!-- Series Attributes -->
                              <xsl:if test="generic:Attributes">
                                   <xsl:text>SERIES ATTRIBUTES:&#10;</xsl:text>
                                   <xsl:for-each select="generic:Attributes/generic:Value">,"<xsl:value-of select="@concept"/>","<xsl:value-of select="@value"/>"<xsl:text>&#10;</xsl:text></xsl:for-each>
                              </xsl:if>
                              <!-- Series Key -->
                              <xsl:text>SERIES KEY:&#10;</xsl:text>
                              <xsl:for-each select="generic:SeriesKey/generic:Value">,"<xsl:value-of select="@concept"/>","<xsl:value-of select="@value"/>"<xsl:text>&#10;</xsl:text></xsl:for-each>
                              <!-- Observations -->
                              <xsl:text>OBSERVATIONS:&#10;</xsl:text>
                              <xsl:for-each select="generic:Obs">,"<xsl:value-of select="generic:Time"/>",<xsl:choose><xsl:when test="$ObsStatusName != 'notPassed'"><xsl:choose><xsl:when test="generic:Attributes/generic:Value[@concept=$ObsStatusName]/@value=$ObsStatusMissingValue">"..."</xsl:when><xsl:otherwise>"<xsl:value-of select="generic:ObsValue/@value"/>"</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>"<xsl:value-of select="generic:ObsValue/@value"/>"</xsl:otherwise></xsl:choose><xsl:for-each select="generic:Attributes/generic:Value">,"<xsl:value-of select="@concept"/>:<xsl:value-of select="@value"/>"</xsl:for-each><xsl:text>&#10;</xsl:text></xsl:for-each>                                                              
                        </xsl:for-each><!-- End Ungrouped Series -->
                    </xsl:for-each><!-- End Data Set -->
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
</xsl:stylesheet>
