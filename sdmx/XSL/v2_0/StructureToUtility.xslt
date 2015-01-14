<?xml version="1.0"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" 
xmlns:m="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:s="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
xmlns:utility="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility" 
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
	<xsl:param name="UtilityURI">SDMXUtilityData.xsd</xsl:param>
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
				<xsl:attribute name="namespace">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/utility</xsl:attribute>
				<xsl:attribute name="schemaLocation"><xsl:value-of select="$UtilityURI"/></xsl:attribute>
			</xs:import>
			<xs:import>
				<xsl:attribute name="namespace"><xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common</xsl:text></xsl:attribute>
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
				<xs:element name="DataSet" type="DataSetType" substitutionGroup="utility:DataSet"/>
				
				<!-- Data Set Complex Type-->
				<xs:complexType name="DataSetType">
					<xs:complexContent>
						<xs:extension base="utility:DataSetType">
							<xs:sequence>
								<xs:choice maxOccurs="unbounded">
									<xsl:choose>
										<xsl:when test="s:Components/s:Group">
											<xsl:for-each select="s:Components/s:Group">
												<xs:element	ref="{@id}"/>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xs:element ref="Series"/>
										</xsl:otherwise>
									</xsl:choose>
								</xs:choice>
								<xs:element name="Annotations" type="common:AnnotationsType" minOccurs="0"/>
							</xs:sequence>
							<xsl:for-each select="s:Components/s:Attribute[@attachmentLevel = 'DataSet']">
								<xsl:apply-templates select="." mode="CreateAttribute"/>
							</xsl:for-each>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>	
				
				<!-- Groups -->
				<xsl:for-each select="s:Components/s:Group">
					<xsl:variable name="ID" select="@id"/>
					<!-- Global Element -->
					<xs:element name="{$ID}" type="{$ID}Type" substitutionGroup="utility:Group"/>
					
					<!-- Complex Type -->
					<xs:complexType name="{$ID}Type">
						<xs:complexContent>
							<xs:extension base="utility:GroupType">
								<xs:sequence>
									<xs:element ref="Series" maxOccurs="unbounded"/>
									<xs:element name="Annotations" type="common:AnnotationsType" minOccurs="0"/>
								</xs:sequence>
								<xsl:for-each select="../s:Attribute[@attachmentLevel = 'Group' and s:AttachmentGroup = $ID]">
									<xsl:apply-templates select="." mode="CreateAttribute"/>
								</xsl:for-each>
							</xs:extension>
						</xs:complexContent>
					</xs:complexType>
				</xsl:for-each>				

				<!-- Series -->
				<!-- Global Element -->
				<xs:element name="Series" type="SeriesType" substitutionGroup="utility:Series"/>
				
				<!-- Complex Type -->
				<xs:complexType name="SeriesType">
					<xs:complexContent>
						<xs:extension base="utility:SeriesType">
							<xs:sequence>
								<xs:element ref="Key"/>
								<xs:element ref="Obs" maxOccurs="unbounded"/>
								<xs:element name="Annotations" type="common:AnnotationsType" minOccurs="0"/>
							</xs:sequence>
							<xsl:for-each select="s:Components/s:Attribute[@attachmentLevel = 'Series']">
								<xsl:apply-templates select="." mode="CreateAttribute"/>
							</xsl:for-each>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>

				<!-- Key -->
				<!-- Global Element -->
				<xs:element name="Key" type="KeyType" substitutionGroup="utility:Key"/>
				
				<!-- Complex Type -->
				<xs:complexType name="KeyType">
					<xs:complexContent>
						<xs:extension base="utility:KeyType">
							<xs:sequence>
								<xsl:for-each select="s:Components/s:Dimension">
									<xsl:variable name="Type">
										<xsl:apply-templates mode="GetType" select="."/>
									</xsl:variable>								
									<xs:element name="{@conceptRef}">
										<xsl:attribute name="type">
											<xsl:choose>
												<xsl:when test="@isNonObservationalTimeDimension = 'true'">common:TimePeriodType</xsl:when>
												<xsl:when test="@isCountDimension = 'true'">xs:integer</xsl:when>
												<xsl:when test="@isEntityDimension = 'true'">xs:string</xsl:when>
												<xsl:otherwise><xsl:value-of select="$Type"/></xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</xs:element>
								</xsl:for-each>
							</xs:sequence>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>

				<!-- Obs -->
				<!-- Global Element -->
				<xs:element name="Obs" type="ObsType" substitutionGroup="utility:Obs"/>
				
				<!-- Complex Type -->
				<xs:complexType name="ObsType">
					<xs:complexContent>
						<xs:extension base="utility:ObsType">
							<xs:sequence>
								<xsl:variable name="TimeType">
									<xsl:apply-templates mode="GetType" select="s:Components/s:TimeDimension"/>
								</xsl:variable>
								<xs:element name="{s:Components/s:TimeDimension/@conceptRef}" type="{$TimeType}"/>
								<xsl:apply-templates select="s:Components/s:PrimaryMeasure" mode="CreateElement"/>
								<xs:element name="Annotations" type="common:AnnotationsType" minOccurs="0"/>
							</xs:sequence>
							<xsl:for-each select="s:Components/s:Attribute[@attachmentLevel = 'Observation']">
								<xsl:apply-templates select="." mode="CreateAttribute"/>
							</xsl:for-each>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template mode="CreateAttribute" match="s:Attribute">
		<xsl:variable name="IsTimespan">
			<xsl:call-template name="IsTimespan"/>
		</xsl:variable>
		<xs:attribute name="{@conceptRef}">
			<xsl:variable name="Type">
				<xsl:apply-templates mode="GetType" select="."/>
			</xsl:variable>
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="$IsTimespan = 'true'">xs:duration</xsl:when>
					<xsl:otherwise><xsl:value-of select="$Type"/></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:variable name="use">
				<xsl:choose>
					<xsl:when test="@assignmentStatus='Mandatory'">required</xsl:when>
					<xsl:otherwise>optional</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="use">
				<xsl:choose>
					<xsl:when test="@assignmentStatus='Mandatory'">required</xsl:when>
					<xsl:when test="@assignmentStatus='Conditional'">optional</xsl:when>
				</xsl:choose>
			</xsl:attribute>
		</xs:attribute>
		<xsl:if test="$IsTimespan = 'true'">
			<xs:attribute name="{@conceptRef}StartTime" type="xs:dateTime">
				<xsl:attribute name="use">
					<xsl:choose>
						<xsl:when test="@assignmentStatus='Mandatory'">required</xsl:when>
						<xsl:when test="@assignmentStatus='Conditional'">optional</xsl:when>
					</xsl:choose>
				</xsl:attribute>
			</xs:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="CreateElement" match="s:PrimaryMeasure">
		<xsl:variable name="IsTimespan">
			<xsl:call-template name="IsTimespan"/>
		</xsl:variable>
		<xsl:variable name="Type">
			<xsl:apply-templates mode="GetType" select="."/>
		</xsl:variable>		
		<xs:element name="{@conceptRef}">
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="$IsTimespan = 'true'">xs:duration</xsl:when>
					<xsl:otherwise><xsl:value-of select="$Type"/></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xs:element>
		<xsl:if test="$IsTimespan = 'true'">
			<xs:element name="ObsStartTime" type="xs:dateTime"/>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
