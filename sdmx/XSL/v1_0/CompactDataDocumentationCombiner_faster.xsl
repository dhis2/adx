<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common" 
xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:exslt="http://exslt.org/common" 
extension-element-prefixes="exslt" 
exclude-result-prefixes="xsl structure message compact"
version="1.0">
	<!-- Reusable Stylesheet to copy header info, without unnecessary namespaces -->
	<xsl:import href="HeaderCopy.xsl"/>
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<!-- Input Parameters -->
	<!-- ID of Key Family, conditional: mandatory if CompactData/Header/KeyFamilyRef is not used in Compact instance -->
	<xsl:param name="KeyFamID">notPassed</xsl:param>
	<!-- URI of Key Family xml instance, mandatory - needed to find strcture of Key Family -->
	<xsl:param name="KeyFamURI">notPassed</xsl:param>
	
	<xsl:template match="/">
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
						<xsl:variable name="Dimensions" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Dimension"/>
						<xsl:variable name="Attributes" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KFID]/structure:Components/structure:Attribute[@attachmentLevel='Series']"/>


						<xsl:for-each select="message:CompactData">
							<xsl:copy>
								<xsl:apply-templates mode="copy-no-ns" select="/message:CompactData/message:Header"/>
								<xsl:for-each select="*[local-name()='DataSet']">
									<xsl:copy>
										<xsl:for-each select="*[local-name()='Series' and *[local-name()='Obs']]">
											<xsl:variable name="TEST" select="@*[local-name() = $Dimensions/@concept]"/>
											<xsl:copy>
												<xsl:copy-of select="@*"/>
												
												<xsl:for-each select="//*[local-name()='Series' and not(child::*) and not(@*[local-name() = $Dimensions/@concept] != $TEST)]">
													
													<xsl:copy-of select="@*"/>
												</xsl:for-each>
												<xsl:for-each select="*[local-name()='Obs']">
													<xsl:copy>
														<xsl:copy-of select="@*"/>
													</xsl:copy>
												</xsl:for-each>
											</xsl:copy>
										</xsl:for-each>
									</xsl:copy>
								</xsl:for-each>
							</xsl:copy>
						</xsl:for-each>

					
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
