<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common"
xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact" 
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:exslt="http://exslt.org/common" 
extension-element-prefixes="exslt"
exclude-result-prefixes="xsl structure message generic"
 version="1.0" >
     <!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
     <xsl:import href="HeaderCopy.xslt"/>
     <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
     <xsl:strip-space elements="*"/>
     <!-- Input Parameters -->
     <!-- Namespace of the Compact schema, optional - will be defaulted if not passed, resulting instance will have to be modified -->
     <xsl:param name="Namespace">notPassed</xsl:param>
     <!-- URI of Key Family xml instance, conditional: mandatory if GenericData/DataSet/@keyFamilyURI not used in Generic instance - used to find strcture of Key Family -->
     <xsl:param name="KeyFamURI">notPassed</xsl:param>
     <!-- URI of the SDMXMessage.xsd, optional - used to set schemaLocation, for easier validation of Compact instance -->
     <xsl:param name="MessageURI">notPassed</xsl:param>
     <!-- URI of the Compact schema, optional - used to set schemaLocation, for easier validation of Compact instance -->
     <xsl:param name="CompactURI">notPassed</xsl:param>
     <xsl:template match="/">
          <!-- Find the location of the Key Family xml instance if not passed as an input parameter-->
          <xsl:variable name="KFLoc">
               <xsl:choose>
                    <xsl:when test="$KeyFamURI='notPassed'">
                         <xsl:value-of select="/message:GenericData/message:DataSet/@keyFamilyURI"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:value-of select="$KeyFamURI"/>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:variable>
          <!-- Set the schemaLocation(s) for Compact instance -->
          <xsl:variable name="SchemaLoc">
               <xsl:choose>
                    <xsl:when test="$MessageURI != 'notPassed' and $CompactURI != 'notPassed'">
                         <xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message </xsl:text>
                         <xsl:value-of select="$MessageURI"/>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="$Namespace"/>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="$CompactURI"/>
                    </xsl:when>
                    <xsl:when test="$MessageURI != 'notPassed' and $CompactURI = 'notPassed'">
                         <xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message </xsl:text>
                         <xsl:value-of select="$MessageURI"/>
                    </xsl:when>
                    <xsl:when test="$MessageURI = 'notPassed' and $CompactURI != 'notPassed'">
                         <xsl:value-of select="$Namespace"/>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="$CompactURI"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:text>notPassed</xsl:text>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:variable>
          <!-- Get the Key Family ID from the Generic instance-->
          <xsl:variable name="KeyFamID">
               <xsl:value-of select="/message:GenericData/message:DataSet/generic:KeyFamilyRef"/>
          </xsl:variable>
          <!-- Namespace holder node, this is used to copy the Compact namespace to the root element of the resulting instance, opposed to the DataSet element-->
          <!-- It is only used, when processed with Saxon, and is only cosmetic -->
          <xsl:variable name="ns-node">
               <xsl:element name="cds:ns-element" namespace="{$Namespace}"/>
          </xsl:variable>
          <!-- Open the Key Family xml instance -->
          <xsl:variable name="Structure" select="document($KFLoc, .)"/>
          <!-- Check that the Key Family instance contains the Key Family-->
          <xsl:choose>
               <!-- Key Family exists in Key Family instance -->
               <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]">
                    <!-- If Namespace was not passed as an input parameter, create a comment in Compact instance -->
                    <xsl:if test="$Namespace='notPassed'">
                         <xsl:comment>Namespace was not passed.  Default value set.</xsl:comment>
                    </xsl:if>
                    <!-- Start CompactData instance-->
                    <CompactData>
                         <!-- If Saxon is used, copy the Compact namespace declaration to the root element - cosmetic only -->
                         <xsl:if test="function-available('exslt:node-set')">
                              <xsl:copy-of select="exslt:node-set($ns-node)/*/namespace::*[local-name()='cds']"/>
                         </xsl:if>
                         <!-- Set the schemaLocation(s), if passed as input parameters -->
                         <xsl:if test="$SchemaLoc != 'notPassed'">
                              <xsl:attribute name="xsi:schemaLocation"><xsl:value-of select="$SchemaLoc"/></xsl:attribute>
                         </xsl:if>
                         <!-- Copy Header Data (pass Key Family ID in case it is not already set in the Header) -->
                         <xsl:apply-templates mode="CopyHeader" select="/message:GenericData/message:Header">
                              <xsl:with-param name="KeyFamID">
                                   <xsl:value-of select="$KeyFamID"/>
                              </xsl:with-param>
                         </xsl:apply-templates>
                         <!-- Create DataSet -->
                         <xsl:element name="cds:DataSet" namespace="{$Namespace}">
                              <!-- Create DataSet Attributes-->
                              <xsl:for-each select="/message:GenericData/message:DataSet/generic:Attributes/generic:Value">
                                   <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
                              </xsl:for-each>
                              <!-- Create Groups -->
                              <xsl:for-each select="/message:GenericData/message:DataSet/generic:Group">
                                   <xsl:variable name="GroupID">
                                        <xsl:value-of select="@type"/>
                                   </xsl:variable>
                                   <xsl:element name="cds:{$GroupID}" namespace="{$Namespace}">
                                        <!-- Create Group Key Values-->
                                        <xsl:choose>
                                             <!-- If Group Key exists, get value from it-->
                                             <xsl:when test="generic:GroupKey">
                                                  <xsl:for-each select="generic:GroupKey/generic:Value">
                                                       <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
                                                  </xsl:for-each>
                                             </xsl:when>
                                             <!-- If Group Key does not exist, get values from Series Key -->
                                             <xsl:otherwise>
                                                  <xsl:variable name="GroupKey" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:Group[@id = $GroupID]"/>
                                                  <xsl:for-each select="generic:Series[1]/generic:SeriesKey/generic:Value[@concept = $GroupKey/*[local-name()='DimensionRef']/.]">
                                                       <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
                                                  </xsl:for-each>
                                             </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- Create Group Attributes -->
                                        <xsl:for-each select="generic:Attributes/generic:Value">
                                             <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
                                        </xsl:for-each>
                                        <!-- Copy Group Annotations -->
                                        <xsl:for-each select="generic:Annotations">
                                             <xsl:element name="cds:Annotations" namespace="{$Namespace}">
                                                  <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                             </xsl:element>
                                        </xsl:for-each>
                                   </xsl:element>
                                   <!-- End Group -->
                              </xsl:for-each>
                              <!-- Create Series (Grouped and Non Grouped)-->
                              <xsl:for-each select="//generic:Series">
                                   <xsl:element name="cds:Series" namespace="{$Namespace}">
                                        <!-- Create Series Key -->
                                        <xsl:for-each select="generic:SeriesKey/generic:Value">
                                             <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
                                        </xsl:for-each>
                                        <!-- Create Series Attributes -->
                                        <xsl:for-each select="generic:Attributes/generic:Value">
                                             <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
                                        </xsl:for-each>
                                        <!-- Create Observations -->
                                        <xsl:for-each select="generic:Obs">
                                             <xsl:element name="cds:Obs" namespace="{$Namespace}">
                                                  <!-- Create Observation Time -->
                                                  <xsl:if test="generic:Time">
                                                  <xsl:attribute name="{$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:TimeDimension/@conceptRef}"><xsl:value-of select="generic:Time"/></xsl:attribute>
                                                  </xsl:if>
                                                  <!-- Create Observation Value -->
                                                  <xsl:if test="generic:ObsValue/@value">
                                                  <xsl:attribute name="{$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:PrimaryMeasure/@conceptRef}"><xsl:value-of select="generic:ObsValue/@value"/></xsl:attribute>
                                                  </xsl:if>
                                                  <!-- Create Observation Attributes -->
                                                  <xsl:for-each select="generic:Attributes/generic:Value">
                                                       <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
                                                  </xsl:for-each>
                                                  <!-- Copy Observation Annotations -->
                                                  <xsl:for-each select="generic:Annotations">
                                                       <xsl:element name="cds:Annotations" namespace="{$Namespace}">
                                                            <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                       </xsl:element>
                                                  </xsl:for-each>
                                             </xsl:element>
                                             <!-- End Obs -->
                                        </xsl:for-each>
                                        <!-- Copy Series Annotations -->
                                        <xsl:for-each select="generic:Annotations">
                                             <xsl:element name="cds:Annotations" namespace="{$Namespace}">
                                                  <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                             </xsl:element>
                                        </xsl:for-each>
                                   </xsl:element>
                                   <!-- End Series -->
                              </xsl:for-each>
                              <!-- Copy DataSet Annotations -->
                              <xsl:for-each select="/message:GenericData/message:DataSet/generic:Annotations">
                                   <xsl:element name="cds:Annotations" namespace="{$Namespace}">
                                        <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                   </xsl:element>
                              </xsl:for-each>
                         </xsl:element>
                         <!-- End DataSet -->
                    </CompactData>
                    <!-- End CompactData -->
               </xsl:when>
               <!-- Key Family not found in Key Family instance -->
               <xsl:otherwise>
                    <xsl:comment>Key Family <xsl:value-of select="$KeyFamID"/> not found in <xsl:value-of select="$KFLoc"/>.</xsl:comment>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
</xsl:stylesheet>
