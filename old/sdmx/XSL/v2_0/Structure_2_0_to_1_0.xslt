<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:m2="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message"
xmlns:s2="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure"
xmlns:cmn2="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common"
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message"
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure"
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
exclude-result-prefixes="m2 s2 cmn2 xsl">
	<!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
	<xsl:import href="NamespaceCopy_2_0_to_1_0.xslt"/>
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<!-- Input Parameters -->
	<!-- Message URL: (optional) The location of the SDMX 2.0 Message Schema. This is used to make the validation of the output message simpler. If it is not passed, no schema location will be set) -->
	<xsl:param name="MessageURI">notPassed</xsl:param>
	
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
	
	<xsl:template match="/">
		<!-- Check for compliance -->
		<xsl:choose>
			<xsl:when test="//s2:Dimension[not(@codelist)]">
				<xsl:comment>Error: The transformation cannot proceed. The SDMX 2.0 Structure is not a valid SDMX 1.0 Structure.</xsl:comment>
				<xsl:for-each select="//s2:Dimension[not(@codelist)]">
					<xsl:comment>Dimension, <xsl:value-of select="@conceptRef"/>, does not have a codelist associated with it.</xsl:comment>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- Check for ambiguous concept and code list definitions. -->
				<xsl:for-each select="//s2:Concept">
					<xsl:variable name="ID" select="@id"/>
					<xsl:if test="count(//s2:Concept[@id = $ID]) > 1">
						<xsl:if test="not(preceding::s2:Concept[@id = $ID])">
							<xsl:comment>Warning: Duplicate concept ID, <xsl:value-of select="$ID"/>, exists. SDMX 1.0 components cannot reference concepts by version and maintenance agency, therefore the IDs for the concepts must be unique.</xsl:comment>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
				<!-- Check for ambiguous concept and code list definitions. -->
				<xsl:for-each select="//s2:CodeList">
					<xsl:variable name="ID" select="@id"/>
					<xsl:if test="count(//s2:CodeList[@id = $ID]) > 1">
						<xsl:if test="not(preceding::s2:CodeList[@id = $ID])">
							<xsl:comment>Warning: Duplicate codelist ID, <xsl:value-of select="$ID"/>, exists. SDMX 1.0 components cannot reference codelists by version and maintenance agency, therefore the IDs for the codelists must be unique.</xsl:comment>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
				<xsl:apply-templates select="*"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Root Level Transformation -->
	<xsl:template match="/m2:Structure">
		<Structure>
			<xsl:if test="$SchemaLoc != 'notPassed'">
				<xsl:attribute name="xsi:schemaLocation"><xsl:value-of select="$SchemaLoc"/></xsl:attribute>
			</xsl:if>
			<!-- Header -->
			<xsl:apply-templates mode="copy-no-ns" select="m2:Header"/>
			<!-- Agencies -->
			<xsl:if test="m2:OganisationSchemes/s2:OrganisationScheme[s2:Agencies or s2:DataProviders or s2:DataConsumers]">
				<Agencies>
					<xsl:for-each select="m2:OganisationSchemes/s2:OrganisationScheme/s2:Agencies/s2:Agency">
						<structure:Agency>
							<xsl:copy-of select="@*[name() = 'id' or name()='version' or name()='isExternalReference' or name()='uri']"/>
							<xsl:apply-templates mode="copy-no-ns" select="*[local-name() != 'Description' or local-name() != 'Annotations']"/>
						</structure:Agency>
					</xsl:for-each>
				</Agencies>
			</xsl:if>
			<!-- Code Lists -->
			<xsl:for-each select="m2:CodeLists">
				<CodeLists>
					<xsl:for-each select="s2:CodeList">
						<structure:CodeList>
							<xsl:copy-of select="@*[name() = 'id' or name()='version' or name()='isExternalReference' or name()='uri']"/>
							<xsl:attribute name="agency"><xsl:value-of select="@agencyID"/></xsl:attribute>
							<xsl:for-each select="s2:Name">
								<xsl:apply-templates mode="copy-no-ns" select="."/>
							</xsl:for-each>
							<xsl:for-each select="s2:Code">
								<structure:Code>
									<xsl:copy-of select="@value"/>
									<xsl:apply-templates mode="copy-no-ns" select="*"/>
								</structure:Code>
							</xsl:for-each>
							<xsl:apply-templates mode="copy-no-ns" select="s2:Annotations"/>
						</structure:CodeList>
					</xsl:for-each>
				</CodeLists>
			</xsl:for-each>
			<!-- Concepts -->
			<xsl:for-each select="m2:Concepts">
				<Concepts>
					<xsl:for-each select="descendant::s2:Concept">
						<structure:Concept>
							<xsl:copy-of select="@*[name() = 'id' or name()='version' or name()='isExternalReference' or name()='uri']"/>
							<xsl:if test="@agencyID"><xsl:attribute name="agency"><xsl:value-of select="@agencyID"/></xsl:attribute></xsl:if>
							<xsl:for-each select="s2:Name">
								<xsl:apply-templates mode="copy-no-ns" select="."/>
							</xsl:for-each>
							<xsl:apply-templates mode="copy-no-ns" select="s2:Annotations"/>
						</structure:Concept>
					</xsl:for-each>
				</Concepts>
			</xsl:for-each>
			<!-- Key Families -->
			<xsl:for-each select="m2:KeyFamilies">
				<KeyFamilies>
					<xsl:for-each select="s2:KeyFamily">
						<structure:KeyFamily>
							<!-- Attributes -->
							<xsl:copy-of select="@*[name() = 'id' or name()='version' or name()='isExternalReference' or name()='uri']"/>
							<xsl:attribute name="agency"><xsl:value-of select="@agencyID"/></xsl:attribute>
							<!-- Names -->
							<xsl:for-each select="s2:Name">
								<xsl:apply-templates mode="copy-no-ns" select="."/>
							</xsl:for-each>
							<!-- Components -->
							<xsl:for-each select="s2:Components">
								<structure:Components>
									<!-- Dimensions -->
									<xsl:for-each select="s2:Dimension">
										<structure:Dimension>
											<xsl:attribute name="concept">
												<xsl:value-of select="@conceptRef"/>
											</xsl:attribute>
											<xsl:copy-of select="@codelist"/>
											<xsl:copy-of select="@isMeasureDimension"/>
											<xsl:copy-of select="@isFrequencyDimension"/>
											<xsl:copy-of select="@crossSectionalAttachDataSet"/>
											<xsl:copy-of select="@crossSectionalAttachDataGroup"/>
											<xsl:copy-of select="@crossSectionalAttachDataSection"/>
											<xsl:copy-of select="@crossSectionalAttachDataObservation"/>
											<xsl:apply-templates mode="copy-no-ns" select="s2:Annotations"/>
										</structure:Dimension>
									</xsl:for-each>
									<!-- Time Dimension -->
									<xsl:for-each select="s2:TimeDimension">
										<structure:TimeDimension>
											<xsl:attribute name="concept">
												<xsl:value-of select="@conceptRef"/>
											</xsl:attribute>
											<xsl:copy-of select="@codelist"/>
											<xsl:apply-templates select="s2:TextFormat"/>
											<xsl:apply-templates mode="copy-no-ns" select="s2:Annotations"/>
										</structure:TimeDimension>
									</xsl:for-each>
									<!-- Groups -->
									<xsl:for-each select="s2:Group[s2:DimesnionRef]">
										<xsl:apply-templates mode="copy-no-ns" select="."/>
									</xsl:for-each>
									<!-- Primary Measure -->
									<xsl:for-each select="s2:PrimaryMeasure">
										<structure:PrimaryMeasure>
											<xsl:attribute name="concept">
												<xsl:value-of select="@conceptRef"/>
											</xsl:attribute>
											<xsl:apply-templates mode="copy-no-ns" select="s2:Annotations"/>
										</structure:PrimaryMeasure>
									</xsl:for-each>
									<!-- Cross Sectional Measure -->
									<xsl:for-each select="s2:CrossSectionalMeasure">
										<structure:CrossSectionalMeasure>
											<xsl:attribute name="concept">
												<xsl:value-of select="@conceptRef"/>
											</xsl:attribute>
											<xsl:copy-of select="@measureDimension"/>
											<xsl:copy-of select="@code"/>
											<xsl:apply-templates mode="copy-no-ns" select="s2:Annotations"/>
										</structure:CrossSectionalMeasure>
									</xsl:for-each>
									<!-- Attribute -->
									<xsl:for-each select="s2:Attribute">
										<structure:Attribute>
											<xsl:attribute name="concept">
												<xsl:value-of select="@conceptRef"/>
											</xsl:attribute>
											<xsl:copy-of select="@codelist"/>
											<xsl:copy-of select="@isTimeFormat"/>
											<xsl:copy-of select="@attachmentLevel"/>
											<xsl:copy-of select="@assignmentStatus"/>
											<xsl:copy-of select="@crossSectionalAttachDataSet"/>
											<xsl:copy-of select="@crossSectionalAttachDataGroup"/>
											<xsl:copy-of select="@crossSectionalAttachDataSection"/>
											<xsl:copy-of select="@crossSectionalAttachDataObservation"/>
											<xsl:apply-templates select="s2:TextFormat"/>
											<xsl:apply-templates mode="copy-no-ns" select="*[local-name() != 'TextFormat']"/>
										</structure:Attribute>
									</xsl:for-each>
								</structure:Components>
							</xsl:for-each>
							<!-- Annotations -->
							<xsl:apply-templates mode="copy-no-ns" select="s2:Annotations"/>
						</structure:KeyFamily>
					</xsl:for-each>
				</KeyFamilies>
			</xsl:for-each>
		</Structure>
	</xsl:template>
	
	<xsl:template match="s2:TextFormat">
		<structure:TextFormat>
			<xsl:choose>
				<xsl:when test="@textType = 'String'">
					<xsl:choose>
						<xsl:when test="@minLength = @maxLength">
							<xsl:attribute name="TextType">AlphaNumFixed</xsl:attribute>
							<xsl:attribute name="length">
								<xsl:value-of select="@maxLength"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="TextType">AlphaNum</xsl:attribute>
							<xsl:if test="@maxLength">
								<xsl:attribute name="length">
									<xsl:value-of select="@maxLength"/>
								</xsl:attribute>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@textType = 'BigInteger' or @textType = 'Integer' or @textType = 'Long' or @textType = 'Short' or @textType = 'Decimal' or @textType = 'Float' or @textType = 'Double'">
					<xsl:choose>
						<xsl:when test="@minLength = @maxLength">
							<xsl:attribute name="TextType">NumFixed</xsl:attribute>
							<xsl:attribute name="length">
								<xsl:value-of select="@maxLength"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="TextType">Num</xsl:attribute>
							<xsl:if test="@maxLength">
								<xsl:attribute name="length">
									<xsl:value-of select="@maxLength"/>
								</xsl:attribute>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@textType = 'Boolean'">
					<xsl:attribute name="TextType">Alpha</xsl:attribute>
				</xsl:when>
				<xsl:when test="@textType = 'DateTime' or @textType='Date' or @textType='Time' or @textType='Year' or @textType='Month' or @textType='Day' or @textType='MonthDay' or @textType='YearMonth' or @textType='Duration' or @textType='URI' or @textType='Timespan' or @textType='ObservationalTimePeriod'">
					<xsl:attribute name="TextType">AlphaNum</xsl:attribute>
				</xsl:when>
				<xsl:when test="@textType = 'Count' or @textType = 'InclusiveValueRange' or @textType = 'ExclusiveValueRange' or @textType = 'Incremental'">
					<xsl:attribute name="TextType">Num</xsl:attribute>
					<xsl:if test="@maxLength">
						<xsl:attribute name="length">
							<xsl:value-of select="@maxLength"/>
						</xsl:attribute>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
			<xsl:copy-of select="@decimals"/>
		</structure:TextFormat>		
	</xsl:template>
		     
</xsl:stylesheet>
