<?xml version="1.0"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" 
xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact"  
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:exslt="http://exslt.org/common" 
extension-element-prefixes="exslt"
exclude-result-prefixes="structure message" 
version="1.0">
     <xsl:output method="xml" indent="yes"/>
     <xsl:param name="Namespace">nameSpaceHolder</xsl:param>
     <xsl:param name="CommonURI">SDMXCommon.xsd</xsl:param>
     <xsl:param name="CompactURI">SDMXCompactData.xsd</xsl:param>
	 <xsl:param name="KeyFamID">notPassed</xsl:param>
     <xsl:template match="/">
		<xsl:variable name="KFID">
			<xsl:choose>
				<xsl:when test="$KeyFamID = 'notPassed'">
					<xsl:value-of select="message:Structure/message:KeyFamilies/structure:KeyFamily[1]/@id"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$KeyFamID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
          <xsl:variable name="ns-node">
               <xsl:element name="ns-element" namespace="{$Namespace}"/>
          </xsl:variable>
          <xsl:choose>
               <xsl:when test="not(function-available('exslt:node-set'))">
                    <xsl:choose>
                         <xsl:when test="$Namespace='nameSpaceHolder'">
                              <xsl:comment>
                                   <xsl:text>Namespace was not passed via Namespace parameter.  Default value was set for xmlns and targetNamespace.</xsl:text>
                              </xsl:comment>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:comment>
                                   <xsl:text>xmlns Could not be set.  Please set this to "</xsl:text>
                                   <xsl:value-of select="$Namespace"/>
                                   <xsl:text>" to make XSD valid.</xsl:text>
                              </xsl:comment>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:choose>
                         <xsl:when test="$Namespace='nameSpaceHolder'">
                              <xsl:comment>
                                   <xsl:text>Namespace was not passed via Namespace parameter.  Default value was set for xmlns and targetNamespace.</xsl:text>
                              </xsl:comment>
                         </xsl:when>
                    </xsl:choose>
               </xsl:otherwise>
          </xsl:choose>
          <xs:schema>
               <xsl:if test="function-available('exslt:node-set')">
                    <xsl:copy-of select="exslt:node-set($ns-node)/*/namespace::*[local-name()='']"/>
               </xsl:if>
               <xsl:attribute name="targetNamespace"><xsl:value-of select="$Namespace"/></xsl:attribute>
               <xsl:attribute name="elementFormDefault"><xsl:text>qualified</xsl:text></xsl:attribute>
               <xsl:attribute name="attributeFormDefault"><xsl:text>unqualified</xsl:text></xsl:attribute>
               <xsl:element name="xs:import">
                    <xsl:attribute name="namespace"><xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact</xsl:text></xsl:attribute>
                    <xsl:attribute name="schemaLocation"><xsl:value-of select="$CompactURI"/></xsl:attribute>
               </xsl:element>
               <xsl:element name="xs:import">
                    <xsl:attribute name="namespace"><xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common</xsl:text></xsl:attribute>
                    <xsl:attribute name="schemaLocation"><xsl:value-of select="$CommonURI"/></xsl:attribute>
               </xsl:element>
               <xsl:element name="xs:element">
                    <xsl:attribute name="name"><xsl:text>DataSet</xsl:text></xsl:attribute>
                    <xsl:attribute name="type"><xsl:text>DataSetType</xsl:text></xsl:attribute>
                    <xsl:attribute name="substitutionGroup"><xsl:text>compact:DataSet</xsl:text></xsl:attribute>
               </xsl:element>
               <!-- Data Set Complex Type-->
               <xsl:element name="xs:complexType">
                    <xsl:attribute name="name"><xsl:text>DataSetType</xsl:text></xsl:attribute>
                    <xsl:element name="xs:complexContent">
                         <xsl:element name="xs:extension">
                              <xsl:attribute name="base"><xsl:text>compact:DataSetType</xsl:text></xsl:attribute>
                              <xsl:element name="xs:choice">
                                   <xsl:attribute name="minOccurs"><xsl:text>0</xsl:text></xsl:attribute>
                                   <xsl:attribute name="maxOccurs"><xsl:text>unbounded</xsl:text></xsl:attribute>
                                   <xsl:for-each select="message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Group">
                                        <xsl:element name="xs:element">
                                             <xsl:attribute name="ref"><xsl:value-of select="@id"/></xsl:attribute>
                                        </xsl:element>
                                        <!--Close xs:element (Group)-->
                                   </xsl:for-each>
                                   <xsl:element name="xs:element">
                                        <xsl:attribute name="ref"><xsl:text>Series</xsl:text></xsl:attribute>
                                   </xsl:element>
                                   <!--Close xs:element (Series)-->
                                   <xsl:element name="xs:element">
                                        <xsl:attribute name="name"><xsl:text>Annotations</xsl:text></xsl:attribute>
                                        <xsl:attribute name="type"><xsl:text>common:AnnotationsType</xsl:text></xsl:attribute>
                                   </xsl:element>
                                   <!--Close xs:element (Annotations)-->
                              </xsl:element>
                              <!--Close xs:choice-->
                              <xsl:for-each select="message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='DataSet']">
                                   <xsl:element name="xs:attribute">
                                        <xsl:attribute name="name"><xsl:value-of select="@concept"/></xsl:attribute>
                                        <xsl:attribute name="type">
                                             <xsl:if test="@codelist">
                                                  <xsl:value-of select="@codelist"/>
                                             </xsl:if>
                                             <xsl:if test="not(@codelist)">
                                                  <xsl:value-of select="@concept"/><xsl:text>Type</xsl:text>
                                             </xsl:if>
                                        </xsl:attribute>
                                        <xsl:attribute name="use"><xsl:text>optional</xsl:text></xsl:attribute>
                                   </xsl:element>
                                   <!--Close xs:attribute (of DataSetType)-->
                              </xsl:for-each>
                         </xsl:element>
                         <!--Close xs:extension-->
                    </xsl:element>
                    <!--Close xs:complexContent-->
               </xsl:element>
               <!--Close xs:complexType-->
               <!-- End Data Set Complex Type-->
               <!-- Group Elements -->
               <xsl:for-each select="message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Group">
                    <xsl:element name="xs:element">
                         <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
                         <xsl:attribute name="substitutionGroup"><xsl:text>compact:Group</xsl:text></xsl:attribute>
                         <xsl:attribute name="type"><xsl:value-of select="@id"/><xsl:text>Type</xsl:text></xsl:attribute>
                    </xsl:element>
               </xsl:for-each>
               <!-- End Group Elements -->
               <!-- Group Complex Types -->
               <xsl:for-each select="message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Group">
                    <xsl:element name="xs:complexType">
                         <xsl:attribute name="name"><xsl:value-of select="@id"/><xsl:text>Type</xsl:text></xsl:attribute>
                         <xsl:element name="xs:complexContent">
                              <xsl:element name="xs:extension">
                                   <xsl:attribute name="base"><xsl:text>compact:GroupType</xsl:text></xsl:attribute>
                                   <xsl:element name="xs:sequence">
                                        <xsl:element name="xs:element">
                                             <xsl:attribute name="name"><xsl:text>Annotations</xsl:text></xsl:attribute>
                                             <xsl:attribute name="type"><xsl:text>common:AnnotationsType</xsl:text></xsl:attribute>
                                             <xsl:attribute name="minOccurs"><xsl:text>0</xsl:text></xsl:attribute>
                                        </xsl:element>
                                        <!--Close xs:element (Annotations)-->
                                   </xsl:element>
                                   <!--Close xs:sequence-->
                                   <xsl:for-each select="../structure:Attribute[@attachmentLevel='Group']">
                                        <xsl:if test="structure:AttachmentGroup=../structure:Group/@id">
                                             <xsl:element name="xs:attribute">
                                                  <xsl:attribute name="name"><xsl:value-of select="@concept"/></xsl:attribute>
                                                  <xsl:attribute name="type">
                                                       <xsl:if test="@codelist">
                                                            <xsl:value-of select="@codelist"/>
                                                       </xsl:if>
                                                       <xsl:if test="not(@codelist)">
                                                            <xsl:value-of select="@concept"/><xsl:text>Type</xsl:text>
                                                       </xsl:if>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="use"><xsl:text>optional</xsl:text></xsl:attribute>
                                             </xsl:element>
                                             <!--Close xs:attribute (of <Group>Type)-->
                                        </xsl:if>
                                   </xsl:for-each>
                                   <xsl:for-each select="structure:DimensionRef">
                                        <xsl:element name="xs:attribute">
                                             <xsl:variable name="Concept">
                                                  <xsl:value-of select="."/>
                                             </xsl:variable>
                                             <xsl:attribute name="name"><xsl:value-of select="$Concept"/></xsl:attribute>
                                             <xsl:attribute name="type">
                                                  <xsl:value-of select="/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension[@concept = $Concept]/@codelist"/>
                                             </xsl:attribute>
                                             <xsl:attribute name="use"><xsl:text>required</xsl:text></xsl:attribute>
                                        </xsl:element>
                                        <!--Close xs:attribute (of <Group>Type)-->
                                   </xsl:for-each>
                              </xsl:element>
                              <!--Close xs:extension-->
                         </xsl:element>
                         <!--Close xs:complexContent-->
                    </xsl:element>
                    <!--Close xs:complexType-->
               </xsl:for-each>
               <!-- End Group Complex Types -->
               <!-- Series Element -->
               <xsl:element name="xs:element">
                    <xsl:attribute name="name"><xsl:text>Series</xsl:text></xsl:attribute>
                    <xsl:attribute name="substitutionGroup"><xsl:text>compact:Series</xsl:text></xsl:attribute>
                    <xsl:attribute name="type"><xsl:text>SeriesType</xsl:text></xsl:attribute>
               </xsl:element>
               <!-- End Series Element -->
               <!-- Series Complex Type -->
               <xsl:element name="xs:complexType">
                    <xsl:attribute name="name"><xsl:text>SeriesType</xsl:text></xsl:attribute>
                    <xsl:element name="xs:complexContent">
                         <xsl:element name="xs:extension">
                              <xsl:attribute name="base"><xsl:text>compact:SeriesType</xsl:text></xsl:attribute>
                              <xsl:element name="xs:sequence">
                                   <xsl:element name="xs:element">
                                        <xsl:attribute name="ref"><xsl:text>Obs</xsl:text></xsl:attribute>
                                        <xsl:attribute name="minOccurs"><xsl:text>0</xsl:text></xsl:attribute>
                                        <xsl:attribute name="maxOccurs"><xsl:text>unbounded</xsl:text></xsl:attribute>
                                   </xsl:element>
                                   <!--Close xs:element (Obs)-->
                                   <xsl:element name="xs:element">
                                        <xsl:attribute name="name"><xsl:text>Annotations</xsl:text></xsl:attribute>
                                        <xsl:attribute name="type"><xsl:text>common:AnnotationsType</xsl:text></xsl:attribute>
                                        <xsl:attribute name="minOccurs"><xsl:text>0</xsl:text></xsl:attribute>
                                   </xsl:element>
                                   <!--Close xs:element (Annotations)-->
                              </xsl:element>
                              <!--Close xs:sequence-->
                              <xsl:for-each select="message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='Series']">
                                   <xsl:element name="xs:attribute">
                                        <xsl:attribute name="name"><xsl:value-of select="@concept"/></xsl:attribute>
                                        <xsl:attribute name="type">
                                             <xsl:if test="@codelist">
                                                  <xsl:value-of select="@codelist"/>
                                             </xsl:if>
                                             <xsl:if test="not(@codelist)">
                                                  <xsl:value-of select="@concept"/><xsl:text>Type</xsl:text>
                                             </xsl:if>
                                        </xsl:attribute>
                                        <xsl:attribute name="use">
                                             <xsl:choose>
                                                  <xsl:when test="@isTimeFormat='true'">
                                                       <xsl:text>required</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                       <xsl:text>optional</xsl:text>
                                                  </xsl:otherwise>
                                             </xsl:choose>
                                        </xsl:attribute>
                                   </xsl:element>
                                   <!--Close xs:attribute (of SeriesType)-->
                              </xsl:for-each>
                              <xsl:for-each select="message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension">
                                   <xsl:element name="xs:attribute">
                                        <xsl:attribute name="name"><xsl:value-of select="@concept"/></xsl:attribute>
                                        <xsl:attribute name="type"><xsl:value-of select="@codelist"/></xsl:attribute>
                                        <xsl:attribute name="use"><xsl:text>optional</xsl:text></xsl:attribute>
                                   </xsl:element>
                                   <!--Close xs:attribute (of SeriesType)-->
                              </xsl:for-each>
                         </xsl:element>
                         <!--Close xs:extension-->
                    </xsl:element>
                    <!--Close xs:complexContent-->
               </xsl:element>
               <!--Close xs:complexType-->
               <!-- End Series Complex Types -->
               <!-- Obs Element -->
               <xsl:element name="xs:element">
                    <xsl:attribute name="name"><xsl:text>Obs</xsl:text></xsl:attribute>
                    <xsl:attribute name="substitutionGroup"><xsl:text>compact:Obs</xsl:text></xsl:attribute>
                    <xsl:attribute name="type"><xsl:text>ObsType</xsl:text></xsl:attribute>
               </xsl:element>
               <!-- End Obs Element -->
               <!-- Obs Complex Type -->
               <xsl:element name="xs:complexType">
                    <xsl:attribute name="name"><xsl:text>ObsType</xsl:text></xsl:attribute>
                    <xsl:element name="xs:complexContent">
                         <xsl:element name="xs:extension">
                              <xsl:attribute name="base"><xsl:text>compact:ObsType</xsl:text></xsl:attribute>
                              <xsl:element name="xs:sequence">
                                   <xsl:element name="xs:element">
                                        <xsl:attribute name="name"><xsl:text>Annotations</xsl:text></xsl:attribute>
                                        <xsl:attribute name="type"><xsl:text>common:AnnotationsType</xsl:text></xsl:attribute>
                                        <xsl:attribute name="minOccurs"><xsl:text>0</xsl:text></xsl:attribute>
                                   </xsl:element>
                                   <!--Close xs:element (Annotations)-->
                              </xsl:element>
                              <!--Close xs:sequence-->
                              <xsl:element name="xs:attribute">
                                   <xsl:attribute name="name">
                                        <xsl:value-of select="message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:TimeDimension/@concept"/>
                                   </xsl:attribute>
                                   <xsl:attribute name="type"><xsl:text>common:TimePeriodType</xsl:text></xsl:attribute>
                                   <xsl:attribute name="use"><xsl:text>optional</xsl:text></xsl:attribute>
                              </xsl:element>
                              <!--Close xs:element (Time Dimension)-->
                              <xsl:element name="xs:attribute">
                                   <xsl:attribute name="name">
                                        <xsl:value-of select="message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:PrimaryMeasure/@concept"/>
                                   </xsl:attribute>
                                   <xsl:attribute name="type"><xsl:text>xs:double</xsl:text></xsl:attribute>
                                   <xsl:attribute name="use"><xsl:text>optional</xsl:text></xsl:attribute>
                              </xsl:element>
                              <!--Close xs:element (Measure Dimension)-->
                              <xsl:for-each select="message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='Observation']">
                                   <xsl:element name="xs:attribute">
                                        <xsl:attribute name="name"><xsl:value-of select="@concept"/></xsl:attribute>
                                        <xsl:attribute name="type">
                                             <xsl:if test="@codelist">
                                                  <xsl:value-of select="@codelist"/>
                                             </xsl:if>
                                             <xsl:if test="not(@codelist)">
                                                  <xsl:value-of select="@concept"/><xsl:text>Type</xsl:text>
                                             </xsl:if>
                                        </xsl:attribute>
                                        <xsl:attribute name="use"><xsl:text>optional</xsl:text></xsl:attribute>
                                   </xsl:element>
                                   <!--Close xs:attribute (of ObservationType)-->
                              </xsl:for-each>
                         </xsl:element>
                         <!--Close xs:extension-->
                    </xsl:element>
                    <!--Close xs:complexContent-->
               </xsl:element>
               <!--Close xs:complexType-->
               <!-- End Obs Complex Types -->
               <!-- Non Coded Attributes -->
               <xsl:for-each select="message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[not(@codelist)]">
                    <xsl:choose>
                         <xsl:when test="structure:TextFormat/@TextType='Alpha'">
                              <xsl:element name="xs:simpleType">
                                   <xsl:attribute name="name"><xsl:value-of select="@concept"/><xsl:text>Type</xsl:text></xsl:attribute>
                                   <xsl:element name="xs:restriction">
                                        <xsl:attribute name="base"><xsl:text>common:AlphaType</xsl:text></xsl:attribute>
                                        <xsl:if test="structure:TextFormat/@length">
                                             <xsl:element name="xs:maxLength">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@length"/></xsl:attribute>
                                             </xsl:element>
                                        </xsl:if>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:when test="structure:TextFormat/@TextType='AlphaFixed'">
                              <xsl:element name="xs:simpleType">
                                   <xsl:attribute name="name"><xsl:value-of select="@concept"/><xsl:text>Type</xsl:text></xsl:attribute>
                                   <xsl:element name="xs:restriction">
                                        <xsl:attribute name="base"><xsl:text>common:AlphaType</xsl:text></xsl:attribute>
                                        <xsl:if test="structure:TextFormat/@length">
                                             <xsl:element name="xs:minLength">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@length"/></xsl:attribute>
                                             </xsl:element>
                                             <xsl:element name="xs:maxLength">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@length"/></xsl:attribute>
                                             </xsl:element>
                                        </xsl:if>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:when test="structure:TextFormat/@TextType='Num'">
                              <xsl:element name="xs:simpleType">
                                   <xsl:attribute name="name"><xsl:value-of select="@concept"/><xsl:text>Type</xsl:text></xsl:attribute>
                                   <xsl:element name="xs:restriction">
                                        <xsl:attribute name="base">xs:decimal</xsl:attribute>
                                        <xsl:if test="structure:TextFormat/@length">
                                             <xsl:element name="xs:totalDigits">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@length"/></xsl:attribute>
                                             </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="structure:TextFormat/@decimals">
                                             <xsl:element name="xs:fractionDigits">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@decimals"/></xsl:attribute>
                                             </xsl:element>
                                        </xsl:if>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:when test="structure:TextFormat/@TextType='NumFixed'">
                              <xsl:element name="xs:simpleType">
                                   <xsl:attribute name="name"><xsl:value-of select="@concept"/><xsl:text>Type</xsl:text></xsl:attribute>
                                   <xsl:element name="xs:restriction">
                                        <xsl:attribute name="base">xs:decimal</xsl:attribute>
                                        <xsl:if test="structure:TextFormat/@length">
                                             <xsl:element name="xs:totalDigits">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@length"/></xsl:attribute>
                                                  <xsl:attribute name="fixed"><xsl:text>true</xsl:text></xsl:attribute>
                                             </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="structure:TextFormat/@decimals">
                                             <xsl:element name="xs:fractionDigits">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@decimals"/></xsl:attribute>
                                             </xsl:element>
                                        </xsl:if>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:when test="structure:TextFormat/@TextType='AlphaNum'">
                              <xsl:element name="xs:simpleType">
                                   <xsl:attribute name="name"><xsl:value-of select="@concept"/><xsl:text>Type</xsl:text></xsl:attribute>
                                   <xsl:element name="xs:restriction">
                                        <xsl:attribute name="base"><xsl:text>common:AlphaNumericType</xsl:text></xsl:attribute>
                                        <xsl:if test="structure:TextFormat/@length">
                                             <xsl:element name="xs:maxLength">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@length"/></xsl:attribute>
                                             </xsl:element>
                                        </xsl:if>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:when test="structure:TextFormat/@TextType='AlphaNumFixed'">
                              <xsl:element name="xs:simpleType">
                                   <xsl:attribute name="name"><xsl:value-of select="@concept"/><xsl:text>Type</xsl:text></xsl:attribute>
                                   <xsl:element name="xs:restriction">
                                        <xsl:attribute name="base"><xsl:text>common:AlphaNumericType</xsl:text></xsl:attribute>
                                        <xsl:if test="structure:TextFormat/@length">
                                             <xsl:element name="xs:minLength">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@length"/></xsl:attribute>
                                             </xsl:element>
                                             <xsl:element name="xs:maxLength">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@length"/></xsl:attribute>
                                             </xsl:element>
                                        </xsl:if>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:element name="xs:simpleType">
                                   <xsl:attribute name="name"><xsl:value-of select="@concept"/><xsl:text>Type</xsl:text></xsl:attribute>
                                   <xsl:element name="xs:restriction">
                                        <xsl:attribute name="base"><xsl:text>xs:string</xsl:text></xsl:attribute>
                                        <xsl:if test="structure:TextFormat/@length">
                                             <xsl:element name="xs:maxLength">
                                                  <xsl:attribute name="value"><xsl:value-of select="structure:TextFormat/@length"/></xsl:attribute>
                                             </xsl:element>
                                        </xsl:if>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:for-each>
               <!-- End Non Coded Attributes -->
               <!-- Code Lists -->
               <xsl:for-each select="message:Structure/message:CodeLists/structure:CodeList">
                    <xsl:element name="xs:simpleType">
                         <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
                         <xsl:element name="xs:restriction">
                              <xsl:attribute name="base">xs:string</xsl:attribute>
                              <xsl:for-each select="structure:Code">
                                   <xsl:element name="xs:enumeration">
                                        <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                                        <xsl:element name="xs:annotation">
                                             <xsl:element name="xs:documentation">
                                                  <xsl:for-each select="structure:Description/@*">
                                                       <xsl:copy/>
                                                  </xsl:for-each>
                                                  <xsl:value-of select="structure:Description"/>
                                             </xsl:element>
                                             <!--Close xs:documentation-->
                                        </xsl:element>
                                        <!--Close xs:annotation-->
                                   </xsl:element>
                                   <!--Close xs:enumeration-->
                              </xsl:for-each>
                         </xsl:element>
                         <!--Close xs:restriction-->
                    </xsl:element>
                    <!--Close xs:simpleType-->
               </xsl:for-each>
               <!-- End Code Lists -->
          </xs:schema>
          <!--Close xs:schema-->
     </xsl:template>
</xsl:stylesheet>
