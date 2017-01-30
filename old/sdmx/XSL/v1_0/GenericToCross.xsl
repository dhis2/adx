<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" 
xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/cross" 
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:exslt="http://exslt.org/common" 
extension-element-prefixes="exslt" 
exclude-result-prefixes="xsl structure message generic exslt"
version="1.0">
     <!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
     <xsl:import href="HeaderCopy.xsl"/>
     <xsl:strip-space elements="*"/>
     <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
     <!-- Input Parameters -->
     <!-- Namespace of the Cross Sectional schema, optional - will be defaulted if not passed, resulting instance will have to be modified -->
     <xsl:param name="Namespace">notPassed</xsl:param>
     <!-- URI of Key Family xml instance, conditional: mandatory if GenericData/DataSet/@keyFamilyURI not used in Generic instance - used to find strcture of Key Family -->
     <xsl:param name="KeyFamURI">notPassed</xsl:param>
     <!-- URI of the SDMXMessage.xsd, optional - used to set schemaLocation, for easier validation of Cross Sectional instance -->
     <xsl:param name="MessageURI">notPassed</xsl:param>
     <!-- URI of the Cross Sectional schema, optional - used to set schemaLocation, for easier validation of Cross Sectional instance -->
     <xsl:param name="CrossSectionalURI">notPassed</xsl:param>
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
          <!-- Set the schemaLocation(s) for Cross Sectional instance -->
          <xsl:variable name="SchemaLoc">
               <xsl:choose>
                    <xsl:when test="$MessageURI != 'notPassed' and $CrossSectionalURI != 'notPassed'">
                         <xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message </xsl:text>
                         <xsl:value-of select="$MessageURI"/>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="$Namespace"/>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="$CrossSectionalURI"/>
                    </xsl:when>
                    <xsl:when test="$MessageURI != 'notPassed' and $CrossSectionalURI = 'notPassed'">
                         <xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message </xsl:text>
                         <xsl:value-of select="$MessageURI"/>
                    </xsl:when>
                    <xsl:when test="$MessageURI = 'notPassed' and $CrossSectionalURI != 'notPassed'">
                         <xsl:value-of select="$Namespace"/>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="$CrossSectionalURI"/>
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
          <!-- It is only used, when processed with exslt, and is only cosmetic -->
          <xsl:variable name="ns-node">
               <xsl:element name="csds:ns-element" namespace="{$Namespace}"/>
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
                    <!-- Start CrossSectional instance-->
                    <CrossSectionalData>
                         <!-- If exslt is used, copy the Compact namespace declaration to the root element - cosmetic only -->
                         <xsl:if test="function-available('exslt:node-set')">
                              <xsl:copy-of select="exslt:node-set($ns-node)/*/namespace::*[local-name()='csds']"/>
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
                         <xsl:element name="csds:DataSet" namespace="{$Namespace}">
                              <!-- Variables for Cross Sectional DataSet Attributes-->
                              <xsl:variable name="DataSetDims" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:Dimension[@isFrequencyDimension = 'true' or @crossSectionalAttachDataSet = 'true']/@concept"/>
                              <xsl:variable name="DataSetAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:Attribute[@crossSectionalAttachDataSet = 'true']/@concept"/>
                              <!-- Variables for Defining Cross Sectional Groups -->
                              <xsl:variable name="GroupDims" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:Dimension[@isFrequencyDimension = 'true' or @crossSectionalAttachGroup = 'true']/@concept"/>
                              <xsl:variable name="GroupAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:Attribute[@crossSectionalAttachGroup = 'true']/@concept"/>
                              <!-- Variables for Defining Cross Sectional Sections -->
                              <xsl:variable name="SectDims" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:Dimension[@crossSectionalAttachSection = 'true']/@concept"/>
                              <xsl:variable name="SectAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:Attribute[@crossSectionalAttachSection = 'true']/@concept"/>
                              <!-- Variables for Defining Cross Sectional Observations -->
                              <xsl:variable name="ObsDims" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:Dimension[@crossSectionalAttachObservation = 'true']/@concept"/>
                              <xsl:variable name="ObsAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:Attribute[@crossSectionalAttachObservation = 'true']/@concept"/>
                              <!-- Variable for Cross Sectional Measures -->
                              <xsl:variable name="CSMeasures" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]/structure:Components/structure:CrossSectionalMeasure"/>
                              <!-- Create DataSet Attributes-->
                              <xsl:for-each select="$DataSetDims">
                                   <xsl:variable name="DataSetDim" select="."/>
                                   <!-- Create DataSet Dimension Attributes -->
                                   <xsl:if test="/message:GenericData/message:DataSet//generic:Series/generic:SeriesKey/generic:Value[@concept = $DataSetDim]/@value">
                                        <xsl:attribute name="{$DataSetDim}">
                                             <xsl:value-of select="/message:GenericData/message:DataSet//generic:Series/generic:SeriesKey/generic:Value[@concept = $DataSetDim]/@value"/>
                                        </xsl:attribute>
                                   </xsl:if>
                              </xsl:for-each>
                              <xsl:for-each select="$DataSetAtts">
                                   <xsl:variable name="DataSetAtt" select="."/>
                                   <!-- Create DataSet Attribute Attributes-->
                                   <xsl:if test="/message:GenericData/message:DataSet//generic:Attributes/generic:Value[@concept = $DataSetAtt]/@value">
                                        <xsl:attribute name="{$DataSetAtt}">
                                             <xsl:value-of select="/message:GenericData/message:DataSet//generic:Attributes/generic:Value[@concept = $DataSetAtt]/@value"/>
                                        </xsl:attribute>
                                   </xsl:if>
                              </xsl:for-each>
                              <!-- Create Cross Sectional Groups -->
                              <!-- Variable for Observations -->
                              <xsl:variable name="Observation" select="//generic:Obs"/>
                              <!-- Loop through Observations to match Groups -->
                              <xsl:for-each select="$Observation">
                                   <!-- Variable for Observation -->
                                   <xsl:variable name="Obs" select="."/>
                                   <!-- Variable for Position of Observation -->
                                   <xsl:variable name="Pos" select="position()"/>
                                   <!-- Variable to determine wheter Observation is unique and therefore should start a new Group -->
                                   <xsl:variable name="UniqueGroup">
                                        <!-- Loop through each Dimension attached to the Group-->
                                        <xsl:for-each select="$GroupDims">
                                             <xsl:variable name="GroupDim" select="."/>
                                             <!-- Get Dimension value for the Observation -->
                                             <xsl:variable name="DimValue" select="$Obs/../generic:SeriesKey/generic:Value[@concept = $GroupDim]/@value"/>
                                             <!-- Check that no other Observation has the same value for the Dimension -->
                                             <!-- If another Observation has the same value, the variable will have content -->
                                             <xsl:variable name="PriorDimValue" select="$Obs/preceding::generic:Obs/../generic:SeriesKey/generic:Value[@concept = $GroupDim]/@value[. = $DimValue]"/>
                                             <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                        </xsl:for-each>
                                        <!-- Loop through each Attribute attached to the Group -->
                                        <xsl:for-each select="$GroupAtts">
                                             <xsl:variable name="GroupAtt" select="."/>
                                             <!-- Get Attribute value for the Observation -->
                                             <xsl:variable name="AttValue" select="$Obs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $GroupAtt]/@value"/>
                                             <!-- Check that no other Observation has the same value for the Attribute -->
                                             <!-- If another Observation has the same value, the variable will have content -->
                                             <xsl:choose>
                                                  <xsl:when test="$GroupAtt/../@attachmentLevel='Observation'">
                                                       <xsl:variable name="PriorAttValue" select="$Obs/preceding::generic:Obs/generic:Attributes/generic:Value[@concept = $GroupAtt]/@value[. = $AttValue]"/>
                                                       <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                  </xsl:when>
                                                  <xsl:when test="$GroupAtt/../@attachmentLevel='Series'">
                                                       <xsl:variable name="PriorAttValue" select="$Obs/ancestor::generic:Series/preceding::generic:Series/generic:Attributes/generic:Value[@concept = $GroupAtt]/@value[. = $AttValue]"/>
                                                       <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                  </xsl:when>
                                                  <xsl:when test="$GroupAtt/../@attachmentLevel='Group'">
                                                       <xsl:variable name="PriorAttValue" select="$Obs/ancestor::generic:Group/preceding::generic:Group/generic:Attributes/generic:Value[@concept = $GroupAtt]/@value[. = $AttValue]"/>
                                                       <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                  </xsl:when>
                                             </xsl:choose>
                                        </xsl:for-each>
                                        <!-- Get Time value for Observation-->
                                        <xsl:variable name="Time" select="generic:Time"/>
                                        <!-- Check that no other Observation has the same Time value-->
                                        <xsl:variable name="PriorTime" select="$Obs/preceding::generic:Obs/generic:Time[. = $Time]"/>
                                        <!-- If another Observaton has the same Time value, the variable will have content -->
                                        <xsl:if test="not($PriorTime)">X</xsl:if>
                                   </xsl:variable>
                                   <!-- If the UniqueGroup variable is not empty, then the Observation belongs to a new Group -->
                                   <xsl:if test="$UniqueGroup != ''">
                                        <!-- Variable to define the Dimensions, Attributes, and Time that define the new Group -->
                                        <xsl:variable name="GroupKey">
                                             <!-- Get Group Dimensions -->
                                             <xsl:for-each select="$GroupDims">
                                                  <xsl:variable name="GroupDim" select="."/>
                                                  <xsl:variable name="DimValue" select="$Obs/../generic:SeriesKey/generic:Value[@concept = $GroupDim]/@value"/>
                                                  <xsl:value-of select="$GroupDim"/>=<xsl:value-of select="$DimValue"/>
                                             </xsl:for-each>
                                             <!-- Get Group Attributes -->
                                             <xsl:for-each select="$GroupAtts">
                                                  <xsl:variable name="GroupAtt" select="."/>
                                                  <xsl:variable name="AttValue" select="$Obs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $GroupAtt]/@value"/>
                                                  <xsl:value-of select="$GroupAtt"/>=<xsl:value-of select="$AttValue"/>
                                             </xsl:for-each>
                                             <!-- Get Time -->
                                             <xsl:value-of select="generic:Time"/>
                                        </xsl:variable>
                                        <!-- Create Group -->
                                        <xsl:element name="csds:Group" namespace="{$Namespace}">
                                             <!-- Create Group Dimension Attributes -->
                                             <xsl:for-each select="$GroupDims">
                                                  <xsl:variable name="GroupDim" select="."/>
                                                  <xsl:variable name="DimValue" select="$Obs/../generic:SeriesKey/generic:Value[@concept = $GroupDim]/@value"/>
                                                  <xsl:if test="$DimValue">
                                                       <xsl:attribute name="{$GroupDim}"><xsl:value-of select="$DimValue"/></xsl:attribute>
                                                  </xsl:if>
                                             </xsl:for-each>
                                             <!-- Create Group Attribute Attributes -->
                                             <xsl:for-each select="$GroupAtts">
                                                  <xsl:variable name="GroupAtt" select="."/>
                                                  <xsl:variable name="AttValue" select="$Obs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $GroupAtt]/@value"/>
                                                  <xsl:if test="$AttValue">
                                                       <xsl:attribute name="{$GroupAtt}"><xsl:value-of select="$AttValue"/></xsl:attribute>
                                                  </xsl:if>
                                             </xsl:for-each>
                                             <!-- Create Group Time Attribute -->
                                             <xsl:if test="generic:Time">
                                                  <xsl:attribute name="time"><xsl:value-of select="generic:Time"/></xsl:attribute>
                                             </xsl:if>
                                             <!-- Loop through all subsequent Observations, to check if it belongs to the Group -->
                                             <xsl:variable name="GroupObservation" select="$Observation[position() >= $Pos]"/>
                                             <xsl:for-each select="$GroupObservation">
                                                  <xsl:variable name="GroupPos" select="position()"/>
                                                  <xsl:variable name="MGObs" select="."/>
                                                  <xsl:variable name="GroupKeyTest">
                                                       <xsl:for-each select="$GroupDims">
                                                            <xsl:variable name="GroupDim" select="."/>
                                                            <xsl:variable name="DimValue" select="$MGObs/../generic:SeriesKey/generic:Value[@concept = $GroupDim]/@value"/>
                                                            <xsl:value-of select="$GroupDim"/>=<xsl:value-of select="$DimValue"/>
                                                       </xsl:for-each>
                                                       <xsl:for-each select="$GroupAtts">
                                                            <xsl:variable name="GroupAtt" select="."/>
                                                            <xsl:variable name="AttValue" select="$MGObs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $GroupAtt]/@value"/>
                                                            <xsl:value-of select="$GroupAtt"/>=<xsl:value-of select="$AttValue"/>
                                                       </xsl:for-each>
                                                       <xsl:variable name="Time" select="generic:Time"/>
                                                       <xsl:value-of select="$Time"/>
                                                  </xsl:variable>
                                                  <xsl:if test="$GroupKey = $GroupKeyTest">
                                                       <!-- Loop Through Observations to Match Sections-->
                                                       <xsl:for-each select="$GroupObservation[position() >= $GroupPos]">
                                                            <xsl:variable name="SObs" select="."/>
                                                            <xsl:variable name="GroupKeyTest2">
                                                                 <xsl:for-each select="$GroupDims">
                                                                      <xsl:variable name="GroupDim" select="."/>
                                                                      <xsl:variable name="DimValue" select="$SObs/../generic:SeriesKey/generic:Value[@concept = $GroupDim]/@value"/>
                                                                      <xsl:value-of select="$GroupDim"/>=<xsl:value-of select="$DimValue"/>
                                                                 </xsl:for-each>
                                                                 <xsl:for-each select="$GroupAtts">
                                                                      <xsl:variable name="GroupAtt" select="."/>
                                                                      <xsl:variable name="AttValue" select="$SObs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $GroupAtt]/@value"/>
                                                                      <xsl:value-of select="$GroupAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                 </xsl:for-each>
                                                                 <xsl:variable name="Time" select="generic:Time"/>
                                                                 <xsl:value-of select="$Time"/>
                                                            </xsl:variable>
                                                            <!-- First Check that the Observation belongs to the current Group-->
                                                            <xsl:if test="$GroupKey = $GroupKeyTest2">
                                                                 <xsl:variable name="UniqueSection">
                                                                      <!-- Loop through each Dimension attached to the Section -->
                                                                      <xsl:for-each select="$SectDims">
                                                                           <xsl:variable name="SectDim" select="."/>
                                                                           <!-- Get Dimension value for the Observation -->
                                                                           <xsl:variable name="DimValue" select="$SObs/../generic:SeriesKey/generic:Value[@concept = $SectDim]/@value"/>
                                                                           <!-- Check that no other Observation has the same value for the Dimension -->
                                                                           <!-- If another Observation has the same value, the variable will have content -->
                                                                           <xsl:variable name="PriorDimValue" select="$SObs/preceding::generic:Obs/../generic:SeriesKey/generic:Value[@concept = $SectDim]/@value[. = $DimValue]"/>
                                                                           <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                                                      </xsl:for-each>
                                                                      <!-- Loop through each Attribute attached to the Group -->
                                                                      <xsl:for-each select="$SectAtts">
                                                                           <xsl:variable name="SectAtt" select="."/>
                                                                           <!-- Get Attribute value for the Observation -->
                                                                           <xsl:variable name="AttValue" select="$SObs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $SectAtt]/@value"/>
                                                                           <!-- Check that no other Observation has the same value for the Attribute -->
                                                                           <!-- If another Observation has the same value, the variable will have content -->
                                                                           <xsl:choose>
                                                                                <xsl:when test="$SectAtt/../@attachmentLevel='Observation'">
                                                                                     <xsl:variable name="PriorAttValue" select="$SObs/preceding::generic:Obs/generic:Attributes/generic:Value[@concept = $SectAtt]/@value[. = $AttValue]"/>
                                                                                     <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                                </xsl:when>
                                                                                <xsl:when test="$SectAtt/../@attachmentLevel='Series'">
                                                                                     <xsl:variable name="PriorAttValue" select="$SObs/ancestor::generic:Series/preceding::generic:Series/generic:Attributes/generic:Value[@concept = $SectAtt]/@value[. = $AttValue]"/>
                                                                                     <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                                </xsl:when>
                                                                                <xsl:when test="$SectAtt/../@attachmentLevel='Group'">
                                                                                     <xsl:variable name="PriorAttValue" select="$SObs/ancestor::generic:Group/preceding::generic:Group/generic:Attributes/generic:Value[@concept = $SectAtt]/@value[. = $AttValue]"/>
                                                                                     <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                                </xsl:when>
                                                                           </xsl:choose>
                                                                      </xsl:for-each>
                                                                 </xsl:variable>
                                                                 <!-- If the UniqueSection variable is empty, then the Observation belongs to a new Section -->
                                                                 <xsl:if test="$UniqueSection != ''">
                                                                      <!-- Variable to define the Dimensions and Attributes that define the new Section -->
                                                                      <xsl:variable name="SectKey">
                                                                           <!-- Get Section Dimensions -->
                                                                           <xsl:for-each select="$SectDims">
                                                                                <xsl:variable name="SectDim" select="."/>
                                                                                <xsl:variable name="DimValue" select="$SObs/../generic:SeriesKey/generic:Value[@concept = $SectDim]/@value"/>
                                                                                <xsl:value-of select="$SectDim"/>=<xsl:value-of select="$DimValue"/>
                                                                           </xsl:for-each>
                                                                           <!-- Get Section Attributes -->
                                                                           <xsl:for-each select="$SectAtts">
                                                                                <xsl:variable name="SectAtt" select="."/>
                                                                                <xsl:variable name="AttValue" select="$SObs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $SectAtt]/@value"/>
                                                                                <xsl:value-of select="$SectAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                           </xsl:for-each>
                                                                      </xsl:variable>
                                                                      <!-- Create Section -->
                                                                      <xsl:element name="csds:Section" namespace="{$Namespace}">
                                                                           <!-- Create Section Dimension Attributes -->
                                                                           <xsl:for-each select="$SectDims">
                                                                                <xsl:variable name="SectDim" select="."/>
                                                                                <xsl:variable name="DimValue" select="$SObs/../generic:SeriesKey/generic:Value[@concept = $SectDim]/@value"/>
                                                                                <xsl:if test="$DimValue">
                                                                                     <xsl:attribute name="{$SectDim}"><xsl:value-of select="$DimValue"/></xsl:attribute>
                                                                                </xsl:if>
                                                                           </xsl:for-each>
                                                                           <!-- Create Section Attribute Attributes -->
                                                                           <xsl:for-each select="$SectAtts">
                                                                                <xsl:variable name="SectAtt" select="."/>
                                                                                <xsl:variable name="AttValue" select="$SObs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $SectAtt]/@value"/>
                                                                                <xsl:if test="$AttValue">
                                                                                     <xsl:attribute name="{$SectAtt}"><xsl:value-of select="$AttValue"/></xsl:attribute>
                                                                                </xsl:if>
                                                                           </xsl:for-each>
                                                                           <!-- Loop through all subsequent Observations, to check if it belongs to the Section -->
                                                                           <xsl:for-each select="$GroupObservation[position() >= $GroupPos]">
                                                                                <xsl:variable name="MSObs" select="."/>
                                                                                <xsl:variable name="SectKeyTest">
                                                                                     <xsl:for-each select="$SectDims">
                                                                                          <xsl:variable name="SectDim" select="."/>
                                                                                          <xsl:variable name="DimValue" select="$MSObs/../generic:SeriesKey/generic:Value[@concept = $SectDim]/@value"/>
                                                                                          <xsl:value-of select="$SectDim"/>=<xsl:value-of select="$DimValue"/>
                                                                                     </xsl:for-each>
                                                                                     <xsl:for-each select="$SectAtts">
                                                                                          <xsl:variable name="SectAtt" select="."/>
                                                                                          <xsl:variable name="AttValue" select="$MSObs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $SectAtt]/@value"/>
                                                                                          <xsl:value-of select="$SectAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                                     </xsl:for-each>
                                                                                </xsl:variable>
                                                                                <xsl:variable name="GroupKeyTest3">
                                                                                     <xsl:for-each select="$GroupDims">
                                                                                          <xsl:variable name="GroupDim" select="."/>
                                                                                          <xsl:variable name="DimValue" select="$MSObs/../generic:SeriesKey/generic:Value[@concept = $GroupDim]/@value"/>
                                                                                          <xsl:value-of select="$GroupDim"/>=<xsl:value-of select="$DimValue"/>
                                                                                     </xsl:for-each>
                                                                                     <xsl:for-each select="$GroupAtts">
                                                                                          <xsl:variable name="GroupAtt" select="."/>
                                                                                          <xsl:variable name="AttValue" select="$MSObs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $GroupAtt]/@value"/>
                                                                                          <xsl:value-of select="$GroupAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                                     </xsl:for-each>
                                                                                     <xsl:variable name="Time" select="generic:Time"/>
                                                                                     <xsl:value-of select="$Time"/>
                                                                                </xsl:variable>
                                                                                <xsl:if test="(($SectKey = $SectKeyTest) and ($GroupKey = $GroupKeyTest3))">
                                                                                     <!-- Find Each Cross Sectional Measure For Observation -->
                                                                                     <xsl:for-each select="$CSMeasures">
                                                                                          <xsl:variable name="CSDim" select="@measureDimension"/>
                                                                                          <xsl:variable name="CSValue" select="@code"/>
                                                                                          <xsl:variable name="CSName" select="@concept"/>
                                                                                          <!-- If Observation Matches the Cross Sectional Measure, create element -->
                                                                                          <xsl:if test="$MSObs/../generic:SeriesKey/generic:Value[@concept = $CSDim]/@value = $CSValue">
                                                                                               <!-- Create Cross Sectional Observation element-->
                                                                                               <xsl:element name="csds:{$CSName}" namespace="{$Namespace}">
                                                                                                    <!-- Create Cross Sectional Observation Dimension Attributes -->
                                                                                                    <xsl:for-each select="$ObsDims">
                                                                                                         <xsl:variable name="ObsDim" select="."/>
                                                                                                         <xsl:variable name="DimValue" select="$MSObs/../generic:SeriesKey/generic:Value[@concept = $ObsDim]/@value"/>
                                                                                                         <xsl:if test="$DimValue">
                                                                                                              <xsl:attribute name="{$ObsDim}"><xsl:value-of select="$DimValue"/></xsl:attribute>
                                                                                                         </xsl:if>
                                                                                                    </xsl:for-each>
                                                                                                    <!-- Create Cross Sectional Observation Attribute Attributes -->
                                                                                                    <xsl:for-each select="$ObsAtts">
                                                                                                         <xsl:variable name="ObsAtt" select="."/>
                                                                                                         <xsl:variable name="AttValue" select="$MSObs/ancestor-or-self::*/generic:Attributes/generic:Value[@concept = $ObsAtt]/@value"/>
                                                                                                         <xsl:if test="$AttValue">
                                                                                                              <xsl:attribute name="{$ObsAtt}"><xsl:value-of select="$AttValue"/></xsl:attribute>
                                                                                                         </xsl:if>
                                                                                                    </xsl:for-each>
                                                                                                    <xsl:attribute name="value"><xsl:value-of select="$MSObs/generic:ObsValue/@value"/></xsl:attribute>
                                                                                               </xsl:element>
                                                                                               <!-- End Cross Sectional Observation element -->
                                                                                          </xsl:if>
                                                                                     </xsl:for-each>
                                                                                </xsl:if>
                                                                           </xsl:for-each>
                                                                      </xsl:element>
                                                                      <!-- End Section -->
                                                                 </xsl:if>
                                                            </xsl:if>
                                                       </xsl:for-each>
                                                  </xsl:if>
                                             </xsl:for-each>
                                        </xsl:element>
                                        <!-- End Group -->
                                   </xsl:if>
                              </xsl:for-each>
                              <!-- Copy DataSet Annotations -->
                              <xsl:for-each select="/message:GenericData/message:DataSet/generic:Annotations">
                                   <xsl:element name="csds:Annotations" namespace="{$Namespace}">
                                        <xsl:apply-templates mode="copy-no-ns" select="*"/>
                                   </xsl:element>
                              </xsl:for-each>
                         </xsl:element>
                         <!-- End DataSet -->
                    </CrossSectionalData>
                    <!-- End CrossSectionalData -->
               </xsl:when>
               <!-- Key Family not found in Key Family instance -->
               <xsl:otherwise>
                    <xsl:comment>Key Family <xsl:value-of select="$KeyFamID"/> not found in <xsl:value-of select="$KFLoc"/>.</xsl:comment>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
</xsl:stylesheet>
