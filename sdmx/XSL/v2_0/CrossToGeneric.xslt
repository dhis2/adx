<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common"
 xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross" 
 xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic" 
 xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
 xmlns:exslt="http://exslt.org/common" 
 extension-element-prefixes="exslt" 
 exclude-result-prefixes="xsl structure message cross"
 version="1.0" >
     <!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
     <xsl:import href="HeaderCopy.xslt"/>
     <xsl:strip-space elements="*"/>
     <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
     <!-- Input Parameters -->
     <!-- ID of Key Family, conditional: mandatory if CompactData/Header/KeyFamilyRef is not used in Compact instance -->
     <xsl:param name="KeyFamID">notPassed</xsl:param>
     <!-- URI of Key Family xml instance, mandatory - needed to find strcture of Key Family -->
     <xsl:param name="KeyFamURI">notPassed</xsl:param>
     <!-- URI of the SDMXMessage.xsd, optional - used to set schemaLocation, for easier validation of Generic instance -->
     <xsl:param name="MessageURI">notPassed</xsl:param>
     <!-- Group ID for grouping data, optional - used to group the data, if not passed then data will not be grouped -->
     <xsl:param name="GroupID">notPassed</xsl:param>
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
                              <xsl:when test="/message:CrossSectionalData/message:Header/message:KeyFamilyRef">
                                   <xsl:value-of select="/message:CrossSectionalData/message:Header/message:KeyFamilyRef"/>
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
          <xsl:variable name="Structure" select="document($KFLoc, .)"/>
          <!-- Check that the Key Family instance contains the Key Family-->
          <xsl:choose>
               <!-- Key Family ID set -->
               <xsl:when test="$KFID != 'notPassed'">
                    <!-- Check that the Key Family instance contains the Key Family-->
                    <xsl:choose>
                         <!-- Key Family exists in Key Family instance -->
                         <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]">
                              <!-- Variable for Data Set Attributes-->
                              <xsl:variable name="DataSetAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='DataSet']/@conceptRef"/>
                              <!-- Variables for Defining Groups -->
                              <xsl:variable name="GroupDims" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Group[@id=$GroupID]/structure:DimensionRef"/>
                              <xsl:variable name="GroupAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[structure:AttachmentGroup=$GroupID]/@conceptRef"/>
                              <!-- Variables for Defining Series -->
                              <xsl:variable name="SeriesDims" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension/@conceptRef"/>
										<xsl:variable name="TimeDim" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:TimeDimension/@conceptRef"/>
                              <xsl:variable name="SeriesAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='Series']/@conceptRef"/>
                              <!-- Variables for Defining Observations -->
                              <xsl:variable name="ObsAtts" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='Observation']/@concepRef"/>
                              <!-- Variable for Cross Sectional Measures -->
                              <xsl:variable name="XSMeas" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/*[self::structure:CrossSectionalMeasure or self::structure:PrimaryMeasure]/@conceptRef"/>
                              <!-- Start GenericData instance -->
                              <GenericData>
                                   <!-- Set schemaLocation -->
                                   <xsl:if test="$SchemaLoc != 'notPassed'">
                                        <xsl:attribute name="xsi:schemaLocation"><xsl:value-of select="$SchemaLoc"/></xsl:attribute>
                                   </xsl:if>
                                   <!-- Copy Header Data -->
                                   <xsl:apply-templates mode="copy-no-ns" select="/message:CrossSectionalData/message:Header"/>
                                   <!-- Create DataSet -->
                                   <xsl:for-each select="/message:CrossSectionalData/*[local-name()='DataSet']">
                                        <xsl:variable name="DataSet" select="."/>
                                        <xsl:element name="DataSet">
                                             <xsl:attribute name="keyFamilyURI"><xsl:value-of select="$KeyFamURI"/></xsl:attribute>
                                             <xsl:element name="generic:KeyFamilyRef">
                                                  <xsl:value-of select="$KFID"/>
                                             </xsl:element>
                                             <!-- Create DataSet Attributes -->
                                             <xsl:if test="$DataSet/descendant-or-self::*/@*[local-name()=$DataSetAtts]">
                                                  <xsl:element name="generic:Attributes">
                                                       <xsl:for-each select="$DataSetAtts">
                                                            <xsl:variable name="DataSetAtt" select="."/>
                                                            <xsl:if test="$DataSet/descendant-or-self::*/@*[local-name()=$DataSetAtt]">
                                                                 <xsl:element name="generic:Value">
                                                                      <xsl:attribute name="concept"><xsl:value-of select="$DataSetAtt"/></xsl:attribute>
                                                                      <xsl:attribute name="value"><xsl:value-of select="$DataSet/descendant-or-self::*/@*[local-name()=$DataSetAtt]"/></xsl:attribute>
                                                                 </xsl:element>
                                                                 <!-- End Value -->
                                                            </xsl:if>
                                                       </xsl:for-each>
                                                  </xsl:element>
                                                  <!-- End Attributes -->
                                             </xsl:if>
                                             <!-- Check that the Group was found-->
                                             <xsl:choose>
                                                  <!-- If Group was found, create grouped data -->
                                                  <xsl:when test="$GroupDims">
                                                       <!-- Loop through each grouped Cross Sectional Observation -->
                                                       <!-- Observations not grouped will be ignored, since they will have no time associate with them -->
                                                       <xsl:variable name="Observations" select="$DataSet//*[local-name()=$XSMeas]"/>
                                                       <xsl:for-each select="$Observations">
                                                            <xsl:variable name="Obs" select="."/>
                                                            <xsl:variable name="Section" select="ancestor::*[local-name()='Section']"/>
                                                            <xsl:variable name="Group" select="ancestor::*[local-name()='Group']"/>
                                                            <xsl:variable name="Pos" select="position()"/>
                                                            <xsl:variable name="Measure" select="local-name()"/>
                                                            <!-- Variable to determine whether a new group should be created base on this Observation -->
                                                            <xsl:variable name="UniqueGroup">
                                                                 <!-- Check each Dimension for the Group -->
                                                                 <xsl:for-each select="$GroupDims">
                                                                      <xsl:variable name="GroupDim" select="."/>
                                                                      <xsl:choose>
                                                                           <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$GroupDim]/@isMeasureDimension='true'">
                                                                                <xsl:if test="not($Obs/preceding::*[local-name()=local-name($Obs)])">X</xsl:if>
                                                                           </xsl:when>
                                                                           <xsl:otherwise>
                                                                                <xsl:variable name="DimValue" select="$Obs/ancestor-or-self::*/@*[name()=$GroupDim]"/>
                                                                                <xsl:choose>
                                                                                     <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$GroupDim]/@crossSectionalAttachGroup='true'">
                                                                                          <xsl:variable name="PriorDimValue" select="$Group/preceding::*[local-name()='Group'][@*[name()=$GroupDim]=$DimValue]"/>
                                                                                          <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                                                                     </xsl:when>
                                                                                     <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$GroupDim]/@crossSectionalAttachSection='true'">
                                                                                          <xsl:variable name="PriorDimValue" select="$Section/preceding::*[local-name()='Section'][@*[name()=$GroupDim]=$DimValue]"/>
                                                                                          <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                                                                     </xsl:when>
                                                                                     <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$GroupDim]/@crossSectionalAttachObservation='true'">
                                                                                          <xsl:variable name="PriorDimValue" select="$Obs/preceding::*[name()=name($Obs)][@*[name()=$GroupDim]=$DimValue]"/>
                                                                                          <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                                                                     </xsl:when>
                                                                                </xsl:choose>
                                                                           </xsl:otherwise>
                                                                      </xsl:choose>
                                                                 </xsl:for-each>
                                                                 <!-- Check each Attribute for the Group-->
                                                                 <xsl:for-each select="$GroupAtts">
                                                                      <xsl:variable name="GroupAtt" select="."/>
                                                                      <!-- Get Attribute value for the Observation -->
                                                                      <xsl:variable name="AttValue" select="$Obs/ancestor-or-self::*/@*[name()=$GroupAtt]"/>
                                                                      <!-- Check that no other Observation has the same value for the Attribute -->
                                                                      <!-- If another Observation has the same value, the variable will have content -->
                                                                      <xsl:choose>
                                                                           <xsl:when test="$GroupAtt/../@crossSectionalAttachGroup='true'">
                                                                                <xsl:variable name="PriorAttValue" select="$Group/preceding::*[local-name()='Group'][@*[name()=$GroupAtt]=$AttValue]"/>
                                                                                <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                           </xsl:when>
                                                                           <xsl:when test="$GroupAtt/../@crossSectionalAttachSeries='true'">
                                                                                <xsl:variable name="PriorAttValue" select="$Section/preceding::*[local-name()='Section'][@*[name()=$GroupAtt]=$AttValue]"/>
                                                                                <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                           </xsl:when>
                                                                           <xsl:when test="$GroupAtt/../@crossSectionalAttachObservation='true'">
                                                                                <xsl:variable name="PriorAttValue" select="$Obs/preceding::*[name()=name($Obs)][@*[name()=$GroupAtt]=$AttValue]"/>
                                                                                <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                           </xsl:when>
                                                                      </xsl:choose>
                                                                 </xsl:for-each>
                                                            </xsl:variable>
                                                            <!-- If the UniqueGroup variable is not empty, then the observation belongs to a new Group -->
                                                            <xsl:if test="$UniqueGroup!=''">
                                                                 <!-- GroupKey variable for defining a Group -->
                                                                 <xsl:variable name="GroupKey">
                                                                      <xsl:for-each select="$GroupDims">
                                                                           <xsl:variable name="GroupDim" select="."/>
                                                                           <xsl:choose>
                                                                                <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$GroupDim]/@isMeasureDimension='true'">
                                                                                     <xsl:value-of select="local-name($Obs)"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                     <xsl:variable name="DimValue" select="$Obs/ancestor-or-self::*/@*[name()=$GroupDim]"/>
                                                                                     <xsl:value-of select="$GroupDim"/>=<xsl:value-of select="$DimValue"/>
                                                                                </xsl:otherwise>
                                                                           </xsl:choose>
                                                                      </xsl:for-each>
                                                                      <xsl:for-each select="$GroupAtts">
                                                                           <xsl:variable name="GroupAtt" select="."/>
                                                                           <xsl:variable name="AttValue" select="$Obs/ancestor-or-self::*/@*[name()=$GroupAtt]"/>
                                                                           <xsl:value-of select="$GroupAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                      </xsl:for-each>
                                                                 </xsl:variable>
                                                                 <!-- Create Group -->
                                                                 <xsl:element name="generic:Group">
                                                                      <xsl:attribute name="type"><xsl:value-of select="$GroupID"/></xsl:attribute>
                                                                      <!-- Create Group Key -->
                                                                      <xsl:element name="generic:GroupKey">
                                                                           <xsl:for-each select="$GroupDims">
                                                                                <xsl:element name="generic:Value">
                                                                                     <xsl:variable name="GroupDim" select="."/>
                                                                                     <xsl:choose>
                                                                                          <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$GroupDim]/@isMeasureDimension='true'">
                                                                                               <xsl:variable name="XSM" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/*[self::structure:CrossSectionalMeasure or self::structure:PrimaryMeasure][@conceptRef=local-name($Obs)]"/>
                                                                                               <xsl:attribute name="concept"><xsl:value-of select="$XSM/@measureDimension"/></xsl:attribute>
                                                                                               <xsl:attribute name="value"><xsl:value-of select="$XSM/@code"/></xsl:attribute>
                                                                                          </xsl:when>
                                                                                          <xsl:otherwise>
                                                                                               <xsl:attribute name="concept"><xsl:value-of select="$GroupDim"/></xsl:attribute>
                                                                                               <xsl:attribute name="value"><xsl:value-of select="$Obs/ancestor-or-self::*/@*[name()=$GroupDim]"/></xsl:attribute>
                                                                                          </xsl:otherwise>
                                                                                     </xsl:choose>
                                                                                </xsl:element>
                                                                                <!-- End Value -->
                                                                           </xsl:for-each>
                                                                      </xsl:element>
                                                                      <!-- End Group Key -->
                                                                      <!-- Create Group Attriubtes -->
                                                                      <xsl:if test="$Obs/ancestor-or-self::*/@*[name()=$GroupAtts]">
                                                                           <xsl:element name="generic:Attributes">
                                                                                <xsl:for-each select="$GroupAtts">
                                                                                     <xsl:variable name="GroupAtt" select="."/>
                                                                                     <xsl:if test="$Obs/ancestor-or-self::*/@*[name()=$GroupAtt]">
                                                                                          <xsl:element name="generic:Value">
                                                                                               <xsl:attribute name="concept"><xsl:value-of select="$GroupAtt"/></xsl:attribute>
                                                                                               <xsl:attribute name="value"><xsl:value-of select="$Obs/ancestor-or-self::*/@*[name()=$GroupAtt]"/></xsl:attribute>
                                                                                          </xsl:element>
                                                                                          <!-- End Value -->
                                                                                     </xsl:if>
                                                                                </xsl:for-each>
                                                                           </xsl:element>
                                                                           <!-- End Group Attributes -->
                                                                      </xsl:if>
                                                                      <xsl:variable name="GroupObservations" select="$Observations[position()>=$Pos]"/>
                                                                      <xsl:for-each select="$GroupObservations">
                                                                           <xsl:variable name="GroupPos" select="position()"/>
                                                                           <xsl:variable name="MGObs" select="."/>
                                                                           <!-- GroupKeyTest variable for matching to a Group -->
                                                                           <xsl:variable name="GroupKeyTest">
                                                                                <xsl:for-each select="$GroupDims">
                                                                                     <xsl:variable name="GroupDim" select="."/>
                                                                                     <xsl:choose>
                                                                                          <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$GroupDim]/@isMeasureDimension='true'">
                                                                                               <xsl:value-of select="local-name($MGObs)"/>
                                                                                          </xsl:when>
                                                                                          <xsl:otherwise>
                                                                                               <xsl:variable name="DimValue" select="$MGObs/ancestor-or-self::*/@*[name()=$GroupDim]"/>
                                                                                               <xsl:value-of select="$GroupDim"/>=<xsl:value-of select="$DimValue"/>
                                                                                          </xsl:otherwise>
                                                                                     </xsl:choose>
                                                                                </xsl:for-each>
                                                                                <xsl:for-each select="$GroupAtts">
                                                                                     <xsl:variable name="GroupAtt" select="."/>
                                                                                     <xsl:variable name="AttValue" select="$MGObs/ancestor-or-self::*/@*[name()=$GroupAtt]"/>
                                                                                     <xsl:value-of select="$GroupAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                                </xsl:for-each>
                                                                           </xsl:variable>
                                                                           <!-- Check that the current Observations belongs to the Group -->
                                                                           <xsl:if test="$GroupKey=$GroupKeyTest">
                                                                                <!-- Loop through each Obersvation to group Series -->
                                                                                <xsl:for-each select="$GroupObservations[position()>=$GroupPos]">
                                                                                     <xsl:variable name="SObs" select="."/>
                                                                                     <xsl:variable name="SSection" select="ancestor::*[local-name()='Section']"/>
                                                                                     <xsl:variable name="SGroup" select="ancestor::*[local-name()='Group']"/>
                                                                                     <xsl:variable name="GroupKeyTest2">
                                                                                          <xsl:for-each select="$GroupDims">
                                                                                               <xsl:variable name="GroupDim" select="."/>
                                                                                               <xsl:choose>
                                                                                                    <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$GroupDim]/@isMeasureDimension='true'">
                                                                                                         <xsl:value-of select="local-name($SObs)"/>
                                                                                                    </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                         <xsl:variable name="DimValue" select="$SObs/ancestor-or-self::*/@*[name()=$GroupDim]"/>
                                                                                                         <xsl:value-of select="$GroupDim"/>=<xsl:value-of select="$DimValue"/>
                                                                                                    </xsl:otherwise>
                                                                                               </xsl:choose>
                                                                                          </xsl:for-each>
                                                                                          <xsl:for-each select="$GroupAtts">
                                                                                               <xsl:variable name="GroupAtt" select="."/>
                                                                                               <xsl:variable name="AttValue" select="$SObs/ancestor-or-self::*/@*[name()=$GroupAtt]"/>
                                                                                               <xsl:value-of select="$GroupAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                                          </xsl:for-each>
                                                                                     </xsl:variable>
                                                                                     <!-- First Check that the Observation belongs to the current Group-->
                                                                                     <xsl:if test="$GroupKey = $GroupKeyTest2">
                                                                                          <xsl:variable name="UniqueSeries">
                                                                                               <!-- Check each Dimension for the Series -->
                                                                                               <xsl:for-each select="$SeriesDims">
                                                                                                    <xsl:variable name="SeriesDim" select="."/>
                                                                                                    <xsl:choose>
                                                                                                         <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@isMeasureDimension='true'">
                                                                                                              <xsl:if test="not($SObs/preceding::*[local-name()=local-name($SObs)])">X</xsl:if>
                                                                                                         </xsl:when>
                                                                                                         <xsl:otherwise>
                                                                                                              <xsl:variable name="DimValue" select="$SObs/ancestor-or-self::*/@*[name()=$SeriesDim]"/>
                                                                                                              <xsl:choose>
                                                                                                                   <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@crossSectionalAttachGroup='true'">
                                                                                                                        <xsl:variable name="PriorDimValue" select="$SGroup/preceding::*[local-name()='Group'][@*[name()=$SeriesDim]=$DimValue]"/>
                                                                                                                        <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                                                                                                   </xsl:when>
                                                                                                                   <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@isFrequencyDimension='true'">
                                                                                                                        <xsl:variable name="PriorDimValue" select="$SGroup/preceding::*[local-name()='Group'][@*[name()=$SeriesDim]=$DimValue]"/>
                                                                                                                        <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                                                                                                   </xsl:when>
                                                                                                                   <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@crossSectionalAttachSection='true'">
                                                                                                                        <xsl:variable name="PriorDimValue" select="$SSection/preceding::*[local-name()='Section'][@*[name()=$SeriesDim]=$DimValue]"/>
                                                                                                                        <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                                                                                                   </xsl:when>
                                                                                                                   <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@crossSectionalAttachObservation='true'">
                                                                                                                        <xsl:variable name="PriorDimValue" select="$SObs/preceding::*[name()=name($SObs)][@*[name()=$SeriesDim]=$DimValue]"/>
                                                                                                                        <xsl:if test="not($PriorDimValue)">X<xsl:value-of select="$SeriesDim"/>
                                                                                                                        </xsl:if>
                                                                                                                   </xsl:when>
                                                                                                              </xsl:choose>
                                                                                                         </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                               </xsl:for-each>
                                                                                               <!-- Check each Attribute for the Series -->
                                                                                               <xsl:for-each select="$SeriesAtts">
                                                                                                    <xsl:variable name="SeriesAtt" select="."/>
                                                                                                    <!-- Get Attribute value for the Observation -->
                                                                                                    <xsl:variable name="AttValue" select="$SObs/ancestor-or-self::*/@*[name()=$SeriesAtt]"/>
                                                                                                    <!-- Check that no other Observation has the same value for the Attribute -->
                                                                                                    <!-- If another Observation has the same value, the variable will have content -->
                                                                                                    <xsl:choose>
                                                                                                         <xsl:when test="$SeriesAtt/../@crossSectionalAttachGroup='true'">
                                                                                                              <xsl:variable name="PriorAttValue" select="$SGroup/preceding::*[local-name()='Group'][@*[name()=$SeriesAtt]=$AttValue]"/>
                                                                                                              <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                                                         </xsl:when>
                                                                                                         <xsl:when test="$SeriesAtt/../@crossSectionalAttachSeries='true'">
                                                                                                              <xsl:variable name="PriorAttValue" select="$SSection/preceding::*[local-name()='Section'][@*[name()=$SeriesAtt]=$AttValue]"/>
                                                                                                              <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                                                         </xsl:when>
                                                                                                         <xsl:when test="$SeriesAtt/../@crossSectionalAttachObservation='true'">
                                                                                                              <xsl:variable name="PriorAttValue" select="$SObs/preceding::*[name()=name($SObs)][@*[name()=$SeriesAtt]=$AttValue]"/>
                                                                                                              <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                                                         </xsl:when>
                                                                                                    </xsl:choose>
                                                                                               </xsl:for-each>
                                                                                          </xsl:variable>
                                                                                          <!-- If the UniqueSeries variable is not empty, then the Observation belongs to a new Series -->
                                                                                          <xsl:if test="$UniqueSeries!=''">
                                                                                               <!-- SeriesKey variable for defining a Series -->
                                                                                               <xsl:variable name="SeriesKey">
                                                                                                    <xsl:for-each select="$SeriesDims">
                                                                                                         <xsl:variable name="SeriesDim" select="."/>
                                                                                                         <xsl:choose>
                                                                                                              <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@isMeasureDimension='true'">
                                                                                                                   <xsl:value-of select="local-name($SObs)"/>
                                                                                                              </xsl:when>
                                                                                                              <xsl:otherwise>
                                                                                                                   <xsl:variable name="DimValue" select="$SObs/ancestor-or-self::*/@*[name()=$SeriesDim]"/>
                                                                                                                   <xsl:value-of select="$SeriesDim"/>=<xsl:value-of select="$DimValue"/>
                                                                                                              </xsl:otherwise>
                                                                                                         </xsl:choose>
                                                                                                    </xsl:for-each>
                                                                                                    <xsl:for-each select="$SeriesAtts">
                                                                                                         <xsl:variable name="SeriesAtt" select="."/>
                                                                                                         <xsl:variable name="AttValue" select="$SObs/ancestor-or-self::*/@*[name()=$SeriesAtt]"/>
                                                                                                         <xsl:value-of select="$SeriesAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                                                    </xsl:for-each>
                                                                                               </xsl:variable>
                                                                                               <!-- Create Series Element -->
                                                                                               <xsl:element name="generic:Series">
                                                                                                    <!-- Create Series Key -->
                                                                                                    <xsl:element name="generic:SeriesKey">
                                                                                                         <xsl:for-each select="$SeriesDims">
                                                                                                              <xsl:element name="generic:Value">
                                                                                                                   <xsl:variable name="SeriesDim" select="."/>
                                                                                                                   <xsl:choose>
                                                                                                                        <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@isMeasureDimension='true'">
                                                                                                                             <xsl:variable name="XSM" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/*[self::structure:CrossSectionalMeasure or self::structure:PrimaryMeasure][@conceptRef=local-name($SObs)]"/>
                                                                                                                             <xsl:attribute name="concept"><xsl:value-of select="$XSM/@measureDimension"/></xsl:attribute>
                                                                                                                             <xsl:attribute name="value"><xsl:value-of select="$XSM/@code"/></xsl:attribute>
                                                                                                                        </xsl:when>
                                                                                                                        <xsl:otherwise>
                                                                                                                             <xsl:attribute name="concept"><xsl:value-of select="$SeriesDim"/></xsl:attribute>
                                                                                                                             <xsl:attribute name="value"><xsl:value-of select="$SObs/ancestor-or-self::*/@*[name()=$SeriesDim]"/></xsl:attribute>
                                                                                                                        </xsl:otherwise>
                                                                                                                   </xsl:choose>
                                                                                                              </xsl:element>
                                                                                                              <!-- End Value -->
                                                                                                         </xsl:for-each>
                                                                                                    </xsl:element>
                                                                                                    <!-- End Series Key -->
                                                                                                    <!-- Create Series Attriubtes -->
                                                                                                    <xsl:if test="$SObs/ancestor-or-self::*/@*[name()=$SeriesAtts]">
                                                                                                         <xsl:element name="generic:Attributes">
                                                                                                              <xsl:for-each select="$SeriesAtts">
                                                                                                                   <xsl:variable name="SeriesAtt" select="."/>
                                                                                                                   <xsl:if test="$SObs/ancestor-or-self::*/@*[name()=$SeriesAtt]">
                                                                                                                        <xsl:element name="generic:Value">
                                                                                                                             <xsl:attribute name="concept"><xsl:value-of select="$SeriesAtt"/></xsl:attribute>
                                                                                                                             <xsl:attribute name="value"><xsl:value-of select="$SObs/ancestor-or-self::*/@*[name()=$SeriesAtt]"/></xsl:attribute>
                                                                                                                        </xsl:element>
                                                                                                                        <!-- End Value -->
                                                                                                                   </xsl:if>
                                                                                                              </xsl:for-each>
                                                                                                         </xsl:element>
                                                                                                         <!-- End Series Attributes -->
                                                                                                    </xsl:if>
                                                                                                    <!-- Loop through subsequent observations to see if they belong to the Series -->
                                                                                                    <xsl:for-each select="$GroupObservations[position()>=$GroupPos]">
                                                                                                         <xsl:sort select="ancestor-or-self::*/@*[name()=$TimeDim]"/>
                                                                                                         <xsl:variable name="MSObs" select="."/>
                                                                                                         <xsl:variable name="SeriesKeyTest">
                                                                                                              <xsl:for-each select="$SeriesDims">
                                                                                                                   <xsl:variable name="SeriesDim" select="."/>
                                                                                                                   <xsl:choose>
                                                                                                                        <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@isMeasureDimension='true'">
                                                                                                                             <xsl:value-of select="local-name($MSObs)"/>
                                                                                                                        </xsl:when>
                                                                                                                        <xsl:otherwise>
                                                                                                                             <xsl:variable name="DimValue" select="$MSObs/ancestor-or-self::*/@*[name()=$SeriesDim]"/>
                                                                                                                             <xsl:value-of select="$SeriesDim"/>=<xsl:value-of select="$DimValue"/>
                                                                                                                        </xsl:otherwise>
                                                                                                                   </xsl:choose>
                                                                                                              </xsl:for-each>
                                                                                                              <xsl:for-each select="$SeriesAtts">
                                                                                                                   <xsl:variable name="SeriesAtt" select="."/>
                                                                                                                   <xsl:variable name="AttValue" select="$MSObs/ancestor-or-self::*/@*[name()=$SeriesAtt]"/>
                                                                                                                   <xsl:value-of select="$SeriesAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                                                              </xsl:for-each>
                                                                                                         </xsl:variable>
                                                                                                         <xsl:variable name="GroupKeyTest3">
                                                                                                              <xsl:for-each select="$GroupDims">
                                                                                                                   <xsl:variable name="GroupDim" select="."/>
                                                                                                                   <xsl:choose>
                                                                                                                        <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$GroupDim]/@isMeasureDimension='true'">
                                                                                                                             <xsl:value-of select="local-name($MSObs)"/>
                                                                                                                        </xsl:when>
                                                                                                                        <xsl:otherwise>
                                                                                                                             <xsl:variable name="DimValue" select="$MSObs/ancestor-or-self::*/@*[name()=$GroupDim]"/>
                                                                                                                             <xsl:value-of select="$GroupDim"/>=<xsl:value-of select="$DimValue"/>
                                                                                                                        </xsl:otherwise>
                                                                                                                   </xsl:choose>
                                                                                                              </xsl:for-each>
                                                                                                              <xsl:for-each select="$GroupAtts">
                                                                                                                   <xsl:variable name="GroupAtt" select="."/>
                                                                                                                   <xsl:variable name="AttValue" select="$MSObs/ancestor-or-self::*/@*[name()=$GroupAtt]"/>
                                                                                                                   <xsl:value-of select="$GroupAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                                                              </xsl:for-each>
                                                                                                         </xsl:variable>
                                                                                                         <xsl:if test="(($SeriesKey = $SeriesKeyTest) and ($GroupKey = $GroupKeyTest3))">
                                                                                                              <xsl:if test="$MSObs/ancestor-or-self::*/@*[name()=$TimeDim]">
                                                                                                                   <!-- Create Observation Element -->
                                                                                                                   <xsl:element name="generic:Obs">
                                                                                                                        <!-- Create Time Element -->
                                                                                                                        <xsl:element name="generic:Time">
                                                                                                                             <xsl:value-of select="ancestor-or-self::*/@*[name()=$TimeDim]"/>
                                                                                                                        </xsl:element>
                                                                                                                        <xsl:if test="$MSObs/@value">
                                                                                                                             <!-- Create ObsValue Element -->
                                                                                                                             <xsl:element name="generic:ObsValue">
                                                                                                                                  <xsl:attribute name="value"><xsl:value-of select="$MSObs/@value"/></xsl:attribute>
                                                                                                                             </xsl:element>
                                                                                                                             <!-- End ObsValue Element -->
                                                                                                                        </xsl:if>
                                                                                                                        <!-- Create Observation Attriubtes -->
                                                                                                                        <xsl:if test="$MSObs/ancestor-or-self::*/@*[name()=$ObsAtts]">
                                                                                                                             <xsl:element name="generic:Attributes">
                                                                                                                                  <xsl:for-each select="$ObsAtts">
                                                                                                                                       <xsl:variable name="ObsAtt" select="."/>
                                                                                                                                       <xsl:if test="$MSObs/ancestor-or-self::*/@*[name()=$ObsAtt]">
                                                                                                                                            <xsl:element name="generic:Value">
                                                                                                                                                 <xsl:attribute name="concept"><xsl:value-of select="$ObsAtt"/></xsl:attribute>
                                                                                                                                                 <xsl:attribute name="value"><xsl:value-of select="$MSObs/ancestor-or-self::*/@*[name()=$ObsAtt]"/></xsl:attribute>
                                                                                                                                            </xsl:element>
                                                                                                                                            <!-- End Value -->
                                                                                                                                       </xsl:if>
                                                                                                                                  </xsl:for-each>
                                                                                                                             </xsl:element>
                                                                                                                             <!-- End Observation Attributes -->
                                                                                                                        </xsl:if>
                                                                                                                   </xsl:element>
                                                                                                                   <!-- End Observation Element -->
                                                                                                              </xsl:if>
                                                                                                         </xsl:if>
                                                                                                    </xsl:for-each>
                                                                                               </xsl:element>
                                                                                               <!-- End Series Element -->
                                                                                          </xsl:if>
                                                                                     </xsl:if>
                                                                                </xsl:for-each>
                                                                           </xsl:if>
                                                                      </xsl:for-each>
                                                                 </xsl:element>
                                                                 <!-- End Group Element -->
                                                            </xsl:if>
                                                       </xsl:for-each>
                                                  </xsl:when>
                                                  <!-- If Group was not found, create Series only data -->
                                                  <xsl:otherwise>
                                                       <xsl:variable name="Observations" select="$DataSet/*[local-name()='Group']/*[local-name()='Section']/*[local-name()=$XSMeas]"/>
                                                       <xsl:for-each select="$Observations">
                                                            <xsl:variable name="Obs" select="."/>
                                                            <xsl:variable name="Section" select="ancestor::*[local-name()='Section']"/>
                                                            <xsl:variable name="Group" select="ancestor::*[local-name()='Group']"/>
                                                            <xsl:variable name="Pos" select="position()"/>
                                                            <xsl:variable name="Measure" select="local-name()"/>
                                                            <xsl:variable name="UniqueSeries">
                                                                 <!-- Check each Dimension for the Series -->
                                                                 <xsl:for-each select="$SeriesDims">
                                                                      <xsl:variable name="SeriesDim" select="."/>
                                                                      <xsl:choose>
                                                                           <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@isMeasureDimension='true'">
                                                                                <xsl:if test="not($Obs/preceding::*[local-name()=local-name($Obs)])">X</xsl:if>
                                                                           </xsl:when>
                                                                           <xsl:otherwise>
                                                                                <xsl:variable name="DimValue" select="$Obs/ancestor-or-self::*/@*[name()=$SeriesDim]"/>
                                                                                <xsl:choose>
                                                                                     <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@crossSectionalAttachGroup='true'">
                                                                                          <xsl:variable name="PriorDimValue" select="$Group/preceding::*[local-name()='Group'][@*[name()=$SeriesDim]=$DimValue]"/>
                                                                                          <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                                                                     </xsl:when>
                                                                                     <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@isFrequencyDimension='true'">
                                                                                          <xsl:variable name="PriorDimValue" select="$Group/preceding::*[local-name()='Group'][@*[name()=$SeriesDim]=$DimValue]"/>
                                                                                          <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                                                                     </xsl:when>                                                                                     
                                                                                     <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@crossSectionalAttachSection='true'">
                                                                                          <xsl:variable name="PriorDimValue" select="$Section/preceding::*[local-name()='Section'][@*[name()=$SeriesDim]=$DimValue]"/>
                                                                                          <xsl:if test="not($PriorDimValue)">X</xsl:if>
                                                                                     </xsl:when>
                                                                                     <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@crossSectionalAttachObservation='true'">
                                                                                          <xsl:variable name="PriorDimValue" select="$Obs/preceding::*[name()=name($Obs)][@*[name()=$SeriesDim]=$DimValue]"/>
                                                                                          <xsl:if test="not($PriorDimValue)">X<xsl:value-of select="$SeriesDim"/>
                                                                                          </xsl:if>
                                                                                     </xsl:when>
                                                                                </xsl:choose>
                                                                           </xsl:otherwise>
                                                                      </xsl:choose>
                                                                 </xsl:for-each>
                                                                 <!-- Check each Attribute for the Series -->
                                                                 <xsl:for-each select="$SeriesAtts">
                                                                      <xsl:variable name="SeriesAtt" select="."/>
                                                                      <!-- Get Attribute value for the Observation -->
                                                                      <xsl:variable name="AttValue" select="$Obs/ancestor-or-self::*/@*[name()=$SeriesAtt]"/>
                                                                      <!-- Check that no other Observation has the same value for the Attribute -->
                                                                      <!-- If another Observation has the same value, the variable will have content -->
                                                                      <xsl:choose>
                                                                           <xsl:when test="$SeriesAtt/../@crossSectionalAttachGroup='true'">
                                                                                <xsl:variable name="PriorAttValue" select="$Group/preceding::*[local-name()='Group'][@*[name()=$SeriesAtt]=$AttValue]"/>
                                                                                <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                           </xsl:when>
                                                                           <xsl:when test="$SeriesAtt/../@crossSectionalAttachSeries='true'">
                                                                                <xsl:variable name="PriorAttValue" select="$Section/preceding::*[local-name()='Section'][@*[name()=$SeriesAtt]=$AttValue]"/>
                                                                                <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                           </xsl:when>
                                                                           <xsl:when test="$SeriesAtt/../@crossSectionalAttachObservation='true'">
                                                                                <xsl:variable name="PriorAttValue" select="$Obs/preceding::*[name()=name($Obs)][@*[name()=$SeriesAtt]=$AttValue]"/>
                                                                                <xsl:if test="not($PriorAttValue)">X</xsl:if>
                                                                           </xsl:when>
                                                                      </xsl:choose>
                                                                 </xsl:for-each>
                                                            </xsl:variable>
                                                            <xsl:if test="$UniqueSeries!=''">
                                                                 <!-- SeriesKey variable for defining a Series -->
                                                                 <xsl:variable name="SeriesKey">
                                                                      <xsl:for-each select="$SeriesDims">
                                                                           <xsl:variable name="SeriesDim" select="."/>
                                                                           <xsl:choose>
                                                                                <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@isMeasureDimension='true'">
                                                                                     <xsl:value-of select="local-name($Obs)"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                     <xsl:variable name="DimValue" select="$Obs/ancestor-or-self::*/@*[name()=$SeriesDim]"/>
                                                                                     <xsl:value-of select="$SeriesDim"/>=<xsl:value-of select="$DimValue"/>
                                                                                </xsl:otherwise>
                                                                           </xsl:choose>
                                                                      </xsl:for-each>
                                                                      <xsl:for-each select="$SeriesAtts">
                                                                           <xsl:variable name="SeriesAtt" select="."/>
                                                                           <xsl:variable name="AttValue" select="$Obs/ancestor-or-self::*/@*[name()=$SeriesAtt]"/>
                                                                           <xsl:value-of select="$SeriesAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                      </xsl:for-each>
                                                                 </xsl:variable>
                                                                 <!-- Create Series Element -->
                                                                 <xsl:element name="generic:Series">
                                                                      <!-- Create Series Key -->
                                                                      <xsl:element name="generic:SeriesKey">
                                                                           <xsl:for-each select="$SeriesDims">
                                                                                <xsl:element name="generic:Value">
                                                                                     <xsl:variable name="SeriesDim" select="."/>
                                                                                     <xsl:choose>
                                                                                          <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@isMeasureDimension='true'">
                                                                                               <xsl:variable name="XSM" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/*[self::structure:CrossSectionalMeasure or self::structure:PrimaryMeasure][@conceptRef=local-name($Obs)]"/>
                                                                                               <xsl:attribute name="concept"><xsl:value-of select="$XSM/@measureDimension"/></xsl:attribute>
                                                                                               <xsl:attribute name="value"><xsl:value-of select="$XSM/@code"/></xsl:attribute>
                                                                                          </xsl:when>
                                                                                          <xsl:otherwise>
                                                                                               <xsl:attribute name="concept"><xsl:value-of select="$SeriesDim"/></xsl:attribute>
                                                                                               <xsl:attribute name="value"><xsl:value-of select="$Obs/ancestor-or-self::*/@*[name()=$SeriesDim]"/></xsl:attribute>
                                                                                          </xsl:otherwise>
                                                                                     </xsl:choose>
                                                                                </xsl:element>
                                                                                <!-- End Value -->
                                                                           </xsl:for-each>
                                                                      </xsl:element>
                                                                      <!-- End Series Key -->
                                                                      <!-- Create Series Attriubtes -->
                                                                      <xsl:if test="$Obs/ancestor-or-self::*/@*[name()=$SeriesAtts]">
                                                                           <xsl:element name="generic:Attributes">
                                                                                <xsl:for-each select="$SeriesAtts">
                                                                                     <xsl:variable name="SeriesAtt" select="."/>
                                                                                     <xsl:if test="$Obs/ancestor-or-self::*/@*[name()=$SeriesAtt]">
                                                                                          <xsl:element name="generic:Value">
                                                                                               <xsl:attribute name="concept"><xsl:value-of select="$SeriesAtt"/></xsl:attribute>
                                                                                               <xsl:attribute name="value"><xsl:value-of select="$Obs/ancestor-or-self::*/@*[name()=$SeriesAtt]"/></xsl:attribute>
                                                                                          </xsl:element>
                                                                                          <!-- End Value -->
                                                                                     </xsl:if>
                                                                                </xsl:for-each>
                                                                           </xsl:element>
                                                                           <!-- End Series Attributes -->
                                                                      </xsl:if>
                                                                      <!-- Loop through subsequent observations to see if they belong to the Series -->
                                                                      <xsl:for-each select="$Observations[position()>=$Pos]">
                                                                           <xsl:sort select="ancestor-or-self::*/@*[name()=$TimeDim]"/>
                                                                           <xsl:variable name="MSObs" select="."/>
                                                                           <xsl:variable name="SeriesKeyTest">
                                                                                <xsl:for-each select="$SeriesDims">
                                                                                     <xsl:variable name="SeriesDim" select="."/>
                                                                                     <xsl:choose>
                                                                                          <xsl:when test="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@conceptRef=$SeriesDim]/@isMeasureDimension='true'">
                                                                                               <xsl:value-of select="local-name($MSObs)"/>
                                                                                          </xsl:when>
                                                                                          <xsl:otherwise>
                                                                                               <xsl:variable name="DimValue" select="$MSObs/ancestor-or-self::*/@*[name()=$SeriesDim]"/>
                                                                                               <xsl:value-of select="$SeriesDim"/>=<xsl:value-of select="$DimValue"/>
                                                                                          </xsl:otherwise>
                                                                                     </xsl:choose>
                                                                                </xsl:for-each>
                                                                                <xsl:for-each select="$SeriesAtts">
                                                                                     <xsl:variable name="SeriesAtt" select="."/>
                                                                                     <xsl:variable name="AttValue" select="$MSObs/ancestor-or-self::*/@*[name()=$SeriesAtt]"/>
                                                                                     <xsl:value-of select="$SeriesAtt"/>=<xsl:value-of select="$AttValue"/>
                                                                                </xsl:for-each>
                                                                           </xsl:variable>
                                                                           <xsl:if test="$SeriesKey=$SeriesKeyTest">
                                                                                <xsl:if test="$MSObs/ancestor-or-self::*/@*[name()=$TimeDim]">
                                                                                     <!-- Create Observation Element -->
                                                                                     <xsl:element name="generic:Obs">
                                                                                          <!-- Create Time Element -->
                                                                                          <xsl:element name="generic:Time">
                                                                                               <xsl:value-of select="ancestor-or-self::*/@*[name()=$TimeDim]"/>
                                                                                          </xsl:element>
                                                                                          <xsl:if test="$MSObs/@value">
                                                                                               <!-- Create ObsValue Element -->
                                                                                               <xsl:element name="generic:ObsValue">
                                                                                                    <xsl:attribute name="value"><xsl:value-of select="$MSObs/@value"/></xsl:attribute>
                                                                                               </xsl:element>
                                                                                               <!-- End ObsValue element -->
                                                                                          </xsl:if>
                                                                                          <!-- Create Observation Attriubtes -->
                                                                                          <xsl:if test="$MSObs/ancestor-or-self::*/@*[name()=$ObsAtts]">
                                                                                               <xsl:element name="generic:Attributes">
                                                                                                    <xsl:for-each select="$ObsAtts">
                                                                                                         <xsl:variable name="ObsAtt" select="."/>
                                                                                                         <xsl:if test="$MSObs/ancestor-or-self::*/@*[name()=$ObsAtt]">
                                                                                                              <xsl:element name="generic:Value">
                                                                                                                   <xsl:attribute name="concept"><xsl:value-of select="$ObsAtt"/></xsl:attribute>
                                                                                                                   <xsl:attribute name="value"><xsl:value-of select="$MSObs/ancestor-or-self::*/@*[name()=$ObsAtt]"/></xsl:attribute>
                                                                                                              </xsl:element>
                                                                                                              <!-- End Value -->
                                                                                                         </xsl:if>
                                                                                                    </xsl:for-each>
                                                                                               </xsl:element>
                                                                                               <!-- End Observation Attributes -->
                                                                                          </xsl:if>
                                                                                     </xsl:element>
                                                                                     <!-- End Observation Element -->
                                                                                </xsl:if>
                                                                           </xsl:if>
                                                                      </xsl:for-each>
                                                                 </xsl:element>
                                                                 <!-- End Series Element -->
                                                            </xsl:if>
                                                       </xsl:for-each>
                                                  </xsl:otherwise>
                                             </xsl:choose>
                                        </xsl:element>
                                        <!-- End DataSet -->
                                   </xsl:for-each>
                              </GenericData>
                              <!-- End GenericData -->
                         </xsl:when>
                         <!-- Key Family not found in Key Family instance -->
                         <xsl:otherwise>
                              <xsl:comment>Key Family <xsl:value-of select="$KeyFamID"/> not found in <xsl:value-of select="$KFLoc"/>.</xsl:comment>
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
