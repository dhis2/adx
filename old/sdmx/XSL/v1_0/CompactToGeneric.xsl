<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" 
xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact" 
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
exclude-result-prefixes="xsl structure message compact"
version="1.0" >
     <!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
     <xsl:import href="HeaderCopy.xsl"/>
     <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
     <xsl:strip-space elements="*"/>
     <!-- Input Parameters -->
     <!-- ID of Key Family, conditional: mandatory if CompactData/Header/KeyFamilyRef is not used in Compact instance -->
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
          <!-- Find Key Family ID in the Compact instance if not passed as input parameter -->
          <xsl:variable name="KFID">
               <xsl:choose>
                    <xsl:when test="$KeyFamID='notPassed'">
                         <xsl:choose>
                              <xsl:when test="/message:CompactData/message:Header/message:KeyFamilyRef">
                                   <xsl:value-of select="/message:CompactData/message:Header/message:KeyFamilyRef"/>
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
                                   <!-- Copy Header Data -->
                                   <xsl:apply-templates mode="copy-no-ns" select="/message:CompactData/message:Header"/>
                                   <!-- Create DataSet -->
                                   <xsl:for-each select="/message:CompactData/*[local-name()='DataSet']">
                                        <xsl:element name="DataSet">
                                             <xsl:attribute name="keyFamilyURI"><xsl:value-of select="$KeyFamURI"/></xsl:attribute>
                                             <xsl:element name="generic:KeyFamilyRef">
                                                  <xsl:value-of select="$KFID"/>
                                             </xsl:element>
                                             <!-- Create DataSet Attributes -->
                                             <xsl:variable name="DataSetAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='DataSet']"/>
                                             <xsl:if test="@*[local-name() = $DataSetAtts/@concept]">
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
                                             <!-- Create Groups -->
                                             <xsl:for-each select="*[local-name() != 'Series' and local-name() != 'Annotations']">
                                                  <xsl:variable name="GroupID">
                                                       <xsl:value-of select="local-name(.)"/>
                                                  </xsl:variable>
                                                  <xsl:element name="generic:Group">
                                                       <xsl:attribute name="type"><xsl:value-of select="$GroupID"/></xsl:attribute>
                                                       <!-- Create GroupKey -->
                                                       <xsl:variable name="GroupKey" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Group[@id = $GroupID]"/>
                                                       <xsl:element name="generic:GroupKey">
                                                            <xsl:for-each select="@*[local-name() = $GroupKey/*[local-name()='DimensionRef']/.]">
                                                                 <xsl:element name="generic:Value">
                                                                      <xsl:attribute name="concept"><xsl:value-of select="local-name(.)"/></xsl:attribute>
                                                                      <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                 </xsl:element>
                                                                 <!-- End Value -->
                                                            </xsl:for-each>
                                                       </xsl:element>
                                                       <!-- End GroupKey -->
                                                       <!-- Create Group Attributes -->
                                                       <xsl:variable name="GroupAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='Group']"/>
                                                       <xsl:if test="@*[local-name() = $GroupAtts/@concept]">
                                                            <xsl:element name="generic:Attributes">
                                                                 <xsl:for-each select="@*[local-name() = $GroupAtts/@concept]">
                                                                      <xsl:element name="generic:Value">
                                                                           <xsl:attribute name="concept"><xsl:value-of select="local-name(.)"/></xsl:attribute>
                                                                           <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                      </xsl:element>
                                                                      <!-- End Value -->
                                                                 </xsl:for-each>
                                                            </xsl:element>
                                                            <!-- End Attributes -->
                                                       </xsl:if>
                                                       <!-- Create Series for Group -->
                                                       <!-- Group Key Test Variable for matching Series to Group -->
                                                       <xsl:variable name="GKT">
                                                            <!-- Get Group Key Dimensions, sort them alphabetically by name, and pass {name}"="{value} into variable -->
                                                            <xsl:for-each select="@*[local-name() = $GroupKey/*[local-name()='DimensionRef']/.]">
                                                                 <xsl:sort select="local-name(.)"/>
                                                                 <xsl:value-of select="local-name(.)"/>
                                                                 <xsl:text>=</xsl:text>
                                                                 <xsl:value-of select="."/>
                                                            </xsl:for-each>
                                                       </xsl:variable>
                                                       <!-- Series Key Test Variable for matching Series to Group -->
                                                       <xsl:for-each select="/message:CompactData/*[local-name()='DataSet']/*[local-name()='Series']">
                                                            <xsl:variable name="SKT">
                                                                 <!-- Get Group Key Dimensions, sort them alphabetically by name, and pass {name}"="{value} into variable -->
                                                                 <xsl:for-each select="@*[local-name() = $GroupKey/*[local-name()='DimensionRef']/.]">
                                                                      <xsl:sort select="local-name(.)"/>
                                                                      <xsl:value-of select="local-name(.)"/>
                                                                      <xsl:text>=</xsl:text>
                                                                      <xsl:value-of select="."/>
                                                                 </xsl:for-each>
                                                            </xsl:variable>
                                                            <!-- If the Key Test Variables match, then Series is part of Group -->
                                                            <xsl:if test="$GKT = $SKT">
                                                                 <!-- Create Series -->
                                                                 <xsl:element name="generic:Series">
                                                                      <!-- Create SeriesKey -->
                                                                      <xsl:variable name="SeriesKey" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension"/>
                                                                      <xsl:element name="generic:SeriesKey">
                                                                           <xsl:for-each select="@*[local-name() = $SeriesKey/@concept]">
                                                                                <xsl:element name="generic:Value">
                                                                                     <xsl:attribute name="concept"><xsl:value-of select="local-name(.)"/></xsl:attribute>
                                                                                     <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                                </xsl:element>
                                                                                <!-- End Value -->
                                                                           </xsl:for-each>
                                                                      </xsl:element>
                                                                      <!-- End SeriesKey -->
                                                                      <!-- Create Series Attributes -->
                                                                      <xsl:variable name="SeriesAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='Series']"/>
                                                                      <xsl:if test="@*[local-name() = $SeriesAtts/@concept]">
                                                                           <xsl:element name="generic:Attributes">
                                                                                <xsl:for-each select="@*[local-name() = $SeriesAtts/@concept]">
                                                                                     <xsl:element name="generic:Value">
                                                                                          <xsl:attribute name="concept"><xsl:value-of select="local-name(.)"/></xsl:attribute>
                                                                                          <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                                     </xsl:element>
                                                                                     <!-- End Value -->
                                                                                </xsl:for-each>
                                                                           </xsl:element>
                                                                           <!-- End Attributes -->
                                                                      </xsl:if>
                                                                      <!-- Create Observations -->
                                                                      <xsl:for-each select="*[local-name()='Obs']">
                                                                           <xsl:element name="generic:Obs">
                                                                                <!-- Create Observation Time -->
                                                                                <xsl:for-each select="@*[local-name()=$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:TimeDimension/@concept]">
                                                                                     <xsl:element name="generic:Time">
                                                                                          <xsl:value-of select="."/>
                                                                                     </xsl:element>
                                                                                     <!-- End Time -->
                                                                                </xsl:for-each>
                                                                                <!-- Create Observation Value -->
                                                                                <xsl:for-each select="@*[local-name()=$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:PrimaryMeasure/@concept]">
                                                                                     <xsl:element name="generic:ObsValue">
                                                                                          <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                                     </xsl:element>
                                                                                     <!-- End ObsValue -->
                                                                                </xsl:for-each>
                                                                                <!-- Create Observation Attributes -->
                                                                                <xsl:variable name="ObsAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='Observation']"/>
                                                                                <xsl:if test="@*[local-name() = $ObsAtts/@concept]">
                                                                                     <xsl:element name="generic:Attributes">
                                                                                          <xsl:for-each select="@*[local-name() = $ObsAtts/@concept]">
                                                                                               <xsl:element name="generic:Value">
                                                                                                    <xsl:attribute name="concept"><xsl:value-of select="local-name(.)"/></xsl:attribute>
                                                                                                    <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                                               </xsl:element>
                                                                                               <!-- End Value -->
                                                                                          </xsl:for-each>
                                                                                     </xsl:element>
                                                                                     <!-- End Attributes -->
                                                                                </xsl:if>
                                                                                <!-- Copy Observation Annotations -->
                                                                                <xsl:for-each select="*[local-name() = 'Annotations']">
                                                                                     <xsl:element name="generic:Annotations">
                                                                                          <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                                                     </xsl:element>
                                                                                     <!-- End Annotations -->
                                                                                </xsl:for-each>
                                                                           </xsl:element>
                                                                           <!-- End Obs -->
                                                                      </xsl:for-each>
                                                                      <!-- Copy Series Annotations -->
                                                                      <xsl:for-each select="*[local-name() = 'Annotations']">
                                                                           <xsl:element name="generic:Annotations">
                                                                                <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                                           </xsl:element>
                                                                           <!-- End Annotations -->
                                                                      </xsl:for-each>
                                                                 </xsl:element>
                                                                 <!-- End Series -->
                                                            </xsl:if>
                                                       </xsl:for-each>
                                                       <!-- Copy Group Annotations -->
                                                       <xsl:for-each select="*[local-name() = 'Annotations']">
                                                            <xsl:element name="generic:Annotations">
                                                                 <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                            </xsl:element>
                                                            <!-- End Annotations -->
                                                       </xsl:for-each>
                                                  </xsl:element>
                                                  <!-- End Group -->
                                             </xsl:for-each>
                                             <!-- Create Non-Grouped Series -->
                                             <xsl:for-each select="/message:CompactData/*[local-name()='DataSet']/*[local-name()='Series']">
                                                  <!-- Variable to hold all attributes of Series - this will include attributes and dimensions-->
                                                  <xsl:variable name="SeriesAllAtts" select="@*"/>
                                                  <!-- Variable to determine wheter Series was found to be a member of an existing Group-->
                                                  <xsl:variable name="Found">
                                                       <!-- Loop through each Group -->
                                                       <xsl:for-each select="/message:CompactData/*[local-name()='DataSet']/*[local-name() != 'Series' and local-name() != 'Annotations']">
                                                            <xsl:variable name="GroupID">
                                                                 <xsl:value-of select="local-name(.)"/>
                                                            </xsl:variable>
                                                            <xsl:variable name="GroupKey" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Group[@id = $GroupID]"/>
                                                            <!-- Series Key Test Variable for matching Series to Group -->
                                                            <xsl:variable name="SKT">
                                                                 <!-- Get Group Key Dimensions, sort them alphabetically by name, and pass {name}"="{value} into variable -->
                                                                 <xsl:for-each select="$SeriesAllAtts[local-name() = $GroupKey/*[local-name()='DimensionRef']/.]">
                                                                      <xsl:sort select="local-name(.)"/>
                                                                      <xsl:value-of select="local-name(.)"/>
                                                                      <xsl:text>=</xsl:text>
                                                                      <xsl:value-of select="."/>
                                                                 </xsl:for-each>
                                                            </xsl:variable>
                                                            <!-- Group Key Test Variable for matching Series to Group -->
                                                            <xsl:variable name="GKT">
                                                                 <!-- Get Group Key Dimensions, sort them alphabetically by name, and pass {name}"="{value} into variable -->
                                                                 <xsl:for-each select="@*[local-name() = $GroupKey/*[local-name()='DimensionRef']/.]">
                                                                      <xsl:sort select="local-name(.)"/>
                                                                      <xsl:value-of select="local-name(.)"/>
                                                                      <xsl:text>=</xsl:text>
                                                                      <xsl:value-of select="."/>
                                                                 </xsl:for-each>
                                                            </xsl:variable>
                                                            <!-- If the Key Test variables match, then this Series in part of a group, and therefore should not be rewritten -->
                                                            <!-- Pass an "X" into the variable -->
                                                            <xsl:if test="$GKT = $SKT">X</xsl:if>
                                                       </xsl:for-each>
                                                  </xsl:variable>
                                                  <!-- If the Series was not found to be part of any Group, the Found variable will be empty-->
                                                  <xsl:if test="$Found=''">
                                                       <!-- Create Series -->
                                                       <xsl:element name="generic:Series">
                                                            <!-- Create SeriesKey -->
                                                            <xsl:variable name="SeriesKey" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension"/>
                                                            <xsl:element name="generic:SeriesKey">
                                                                 <xsl:for-each select="@*[local-name() = $SeriesKey/@concept]">
                                                                      <xsl:element name="generic:Value">
                                                                           <xsl:attribute name="concept"><xsl:value-of select="local-name(.)"/></xsl:attribute>
                                                                           <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                      </xsl:element>
                                                                      <!-- End Value -->
                                                                 </xsl:for-each>
                                                            </xsl:element>
                                                            <!-- End SeriesKey -->
                                                            <xsl:variable name="SeriesAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='Series']"/>
                                                            <xsl:if test="@*[local-name() = $SeriesAtts/@concept]">
                                                                 <xsl:element name="generic:Attributes">
                                                                      <xsl:for-each select="@*[local-name() = $SeriesAtts/@concept]">
                                                                           <xsl:element name="generic:Value">
                                                                                <xsl:attribute name="concept"><xsl:value-of select="local-name(.)"/></xsl:attribute>
                                                                                <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                           </xsl:element>
                                                                           <!-- End Value -->
                                                                      </xsl:for-each>
                                                                 </xsl:element>
                                                                 <!-- End Attributes -->
                                                            </xsl:if>
                                                            <!-- Create Observations -->
                                                            <xsl:for-each select="*[local-name()='Obs']">
                                                                 <xsl:element name="generic:Obs">
                                                                      <!-- Create Observation Time -->
                                                                      <xsl:for-each select="@*[local-name()=$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:TimeDimension/@concept]">
                                                                           <xsl:element name="generic:Time">
                                                                                <xsl:value-of select="."/>
                                                                           </xsl:element>
                                                                           <!-- End Time -->
                                                                      </xsl:for-each>
                                                                      <!-- Create Observation Value -->
                                                                      <xsl:for-each select="@*[local-name()=$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:PrimaryMeasure/@concept]">
                                                                           <xsl:element name="generic:ObsValue">
                                                                                <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                           </xsl:element>
                                                                           <!-- End ObsValue -->
                                                                      </xsl:for-each>
                                                                      <!-- Create Observation Attributes -->
                                                                      <xsl:variable name="ObsAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='Observation']"/>
                                                                      <xsl:if test="@*[local-name() = $ObsAtts/@concept]">
                                                                           <xsl:element name="generic:Attributes">
                                                                                <xsl:for-each select="@*[local-name() = $ObsAtts/@concept]">
                                                                                     <xsl:element name="generic:Value">
                                                                                          <xsl:attribute name="concept"><xsl:value-of select="local-name(.)"/></xsl:attribute>
                                                                                          <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                                     </xsl:element>
                                                                                     <!-- End Value -->
                                                                                </xsl:for-each>
                                                                           </xsl:element>
                                                                           <!-- End Attributes -->
                                                                      </xsl:if>
                                                                      <!-- Copy Observation Annotations -->
                                                                      <xsl:for-each select="*[local-name() = 'Annotations']">
                                                                           <xsl:element name="generic:Annotations">
                                                                                <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                                           </xsl:element>
                                                                           <!-- End Annotations -->
                                                                      </xsl:for-each>
                                                                 </xsl:element>
                                                                 <!-- End Obs -->
                                                            </xsl:for-each>
                                                            <!-- Copy Series Annotations -->
                                                            <xsl:for-each select="*[local-name() = 'Annotations']">
                                                                 <xsl:element name="generic:Annotations">
                                                                      <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                                 </xsl:element>
                                                                 <!-- End Annotations -->
                                                            </xsl:for-each>
                                                       </xsl:element>
                                                       <!-- End Series -->
                                                  </xsl:if>
                                             </xsl:for-each>
                                             <!-- Copy DataSet Annotations -->
                                             <xsl:for-each select="*[local-name() = 'Annotations']">
                                                  <xsl:element name="generic:Annotations">
                                                       <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                                  </xsl:element>
                                                  <!-- End Annotations -->
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
</xsl:stylesheet>
