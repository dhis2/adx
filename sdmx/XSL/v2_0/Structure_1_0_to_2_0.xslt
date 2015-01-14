<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:m1="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message"
xmlns:s1="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure"
xmlns:cmn1="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common"
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message"
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure"
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
exclude-result-prefixes="m1 s1 cmn1 xsl">
	<!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
	<xsl:import href="NamespaceCopy_1_0_to_2_0.xslt"/>
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<!-- Input Parameters -->
	<!-- Organisation Scheme ID: (Optional) The identification of the organisation scheme to which the agencies identified in the SDMX 1.0 instance should belong to in the 2.0 instance. If a value is not passed, then the 1.0 agencies will still be transformed, and the organisation scheme assigned default values. -->
	<xsl:param name="OrgSchemeID">notPassed</xsl:param>
	<!-- Organisation Scheme Agency ID: (Optional) The identification of the agency maintaining the organisation scheme to which the agencies identified in the SDMX 1.0 instance should belong to in the 2.0 instance. If a value is not passed, then the 1.0 agencies will still be transformed, and the organisation scheme assigned default values. -->
	<xsl:param name="OrgSchemeAgencyID">notPassed</xsl:param>
	<!-- Organisation Scheme Name: (Optional) The name of the organisation scheme to which the agencies identified in the SDMX 1.0 instance should belong to in the 2.0 instance. If a value is not passed, then the 1.0 agencies will still be transformed, and the organisation scheme assigned default values. -->
	<xsl:param name="OrgSchemeName">notPassed</xsl:param>
	<!-- Default Code List Agency: (Optional) The default agency to use for code lists, which do not reference an agency in the SDMX 1.0 instance. If a value is not passed, then the agency for 1.0 code lists will be defaulted -->
	<xsl:param name="DefaultCLAgency">notPassed</xsl:param>
	<!-- Default Concept Agency: (Optional) The default agency to use for concepts, which do not reference an agency in the SDMX 1.0 instance. If a value is not passed, then the agency for 1.0 concepts will be defaulted -->
	<xsl:param name="DefaultConceptAgency">notPassed</xsl:param>
	<!-- Message URI: (optional) The location of the SDMX 2.0 Message Schema. This is used to make the validation of the output message simpler. If it is not passed, no schema location will be set) -->
	<xsl:param name="MessageURI">notPassed</xsl:param>
	
	<xsl:variable name="SchemaLoc">
		<xsl:choose>
			<xsl:when test="$MessageURI != 'notPassed'">
				<xsl:text>http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message </xsl:text>
				<xsl:value-of select="$MessageURI"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>notPassed</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Root Level Transformation -->
	<xsl:template match="/m1:Structure">
		<Structure>
			<xsl:if test="$SchemaLoc != 'notPassed'">
				<xsl:attribute name="xsi:schemaLocation"><xsl:value-of select="$SchemaLoc"/></xsl:attribute>
			</xsl:if>
			<!-- Header -->
			<xsl:apply-templates mode="copy-no-ns" select="m1:Header"/>
			<!-- Agencies -->
			<xsl:for-each select="m1:Agencies">
				<xsl:variable name="OSID">
					<xsl:choose>
						<xsl:when test="$OrgSchemeID = 'notPassed'">DefaultValue</xsl:when>
						<xsl:otherwise><xsl:value-of select="$OrgSchemeID"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="OSAgency">
					<xsl:choose>
						<xsl:when test="$OrgSchemeAgencyID = 'notPassed'">DefaultValue</xsl:when>
						<xsl:otherwise><xsl:value-of select="$OrgSchemeAgencyID"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="OSName">
					<xsl:choose>
						<xsl:when test="$OrgSchemeName = 'notPassed'"><xsl:value-of select="$OSID"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$OrgSchemeName"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<OrganisationSchemes>
					<structure:OrganisationScheme>
						<xsl:attribute name="id"><xsl:value-of select="$OSID"/></xsl:attribute>
						<xsl:attribute name="agencyID"><xsl:value-of select="$OSAgency"/></xsl:attribute>
						<structure:Name><xsl:value-of select="$OSName"/></structure:Name>
						<structure:Agencies>
							<xsl:for-each select="s1:Agency">
								<xsl:apply-templates mode="copy-no-ns" select="."/>
							</xsl:for-each>
						</structure:Agencies>
					</structure:OrganisationScheme>
				</OrganisationSchemes>
			</xsl:for-each>
			<!-- Code Lists -->
			<xsl:for-each select="m1:CodeLists">
				<CodeLists>
					<xsl:for-each select="s1:CodeList">
						<structure:CodeList>
							<xsl:variable name="Agency">
								<xsl:choose>
									<xsl:when test="@agency"><xsl:value-of select="@agency"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$DefaultCLAgency"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:copy-of select="@*[name() != 'agency']"/>
							<xsl:attribute name="agencyID"><xsl:value-of select="$Agency"/></xsl:attribute>
							<xsl:apply-templates mode="copy-no-ns" select="*"/>
						</structure:CodeList>
					</xsl:for-each>
				</CodeLists>
			</xsl:for-each>
			<!-- Concepts -->
			<xsl:for-each select="m1:Concepts">
				<Concepts>
					<xsl:for-each select="s1:Concept">
						<structure:Concept>
							<xsl:variable name="Agency">
								<xsl:choose>
									<xsl:when test="@agency"><xsl:value-of select="@agency"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$DefaultConceptAgency"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:copy-of select="@*[name() != 'agency']"/>
							<xsl:attribute name="agencyID"><xsl:value-of select="$Agency"/></xsl:attribute>
							<xsl:apply-templates mode="copy-no-ns" select="*"/>
						</structure:Concept>
					</xsl:for-each>
				</Concepts>
			</xsl:for-each>
			<!-- Key Families -->
			<xsl:for-each select="m1:KeyFamilies">
				<KeyFamilies>
					<xsl:for-each select="s1:KeyFamily">
						<structure:KeyFamily>
							<xsl:variable name="Agency">
								<xsl:choose>
									<xsl:when test="@agency"><xsl:value-of select="@agency"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$DefaultConceptAgency"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!-- Attributes -->
							<xsl:copy-of select="@*[name() != 'agency']"/>
							<xsl:attribute name="agencyID"><xsl:value-of select="$Agency"/></xsl:attribute>
							<!-- Names -->
							<xsl:for-each select="s1:Name">
								<xsl:apply-templates mode="copy-no-ns" select="."/>
							</xsl:for-each>
							<!-- Components -->
							<xsl:for-each select="s1:Components">
								<structure:Components>
									<!-- Dimensions -->
									<xsl:call-template name="CopyComponent">
										<xsl:with-param name="Type">Dimension</xsl:with-param>
									</xsl:call-template>
									<!-- Time Dimension -->
									<xsl:call-template name="CopyComponent">
										<xsl:with-param name="Type">TimeDimension</xsl:with-param>
									</xsl:call-template>
									<!-- Groups -->
									<xsl:for-each select="s1:Group">
										<xsl:apply-templates mode="copy-no-ns" select="."/>
									</xsl:for-each>
									<!-- Primary Measure -->
									<xsl:call-template name="CopyComponent">
										<xsl:with-param name="Type">PrimaryMeasure</xsl:with-param>
									</xsl:call-template>
									<!-- Cross Sectional Measure -->
									<xsl:call-template name="CopyComponent">
										<xsl:with-param name="Type">CrossSectionalMeasure</xsl:with-param>
									</xsl:call-template>
									<!-- Attribute -->
									<xsl:call-template name="CopyComponent">
										<xsl:with-param name="Type">Attribute</xsl:with-param>
									</xsl:call-template>
								</structure:Components>
							</xsl:for-each>
							<!-- Annotations -->
							<xsl:apply-templates mode="copy-no-ns" select="s1:Annotations"/>
						</structure:KeyFamily>
					</xsl:for-each>
				</KeyFamilies>
			</xsl:for-each>
		</Structure>
	</xsl:template>
	
	<xsl:template name="CopyComponent">
		<xsl:param name="Type"></xsl:param>
		<xsl:for-each select="s1:*[local-name() = $Type]">
			<xsl:element name="structure:{$Type}">
				<!-- Attributes -->
				<!-- Concept -->
				<xsl:variable name="ConceptID">
					<xsl:value-of select="@concept"/>
				</xsl:variable>
				<xsl:attribute name="conceptRef">
					<xsl:value-of select="$ConceptID"/>
				</xsl:attribute>
				<xsl:if test="//s1:Concept[@id = $ConceptID]/@version">
					<xsl:attribute name="conceptVersion">
						<xsl:value-of select="//s1:Concept[@id = $ConceptID]/@version"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="//s1:Concept[@id = $ConceptID]/@agency">
					<xsl:attribute name="conceptAgency">
						<xsl:value-of select="//s1:Concept[@id = $ConceptID]/@agency"/>
					</xsl:attribute>
				</xsl:if>
				<!-- Codelist -->
				<xsl:if test="@codelist">
					<xsl:variable name="CodeListID">
						<xsl:value-of select="@codelist"/>
					</xsl:variable>
					<xsl:attribute name="codelist">
						<xsl:value-of select="$CodeListID"/>
					</xsl:attribute>
					<xsl:if test="//s1:CodeList[@id = $CodeListID]/@version">
						<xsl:attribute name="codelistVersion">
							<xsl:value-of select="//s1:CodeList[@id = $CodeListID]/@version"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="//s1:CodeList[@id = $CodeListID]/@agency">
						<xsl:attribute name="codelistAgency">
							<xsl:value-of select="//s1:CodeList[@id = $CodeListID]/@agency"/>
						</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<!-- Other Attributes -->
				<xsl:copy-of select="@*[name() != 'codelist' and name() != 'concept']"/>
				<!-- Text Format -->
				<xsl:for-each select="TextFormat">
					<structure:TextFormat>
						<xsl:choose>
							<xsl:when test="@TextType = 'Alpha'">
								<xsl:attribute name="textType">String</xsl:attribute>
								<xsl:if test="@length">
									<xsl:attribute name="maxLength">
										<xsl:value-of select="@length"/>
									</xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:when test="@TextType = 'AlphaFixed'">
								<xsl:attribute name="textType">String</xsl:attribute>
								<xsl:if test="@length">
									<xsl:attribute name="minLength">
										<xsl:value-of select="@length"/>
									</xsl:attribute>
									<xsl:attribute name="maxLength">
										<xsl:value-of select="@length"/>
									</xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:when test="@TextType = 'AlphaNum'">
								<xsl:attribute name="textType">String</xsl:attribute>
								<xsl:if test="@length">
									<xsl:attribute name="maxLength">
										<xsl:value-of select="@length"/>
									</xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:when test="@TextType = 'AlphaNumFixed'">
								<xsl:attribute name="textType">String</xsl:attribute>
								<xsl:if test="@length">
									<xsl:attribute name="minLength">
										<xsl:value-of select="@length"/>
									</xsl:attribute>
									<xsl:attribute name="maxLength">
										<xsl:value-of select="@length"/>
									</xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:when test="@TextType = 'Num'">
								<xsl:attribute name="textType">Decimal</xsl:attribute>
								<xsl:if test="@length">
									<xsl:attribute name="maxLength">
										<xsl:value-of select="@length"/>
									</xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:when test="@TextType = 'NumFixed'">
								<xsl:attribute name="textType">Decimal</xsl:attribute>
								<xsl:if test="@length">
									<xsl:attribute name="minLength">
										<xsl:value-of select="@length"/>
									</xsl:attribute>
									<xsl:attribute name="maxLength">
										<xsl:value-of select="@length"/>
									</xsl:attribute>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
						<xsl:copy-of select="@decimals"/>
					</structure:TextFormat>
				</xsl:for-each>
				<!-- Annotations, etc. -->
				<xsl:apply-templates mode="copy-no-ns" select="*[local-name() != 'TextFormat']"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	     
</xsl:stylesheet>
