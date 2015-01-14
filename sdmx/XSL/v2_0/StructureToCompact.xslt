<?xml version="1.0"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" 
xmlns:m="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:s="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:exslt="http://exslt.org/common"
extension-element-prefixes="exslt" 
exclude-result-prefixes="s m" 
version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:include href="SchemaUtilities.xslt"/>
	<xsl:include href="ReferenceUtilities.xslt"/>
	
	<!-- Input Parameters -->
	<xsl:param name="Namespace">nameSpaceHolder</xsl:param>
	<xsl:param name="CommonURI">SDMXCommon.xsd</xsl:param>
	<xsl:param name="CompactURI">SDMXCompactData.xsd</xsl:param>
	<xsl:param name="KeyFamID">notPassed</xsl:param>
	
	<xsl:template match="/">
		<xsl:variable name="ns-node">
			<xsl:element name="ns-element" namespace="{$Namespace}"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="not(function-available('exslt:node-set'))">
				<xsl:choose>
					<xsl:when test="$Namespace='nameSpaceHolder'">
						<xsl:comment>Namespace was not passed via Namespace parameter.  Default value was set for xmlns and targetNamespace.</xsl:comment>
					</xsl:when>
					<xsl:otherwise>
						<xsl:comment>xmlns Could not be set.  Please set this to "<xsl:value-of select="$Namespace"/>" to make XSD valid.</xsl:comment>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$Namespace='nameSpaceHolder'">
						<xsl:comment>Namespace was not passed via Namespace parameter.  Default value was set for xmlns and targetNamespace.</xsl:comment>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:variable name="KFID">
			<xsl:choose>
				<xsl:when test="$KeyFamID = 'notPassed'">
					<xsl:value-of select="m:Structure/m:KeyFamilies/s:KeyFamily[1]/@id"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$KeyFamID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xs:schema>
			<xsl:if test="function-available('exslt:node-set')">
				<xsl:copy-of select="exslt:node-set($ns-node)/*/namespace::*[local-name()='']"/>
			</xsl:if>
			<xsl:attribute name="targetNamespace"><xsl:value-of select="$Namespace"/></xsl:attribute>
			<xsl:attribute name="elementFormDefault">qualified</xsl:attribute>
			<xsl:attribute name="attributeFormDefault">unqualified</xsl:attribute>
			
			<!-- Import Statements -->
			<xs:import>
				<xsl:attribute name="namespace">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/compact</xsl:attribute>
				<xsl:attribute name="schemaLocation"><xsl:value-of select="$CompactURI"/></xsl:attribute>
			</xs:import>
			<xs:import>
				<xsl:attribute name="namespace">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common</xsl:attribute>
				<xsl:attribute name="schemaLocation"><xsl:value-of select="$CommonURI"/></xsl:attribute>
			</xs:import>
		
			<xsl:apply-templates select="m:Structure/m:KeyFamilies/s:KeyFamily[@id = $KFID]"/>
		</xs:schema>
	</xsl:template>

	<xsl:template match="s:KeyFamily">
		<xsl:choose>
			<xsl:when test="@isExternal = 'true'">
				<xsl:variable name="ID" select="@id"/>
				<xsl:variable name="Agency" select="@agencyID"/>
				<xsl:apply-templates select="document(@uri, .)/m:Structure/m:KeyFamilies/s:KeyFamily[@id = $ID and @agencyID = $Agency]"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Create simpleTypes -->
				<xsl:apply-templates mode="CreateTypes" select="s:Components/*[self::s:Attribute or self::s:Dimension or self::s:TimeDimension or self::s:PrimaryMeasure]"/>
				<!-- Next Build Schema Components -->
				<!-- Global Data Set Element -->
				<xs:element name="DataSet" type="DataSetType" substitutionGroup="compact:DataSet"/>
				
				<!-- Data Set Complex Type-->
				<xs:complexType name="DataSetType">
					<xs:complexContent>
						<xs:extension base="compact:DataSetType">
							<xs:choice minOccurs="0" maxOccurs="unbounded">
								<xsl:for-each select="s:Components/s:Group">
									<xs:element	ref="{@id}"/>
								</xsl:for-each>
								<xs:element ref="Series"/>
								<xs:element name="Annotations" type="common:AnnotationsType"/>
							</xs:choice>
							<xsl:for-each select="s:Components/s:Attribute[@attachmentLevel = 'DataSet'] | s:Components/s:Dimension">
								<xsl:apply-templates select="." mode="CreateAttribute"/>
							</xsl:for-each>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>	
				
				<!-- Groups -->
				<xsl:for-each select="s:Components/s:Group">
					<xsl:variable name="ID" select="@id"/>
					<!-- Global Element -->
					<xs:element name="{$ID}" type="{$ID}Type" substitutionGroup="compact:Group"/>
					<!-- Complex Type -->
					<xs:complexType name="{$ID}Type">
						<xs:complexContent>
							<xs:extension base="compact:GroupType">
								<xs:sequence>
									<xs:element name="Annotations" type="common:AnnotationsType" minOccurs="0"/>
								</xs:sequence>
								<xsl:for-each select="s:DimensionRef">
									<xsl:variable name="conceptID" select="."/>
									<xsl:apply-templates select="../../s:Dimension[@conceptRef = $conceptID]" mode="CreateAttribute">
										<xsl:with-param name="use">required</xsl:with-param>
									</xsl:apply-templates>
								</xsl:for-each>
								<xsl:for-each select="../s:Attribute[@attachmentLevel = 'Group' and s:AttachmentGroup = $ID]">
									<xsl:apply-templates select="." mode="CreateAttribute"/>
								</xsl:for-each>
							</xs:extension>
						</xs:complexContent>
					</xs:complexType>
				</xsl:for-each>

				<!-- Series -->
				<!-- Global Element -->
				<xs:element name="Series" type="SeriesType" substitutionGroup="compact:Series"/>
				
				<!-- Complex Type -->
				<xs:complexType name="SeriesType">
					<xs:complexContent>
						<xs:extension base="compact:SeriesType">
							<xs:sequence>
								<xs:element ref="Obs" minOccurs="0" maxOccurs="unbounded"/>
								<xs:element name="Annotations" type="common:AnnotationsType" minOccurs="0"/>
							</xs:sequence>
							<xsl:for-each select="s:Components/s:Attribute[@attachmentLevel = 'Series'] | s:Components/s:Dimension">
								<xsl:apply-templates select="." mode="CreateAttribute">
									<xsl:with-param name="series">true</xsl:with-param>
								</xsl:apply-templates>
							</xsl:for-each>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>

				<!-- Obs -->
				<!-- Global Element -->
				<xs:element name="Obs" type="ObsType" substitutionGroup="compact:Obs"/>
				
				<!-- Complex Type -->
				<xs:complexType name="ObsType">
					<xs:complexContent>
						<xs:extension base="compact:ObsType">
							<xs:sequence>
								<xs:element name="Annotations" type="common:AnnotationsType" minOccurs="0"/>
							</xs:sequence>
							<xsl:for-each select="s:Components/s:PrimaryMeasure | s:Components/s:TimeDimension | s:Components/s:Attribute[@attachmentLevel='Observation']">
								<xsl:apply-templates select="." mode="CreateAttribute"/>
							</xsl:for-each>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template mode="CreateAttribute" match="s:Attribute | s:Dimension | s:PrimaryMeasure | s:TimeDimension">
		<xsl:param name="use">optional</xsl:param>
		<xsl:param name="series">false</xsl:param>
		<xsl:variable name="IsTimespan">
			<xsl:call-template name="IsTimespan"/>
		</xsl:variable>
		<xsl:variable name="usage">
			<xsl:choose>
				<xsl:when test="$series='true'">
					<xsl:choose>
						<xsl:when test="@isTimeFormat='true'">required</xsl:when>
						<xsl:otherwise><xsl:value-of select="$use"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$use"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="conceptType">
			<xsl:apply-templates mode="GetType" select="."/>
		</xsl:variable>
		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="$IsTimespan = 'true'">xs:duration</xsl:when>
				<xsl:otherwise><xsl:value-of select="$conceptType"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xs:attribute name="{@conceptRef}" type="{$type}" use="{$usage}"/>
		<xsl:if test="$IsTimespan = 'true'">
			<xs:attribute name="{@conceptRef}StartTime" type="xs:dateTime" use="{$usage}"/>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
