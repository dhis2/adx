<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" 
xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/utility" 
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:exslt="http://exslt.org/common" 
extension-element-prefixes="exslt"
exclude-result-prefixes="xsl structure message generic exslt"
version="1.0">
     <!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
     <xsl:import href="HeaderCopy.xsl"/>
     <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
     <xsl:strip-space elements="*"/>
     <!-- Input Parameters -->
     <!-- Namespace of the Utility schema, optional - will be defaulted if not passed, resulting instance will have to be modified -->
     <xsl:param name="Namespace">notPassed</xsl:param>
     <!-- URI of Key Family xml instance, conditional: mandatory if GenericData/DataSet/@keyFamilyURI not used in Generic instance - used to find strcture of Key Family -->
     <xsl:param name="KeyFamURI">notPassed</xsl:param>
     <!-- URI of the SDMXMessage.xsd, optional - used to set schemaLocation, for easier validation of Utility instance -->
     <xsl:param name="MessageURI">notPassed</xsl:param>
     <!-- URI of the Utility schema, optional - used to set schemaLocation, for easier validation of Utility instance -->
     <xsl:param name="UtilityURI">notPassed</xsl:param>
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
          <!-- Set the schemaLocation(s) for Utility instance -->
          <xsl:variable name="SchemaLoc">
               <xsl:choose>
                    <xsl:when test="$MessageURI != 'notPassed' and $UtilityURI != 'notPassed'">
                         <xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message </xsl:text>
                         <xsl:value-of select="$MessageURI"/>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="$Namespace"/>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="$UtilityURI"/>
                    </xsl:when>
                    <xsl:when test="$MessageURI != 'notPassed' and $UtilityURI = 'notPassed'">
                         <xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message </xsl:text>
                         <xsl:value-of select="$MessageURI"/>
                    </xsl:when>
                    <xsl:when test="$MessageURI = 'notPassed' and $UtilityURI != 'notPassed'">
                         <xsl:value-of select="$Namespace"/>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="$UtilityURI"/>
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
          <!-- Namespace holder node, this is used to copy the Utility namespace to the root element of the resulting instance, opposed to the DataSet element-->
          <!-- It is only used, when processed with exslt, and is only cosmetic -->
          <xsl:variable name="ns-node">
               <xsl:element name="uds:ns-element" namespace="{$Namespace}"/>
          </xsl:variable>
          <!-- Open the Key Family xml instance -->
          <xsl:variable name="Structure" select="document($KFLoc, .)"/>
          <!-- Check that the Key Family instance contains the Key Family-->
          <xsl:choose>
               <!-- Key Family exists in Key Family instance -->
               <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]">
			<!-- Key Family Structure Variable -->
			<xsl:variable name="KeyFam" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]"/>
                    <xsl:variable name="Group" select="$KeyFam/structure:Components/structure:Group"/>
                    <xsl:variable name="Dim" select="$KeyFam/structure:Components/structure:Dimension"/>
                    <!-- If Namespace was not passed as an input parameter, create a comment in Utility instance -->
                    <xsl:if test="$Namespace='notPassed'">
                         <xsl:comment>Namespace was not passed.  Default value set.</xsl:comment>
                    </xsl:if>
                    <!-- Start UtilityData instance-->
                    <UtilityData>
                         <!-- If exslt is used, copy the Utility namespace declaration to the root element - cosmetic only -->
                         <xsl:if test="function-available('exslt:node-set')">
                              <xsl:copy-of select="exslt:node-set($ns-node)/*/namespace::*[local-name()='uds']"/>
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
                         <xsl:element name="uds:DataSet" namespace="{$Namespace}">
                         	    <xsl:variable name="GenDataSet" select="/message:GenericData/message:DataSet"/>
                              <!-- Create DataSet Attributes -->
                              <xsl:for-each select="$GenDataSet/generic:Attributes/generic:Value">
                                   <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
                              </xsl:for-each>
                              <!-- Check Key Family Has Groups -->
                              <!-- Note: Utility schemas only supported grouped series if the groups are defined. -->
                              <xsl:if test="$Group">
                                   <!-- Groups are defined in Key Family -->
                                   <!-- Only grouped series will be mapped -->
                                   <!-- Create Groups -->
                                   <xsl:for-each select="$Group">
	                                   <xsl:variable name="GroupID" select="@id"/>
	                                   <xsl:for-each select="$GenDataSet/generic:Group[@type = $GroupID]">
	                                        <xsl:element name="uds:{$GroupID}" namespace="{$Namespace}">
	                                             <!-- Create Group Attributes -->
	                                             <xsl:for-each select="generic:Attributes/generic:Value">
	                                                  <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
	                                             </xsl:for-each>
	                                             <!-- Create Series for Group -->
	                                             <xsl:for-each select="generic:Series">
	                                             	   <xsl:variable name="GenSeries" select="."/>
	                                                  <xsl:element name="uds:Series" namespace="{$Namespace}">
	                                                       <!-- Create Series Attributes -->
	                                                       <xsl:for-each select="generic:Attributes/generic:Value">
	                                                            <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
	                                                       </xsl:for-each>
	                                                       <!-- Create Series Key -->
	                                                       <xsl:element name="uds:Key" namespace="{$Namespace}">
		                                                       <xsl:for-each select="$Dim">
		                                                       	<xsl:variable name="DimID" select="@concept"/>
		                                                            <xsl:for-each select="$GenSeries/generic:SeriesKey/generic:Value[@concept = $DimID]">
		                                                                 <xsl:element name="uds:{$DimID}" namespace="{$Namespace}">
		                                                                      <xsl:value-of select="@value"/>
		                                                                 </xsl:element>
		                                                            </xsl:for-each>
		                                                       </xsl:for-each>
	                                                       </xsl:element>
	                                                       <!-- End Key -->
	                                                       <!-- Create Observations -->
	                                                       <xsl:for-each select="generic:Obs">
	                                                            <xsl:element name="uds:Obs" namespace="{$Namespace}">
	                                                                 <!-- Create Observation Attributes -->
	                                                                 <xsl:for-each select="generic:Attributes/generic:Value">
	                                                                      <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
	                                                                 </xsl:for-each>
	                                                                 <!-- Create Observation Time -->
	                                                                 <xsl:element name="uds:{$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=	$KeyFamID]/structure:Components/structure:TimeDimension/@concept}" namespace="{$Namespace}">
	                                                                      <xsl:value-of select="generic:Time"/>
	                                                                 </xsl:element>
	                                                                 <!-- Create Observation Value -->
			                                                       <xsl:variable name="ObsValue">
			                                                       	<xsl:choose>
			                                                       		<xsl:when test="generic:ObsValue/@value">
			                                                       			<xsl:value-of select="generic:ObsValue/@value"/>
													</xsl:when>
													<xsl:otherwise>NaN</xsl:otherwise>
												</xsl:choose>
			                                                       </xsl:variable>	                                                                 
	                                                                 <xsl:element name="uds:{$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=	$KeyFamID]/structure:Components/structure:PrimaryMeasure/@concept}" namespace="{$Namespace}">
	                                                                      <xsl:value-of select="$ObsValue"/>
	                                                                 </xsl:element>
	                                                                 <!-- Copy Observation Annotations -->
	                                                                 <xsl:for-each select="generic:Annotations">
	                                                                      <xsl:element name="uds:Annotations" namespace="{$Namespace}">
	                                                                           <xsl:apply-templates mode="copy-no-ns" select="*"/>
	                                                                      </xsl:element>
	                                                                 </xsl:for-each>
	                                                            </xsl:element>
	                                                            <!-- End Obs -->
	                                                       </xsl:for-each>
	                                                       <!-- Copy Series Annotations -->
	                                                       <xsl:for-each select="generic:Annotations">
	                                                            <xsl:element name="uds:Annotations" namespace="{$Namespace}">
	                                                                 <xsl:apply-templates mode="copy-no-ns" select="*"/>
	                                                            </xsl:element>
	                                                       </xsl:for-each>
	                                                  </xsl:element>
	                                                  <!-- End Series -->
	                                             </xsl:for-each>
	                                             <!-- Copy Group Annotations -->
	                                             <xsl:for-each select="generic:Annotations">
	                                                  <xsl:element name="uds:Annotations" namespace="{$Namespace}">
	                                                       <xsl:apply-templates mode="copy-no-ns" select="*"/>
	                                                  </xsl:element>
	                                             </xsl:for-each>
	                                        </xsl:element>
	                                        <!-- End Group -->
	                                   </xsl:for-each>
                                   </xsl:for-each>
                              </xsl:if>
                              <!-- End Grouped Data Section -->
                              <!-- Check that groups are not defined in Key Family instance -->
                              <xsl:if test="not($Group)">
                                   <!-- Groups are not defined in Key Family instance -->
                                   <!-- Only non grouped Series will be mapped -->
                                   <!-- Create Series -->
                                   <xsl:for-each select="/message:GenericData/message:DataSet/generic:Series">
                                   	<xsl:variable name="GenSeries" select="."/>
                                        <xsl:element name="uds:Series" namespace="{$Namespace}">
                                             <!-- Create Series Attributes -->
                                             <xsl:for-each select="generic:Attributes/generic:Value">
                                                  <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
                                             </xsl:for-each>
                                             <!-- Create Series Key -->
							<xsl:element name="uds:Key" namespace="{$Namespace}">
								<xsl:for-each select="$Dim">
									<xsl:variable name="DimID" select="@concept"/>
									<xsl:for-each select="$GenSeries/generic:SeriesKey/generic:Value[@concept = $DimID]">
										<xsl:element name="uds:{$DimID}" namespace="{$Namespace}">
											 <xsl:value-of select="@value"/>
										</xsl:element>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:element>
                                             <!-- End Key -->
                                             <!-- Create Observations -->
                                             <xsl:for-each select="generic:Obs">
                                                  <xsl:element name="uds:Obs" namespace="{$Namespace}">
                                                       <!-- Create Observation Attributes -->
                                                       <xsl:for-each select="generic:Attributes/generic:Value">
                                                            <xsl:attribute name="{@concept}"><xsl:value-of select="@value"/></xsl:attribute>
                                                       </xsl:for-each>
                                                       <!-- Create Observation Time -->
                                                       <xsl:element name="uds:{$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:TimeDimension/@concept}" namespace="{$Namespace}">
                                                            <xsl:value-of select="generic:Time"/>
                                                       </xsl:element>
                                                       <!-- Create Observation Value -->
                                                       <xsl:variable name="ObsValue">
                                                       	<xsl:choose>
                                                       		<xsl:when test="generic:ObsValue/@value">
                                                       			<xsl:value-of select="generic:ObsValue/@value"/>
										</xsl:when>
										<xsl:otherwise>NaN</xsl:otherwise>
									</xsl:choose>
                                                       </xsl:variable>
                                                       <xsl:element name="uds:{$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:PrimaryMeasure/@concept}" namespace="{$Namespace}">
                                                            <xsl:value-of select="$ObsValue"/>
                                                       </xsl:element>
                                                       <!-- Copy Observation Annotations -->
                                                       <xsl:for-each select="generic:Annotations">
                                                            <xsl:element name="uds:Annotations" namespace="{$Namespace}">
                                                                 <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                            </xsl:element>
                                                       </xsl:for-each>
                                                  </xsl:element>
                                                  <!-- End Obs -->
                                             </xsl:for-each>
                                             <!-- Copy Series Annotations -->
                                             <xsl:for-each select="generic:Annotations">
                                                  <xsl:element name="uds:Annotations" namespace="{$Namespace}">
                                                       <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                  </xsl:element>
                                             </xsl:for-each>
                                        </xsl:element>
                                        <!-- End Series -->
                                   </xsl:for-each>
                              </xsl:if>
                              <!-- End Ungrouped Data Section -->
                              <!-- Copy DataSet Annotations -->
                              <xsl:for-each select="/message:GenericData/message:DataSet/generic:Annotations">
                                   <xsl:element name="uds:Annotations" namespace="{$Namespace}">
                                        <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                   </xsl:element>
                              </xsl:for-each>
                         </xsl:element>
                         <!-- End DataSet -->
                    </UtilityData>
                    <!-- End UtilityData -->
               </xsl:when>
               <!-- Key Family not found in Key Family instance -->
               <xsl:otherwise>
                    <xsl:comment>Key Family <xsl:value-of select="$KeyFamID"/> not found in <xsl:value-of select="$KFLoc"/>.</xsl:comment>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
</xsl:stylesheet>
