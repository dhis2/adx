<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" 
xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility" 
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
exclude-result-prefixes="xsl structure message utility"
version="1.0">
     <!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
     <xsl:import href="HeaderCopy.xslt"/>
     <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
     <xsl:strip-space elements="*"/>
     <!-- Input Parameters -->
     <!-- ID of Key Family, conditional: mandatory if UtilityData/Header/KeyFamilyRef is not used in Utility instance -->
     <xsl:param name="KeyFamID">notPassed</xsl:param>
     <!-- URI of Key Family xml instance, mandatory - needed to find strcture of Key Family -->
     <xsl:param name="KeyFamURI">notPassed</xsl:param>
     <!-- URI of the SDMXMessage.xsd, optional - used to set schemaLocation, for easier validation of Generic instance -->
     <xsl:param name="MessageURI">notPassed</xsl:param>
     <xsl:template match="/">
          <!-- Set schemaLocation for Generic instance-->
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
          <!-- Find Key Family ID in the Utility instance if not passed as input parameter -->
          <xsl:variable name="KFID">
               <xsl:choose>
                    <xsl:when test="$KeyFamID='notPassed'">
                         <xsl:choose>
                              <xsl:when test="/message:UtilityData/message:Header/message:KeyFamilyRef">
                                   <xsl:value-of select="/message:UtilityData/message:Header/message:KeyFamilyRef"/>
                              </xsl:when>
                              <xsl:otherwise>notPassed</xsl:otherwise>
                         </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:value-of select="$KeyFamID"/>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:variable>
          <!-- Open the Key Family xml instance -->
          <xsl:variable name="Structure" select="document($KeyFamURI, .)"/>
          <!-- Check that a Key Family ID was found or passed as an input parameter -->
          <xsl:choose>
               <!-- Key Family ID set -->
               <xsl:when test="$KFID != 'notPassed'">
                    <!-- Check that the Key Family instance contains the Key Family-->
                    <xsl:choose>
                         <!-- Key Family exists in Key Family instance -->
                         <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]">
                              <!-- Start GenericData instance -->
                              <GenericData>
                                   <!-- Set schemaLocation -->
                                   <xsl:if test="$SchemaLoc != 'notPassed'">
                                        <xsl:attribute name="xsi:schemaLocation"><xsl:value-of select="$SchemaLoc"/></xsl:attribute>
                                   </xsl:if>
                                   <!-- Copy Header Data-->
                                   <xsl:apply-templates mode="copy-no-ns" select="/message:UtilityData/message:Header"/>
                                   <!-- Create DataSet -->
                                   <xsl:for-each select="/message:UtilityData/*[local-name()='DataSet']">
                                        <xsl:element name="DataSet">
                                             <xsl:attribute name="keyFamilyURI"><xsl:value-of select="$KeyFamURI"/></xsl:attribute>
                                             <xsl:element name="generic:KeyFamilyRef">
                                                  <xsl:value-of select="$KFID"/>
                                             </xsl:element>
                                             <!-- Create DataSet Attributes -->
                                             <xsl:call-template name="GetAttributes"/>
                                             <!-- Create Groups -->
                                             <xsl:for-each select="*[local-name() != 'Series' and local-name() != 'Annotations']">
                                                  <xsl:variable name="Group" select="."/>
                                                  <xsl:variable name="GroupID">
                                                       <xsl:value-of select="local-name(.)"/>
                                                  </xsl:variable>
                                                  <xsl:element name="generic:Group">
                                                       <xsl:attribute name="type"><xsl:value-of select="$GroupID"/></xsl:attribute>
                                                       <!-- Create Group Key -->
                                                       <xsl:element name="generic:GroupKey">
                                                            <xsl:for-each select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Group[@id = $GroupID]/structure:DimensionRef">
                                                                 <xsl:variable name="KeyDim">
                                                                      <xsl:value-of select="."/>
                                                                 </xsl:variable>
                                                                 <xsl:for-each select="$Group/*[local-name()='Series'][1]/*[local-name()='Key']/*[local-name()=$KeyDim]">
                                                                      <xsl:element name="generic:Value">
                                                                           <xsl:attribute name="concept"><xsl:value-of select="local-name(.)"/></xsl:attribute>
                                                                           <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                      </xsl:element>
                                                                      <!-- End Value -->
                                                                 </xsl:for-each>
                                                            </xsl:for-each>
                                                       </xsl:element>
                                                       <!-- End GroupKey -->
                                                       <!-- Create Group Attributes -->
                                                       <xsl:call-template name="GetAttributes"/>
                                                       <!-- Create Series for Group -->
                                                       <xsl:call-template name="GetSeries">
                                                            <xsl:with-param name="KFID">
                                                                 <xsl:value-of select="$KFID"/>
                                                            </xsl:with-param>
                                                       </xsl:call-template>
                                                       <!-- Copy Group Annotations -->
                                                       <xsl:for-each select="*[local-name() = 'Annotations']">
                                                            <xsl:element name="generic:Annotations">
                                                                 <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                            </xsl:element>
                                                       </xsl:for-each>
                                                  </xsl:element>
                                                  <!-- End Group -->
                                             </xsl:for-each>
                                             <!-- Create Non-Grouped Series -->
                                             <xsl:call-template name="GetSeries">
                                                  <xsl:with-param name="KFID">
                                                       <xsl:value-of select="$KFID"/>
                                                  </xsl:with-param>
                                             </xsl:call-template>
                                             <!-- Copy DataSet Annotations -->
                                             <xsl:for-each select="*[local-name() = 'Annotations']">
                                                  <xsl:element name="generic:Annotations">
                                                       <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                  </xsl:element>
                                             </xsl:for-each>
                                        </xsl:element>
                                        <!-- End DataSet -->
                                   </xsl:for-each>
                              </GenericData>
                              <!-- End GenericData -->
                         </xsl:when>
                         <!-- Key Family not found in Key Family instance -->
                         <xsl:otherwise>
                              <xsl:comment>
                                   <xsl:text>Key Family with ID </xsl:text>
                                   <xsl:value-of select="$KFID"/>
                                   <xsl:text> not found in document </xsl:text>
                                   <xsl:value-of select="$KeyFamURI"/>
                                   <xsl:text>.  Generic sample could not be created.</xsl:text>
                              </xsl:comment>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:when>
               <!-- Key Family ID not found or passed as input parameter -->
               <xsl:otherwise>
                    <xsl:comment>
                         <xsl:text>Key Family ID not found in source document nor passed in as parameter.  Generic sample could not be created.</xsl:text>
                    </xsl:comment>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
     <!-- Template to create Attributes for any level -->
     <xsl:template name="GetAttributes">
          <xsl:if test="@*">
               <xsl:element name="generic:Attributes">
                    <xsl:for-each select="@*">
                         <xsl:element name="generic:Value">
                              <xsl:attribute name="concept"><xsl:value-of select="name(.)"/></xsl:attribute>
                              <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                         </xsl:element>
                         <!-- End Value -->
                    </xsl:for-each>
               </xsl:element>
               <!-- End Attributes -->
          </xsl:if>
     </xsl:template>
     <!-- Template to Create both grouped and non grouped Series -->
     <xsl:template name="GetSeries">
          <!-- Template Parameters -->
          <!-- Key Family ID, mandatory - used to find Key Family in Key Family instance -->
          <xsl:param name="KFID"/>
          <!-- Open Key Family instance -->
          <!-- Note: This is done in template to avoid having to use extension functions, as node sets cannot be passed as paramters between templates.-->
          <xsl:variable name="Structure" select="document($KeyFamURI, .)"/>
          <!-- Create Series -->
          <xsl:for-each select="*[local-name() = 'Series']">
               <xsl:element name="generic:Series">
                    <!-- Create Series Key -->
                    <xsl:element name="generic:SeriesKey">
                         <xsl:for-each select="*[local-name()='Key']/*">
                              <xsl:element name="generic:Value">
                                   <xsl:attribute name="concept"><xsl:value-of select="local-name(.)"/></xsl:attribute>
                                   <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                              </xsl:element>
                              <!-- End Value -->
                         </xsl:for-each>
                    </xsl:element>
                    <!-- End Series Key -->
                    <!-- Create Series Attributes -->
                    <xsl:call-template name="GetAttributes"/>
                    <!-- Create Observations -->
                    <xsl:for-each select="*[local-name() = 'Obs']">
                         <xsl:element name="generic:Obs">
                              <!-- Create Observation Time -->
                              <xsl:variable name="TimeDim">
                                   <xsl:value-of select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:TimeDimension/@conceptRef"/>
                              </xsl:variable>
                              <xsl:for-each select="*[local-name() = $TimeDim]">
                                   <xsl:element name="generic:Time">
                                        <xsl:value-of select="."/>
                                   </xsl:element>
                                   <!-- End Time -->
                              </xsl:for-each>
                              <!-- Create Observation Value -->
                              <xsl:variable name="Measure">
                                   <xsl:value-of select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:PrimaryMeasure/@conceptRef"/>
                              </xsl:variable>
                              <xsl:for-each select="*[local-name() = $Measure]">
                                   <xsl:if test=". != 'NaN' and .!=''">
	                                   <xsl:element name="generic:ObsValue">
	                                        <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
	                                   </xsl:element>
                                   </xsl:if>
                                   <!-- End Time -->
                              </xsl:for-each>
                              <!-- Create Observation Attributes -->
                              <xsl:call-template name="GetAttributes"/>
                              <!-- Copy Observation Annotations -->
                              <xsl:for-each select="*[local-name() = 'Annotations']">
                                   <xsl:element name="generic:Annotations">
                                        <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                   </xsl:element>
                              </xsl:for-each>
                         </xsl:element>
                         <!-- End Obs -->
                    </xsl:for-each>
                    <!-- Copy Series Annotations -->
                    <xsl:for-each select="*[local-name() = 'Annotations']">
                         <xsl:element name="generic:Annotations">
                              <xsl:apply-templates mode="copy-no-ns" select="*"/>
                         </xsl:element>
                    </xsl:for-each>
               </xsl:element>
               <!-- End Series -->
          </xsl:for-each>
     </xsl:template>
</xsl:stylesheet>
