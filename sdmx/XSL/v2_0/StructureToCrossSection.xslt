<?xml version="1.0"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" 
xmlns:m="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:s="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
xmlns:cross="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross" 
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
	<xsl:param name="CrossURI">SDMXCrossSectionalData.xsd</xsl:param>
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
				<xsl:attribute name="namespace">http://www.SDMX.org/resources/SDMXML/schemas/v2_0/cross</xsl:attribute>
				<xsl:attribute name="schemaLocation"><xsl:value-of select="$CrossURI"/></xsl:attribute>
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
				<xsl:apply-templates mode="CreateTypes" select="s:Components/*[self::s:Attribute or self::s:Dimension or self::s:TimeDimension or self::s:PrimaryMeasure or self::s:CrossSectionalMeasure]"/>
				<!-- Next Build Schema Components -->
				<!-- Global Data Set Element -->
				<xs:element name="DataSet" type="DataSetType" substitutionGroup="cross:DataSet"/>
				
				<!-- Data Set Complex Type-->
				<xs:complexType name="DataSetType">
					<xs:complexContent>
						<xs:extension base="cross:DataSetType">
							<xs:choice minOccurs="0" maxOccurs="unbounded">
								<xs:element	ref="Group"/>
								<xs:element ref="Section"/>
								<xs:element name="Annotations" type="common:AnnotationsType"/>
							</xs:choice>
							<xsl:for-each select="s:Components/s:Attribute[@crossSectionalAttachDataSet='true'] | s:Components/s:Dimension[@crossSectionalAttachDataSet='true'] | s:Components/s:TimeDimension[@crossSectionalAttachDataSet='true']">
								<xsl:apply-templates select="." mode="CreateAttribute"/>
							</xsl:for-each>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>	
				
				<!-- Group -->
				<!-- Global Element -->
				<xs:element name="Group" type="GroupType" substitutionGroup="cross:Group"/>
				<!-- Complex Type -->
				<xs:complexType name="GroupType">
					<xs:complexContent>
						<xs:extension base="cross:GroupType">
							<xs:sequence>
								<xs:element ref="Section" minOccurs="0" maxOccurs="unbounded"/>
								<xs:element name="Annotations" type="common:AnnotationsType" minOccurs="0"/>
							</xs:sequence>
							<xsl:for-each select="s:Components/s:Attribute[@crossSectionalAttachGroup='true'] | s:Components/s:Dimension[@crossSectionalAttachGroup='true' or @isFrequencyDimension='true'] | s:Components/s:TimeDimension[@crossSectionalAttachGroup='true']">
								<xsl:apply-templates select="." mode="CreateAttribute"/>
							</xsl:for-each>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>

				<!-- Section -->
				<!-- Global Element -->
				<xs:element name="Section" type="SectionType" substitutionGroup="cross:Section"/>
				
				<!-- Complex Type -->
				<xs:complexType name="SectionType">
					<xs:complexContent>
						<xs:extension base="cross:SectionType">
							<xs:choice minOccurs="0" maxOccurs="unbounded">
								<xsl:choose>
									<xsl:when test="s:Components/s:CrossSectionalMeasure">
										<xsl:for-each select="s:Components/s:CrossSectionalMeasure">
											<xs:element ref="{@conceptRef}"/>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xs:element ref="{s:Components/s:PrimaryMeasure/@conceptRef}"/>
									</xsl:otherwise>	
								</xsl:choose>
								<xs:element name="Annotations" type="common:AnnotationsType"/>
							</xs:choice>
							<xsl:for-each select="s:Components/s:Attribute[@crossSectionalAttachSection='true'] | s:Components/s:Dimension[@crossSectionalAttachSection='true'] | s:Components/s:TimeDimension[@crossSectionalAttachSection='true']">
								<xsl:apply-templates select="." mode="CreateAttribute"/>
							</xsl:for-each>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>

				<!-- Cross Sectional Measures -->
				<xsl:choose>
					<xsl:when test="s:Components/s:CrossSectionalMeasure">
						<xsl:for-each select="s:Components/s:CrossSectionalMeasure">
							<xsl:variable name="concept" select="@conceptRef"/>
							<!-- Global Element -->
							<xs:element name="{$concept}" type="{$concept}ObsType" substitutionGroup="cross:Obs"/>
							<!-- Complex Type -->
							<xs:complexType name="{$concept}ObsType">
								<xs:complexContent>
									<xs:extension base="cross:ObsType">
										<xs:sequence>
											<xs:element name="Annotations" type="common:AnnotationsType" minOccurs="0"/>
										</xs:sequence>
										<xsl:for-each select="../s:Attribute[@crossSectionalAttachObservation='true' and s:AttachmentMeasure=$concept] | ../s:Dimension[@crossSectionalAttachObservation='true'] | s:Components/s:TimeDimension[@crossSectionalAttachObservation='true']">
											<xsl:variable name="dimensionConcept" select="@conceptRef"/>
											<xsl:choose>
												<xsl:when test="../s:CrossSectionalMeasure[@measureDimension=$dimensionConcept]">
													<xsl:comment>Dimension (<xsl:value-of select="@conceptRef"/>) cannot be attached to the observation level, if it's value represent a cross section measurement.</xsl:comment>
												</xsl:when>
												<xsl:otherwise>
													<xsl:apply-templates select="." mode="CreateAttribute"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
										<xsl:variable name="type">
											<xsl:apply-templates mode="GetType" select="."/>
										</xsl:variable>
										<xs:attribute name="value" type="{$type}" use="optional"/>
									</xs:extension>
								</xs:complexContent>
							</xs:complexType>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xs:element name="{s:Components/s:PrimaryMeasure/@conceptRef}" type="ObsType" substitutionGroup="cross:Obs"/>
						<!-- Complex Type -->
						<xs:complexType name="ObsType">
							<xs:complexContent>
								<xs:extension base="cross:ObsType">
									<xs:sequence>
										<xs:element name="Annotations" type="common:AnnotationsType" minOccurs="0"/>
									</xs:sequence>
									<xsl:for-each select="s:Components/s:Attribute[@crossSectionalAttachObservation='true'] | s:Components/s:Dimension[@crossSectionalAttachObservation='true'] | s:Components/s:TimeDimension[@crossSectionalAttachObservation='true']">
										<xsl:variable name="dimensionConcept" select="@conceptRef"/>
										<xsl:choose>
											<xsl:when test="../s:CrossSectionalMeasure[@measureDimension=$dimensionConcept]">
												<xsl:comment>Dimension (<xsl:value-of select="@conceptRef"/>) cannot be attached to the observation level, if it's value represent a cross section measurement.</xsl:comment>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates select="." mode="CreateAttribute"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
									<xsl:variable name="type">
										<xsl:apply-templates mode="GetType" select="s:Components/s:PrimaryMeasure"/>
									</xsl:variable>
									<xs:attribute name="value" type="{$type}" use="optional"/>
								</xs:extension>
							</xs:complexContent>
						</xs:complexType>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template mode="CreateAttribute" match="s:Attribute | s:Dimension | s:PrimaryMeasure | s:TimeDimension | s:CrossSectionalMeasure">
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
		<xsl:choose>
			<xsl:when test="$IsTimespan='true' and self::s:Dimension">
				<xsl:comment>Dimensions are not allowed to be of type Timespan in cross sectional data.</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xs:attribute name="{@conceptRef}" type="{$type}" use="{$usage}"/>
				<xsl:if test="$IsTimespan='true'">
					<xs:attribute name="{@conceptRef}StartTime" type="xs:dateTime" use="{$usage}"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
