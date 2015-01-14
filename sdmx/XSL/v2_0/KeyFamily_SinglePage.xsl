<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:m="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:c="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" 
xmlns:s="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
exclude-result-prefixes="xsl s m c">

	<xsl:output method="html" version="4.0" indent="yes"/>
	<xsl:include href="KeyFamUtilities.xsl"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:param name="KeyFamID">notPassed</xsl:param>
	<xsl:param name="lang">notPassed</xsl:param>
	<xsl:param name="isSingleDoc">true</xsl:param>

	<xsl:template match="/">
		<xsl:variable name="KFID">
			<xsl:choose>
				<xsl:when test="$KeyFamID = 'notPassed'">
					<xsl:value-of select="m:Structure/m:KeyFamilies/s:KeyFamily[1]/@id"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$KeyFamID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates select="m:Structure/m:KeyFamilies/s:KeyFamily[@id = $KFID]"/>
	</xsl:template>
	
	<xsl:template match="s:KeyFamily">
		<xsl:choose>
			<xsl:when test="@isExternal = 'true'">
				<xsl:variable name="ID" select="@id"/>
				<xsl:variable name="Agency" select="@agencyID"/>
				<xsl:apply-templates select="document(@uri, .)/m:Structure/m:KeyFamilies/s:KeyFamily[@id = $ID and @agencyID = $Agency]"/>		
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="KeyFamNamePos">
					<xsl:choose>
						<xsl:when test="$lang='notPassed' or not(s:Name[@xml:lang=$lang])">
							<xsl:value-of select="position()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="position()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="KeyFamName" select="s:Name[position() = $KeyFamNamePos]"/>
				<xsl:variable name="KFID" select="@id"/>

				<html>
					<xsl:call-template name="Head">
						<xsl:with-param name="KFID" select="$KFID"/>
						<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
					</xsl:call-template>
					<body>
						<xsl:call-template name="Header">
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:call-template>
			
						<xsl:call-template name="Menu">
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:call-template>
			
						<xsl:call-template name="Instructions">
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:call-template>
			
						<xsl:call-template name="Basic">
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:call-template>

						<xsl:call-template name="Dimensions">
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:call-template>
		
						<xsl:for-each select="s:Components/s:Dimension | s:Components/s:TimeDimension">
							<xsl:apply-templates select="." mode="Page">
								<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
								<xsl:with-param name="KFID" select="$KFID"/>
							</xsl:apply-templates>
						</xsl:for-each>
		
						<xsl:call-template name="Attributes">
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:call-template>
		
						<xsl:for-each select="s:Components/s:Attribute | s:Components/s:PrimaryMeasure">
							<xsl:apply-templates select="." mode="Page">
								<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
								<xsl:with-param name="KFID" select="$KFID"/>
							</xsl:apply-templates>
						</xsl:for-each>
		
						<xsl:if test="s:Components/s:Group">
							<xsl:call-template name="Groups">
								<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
								<xsl:with-param name="KFID" select="$KFID"/>
							</xsl:call-template>
						</xsl:if>
						
						<xsl:for-each select="s:Components/s:Group">
							<xsl:apply-templates select="." mode="Page">
								<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
								<xsl:with-param name="KFID" select="$KFID"/>
							</xsl:apply-templates>
						</xsl:for-each>
			
						<xsl:if test="s:Components/s:CrossSectionalMeasure">
							<xsl:call-template name="Cross">
								<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
								<xsl:with-param name="KFID" select="$KFID"/>
							</xsl:call-template>
						</xsl:if>
						
						<xsl:for-each select="s:Components/s:CrossSectionalMeasure">
							<xsl:apply-templates select="." mode="Page">
								<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
								<xsl:with-param name="KFID" select="$KFID"/>
							</xsl:apply-templates>
						</xsl:for-each>
						
						<xsl:for-each select="s:Components">
							<xsl:for-each select="s:Dimension | s:TimeDimension | s:Attribute | s:PrimaryMeasure | s:CrossSectionalMeasure">
								<xsl:apply-templates select="." mode="Codes">
									<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
									<xsl:with-param name="KFID" select="$KFID"/>
								</xsl:apply-templates>
							</xsl:for-each>
						</xsl:for-each>
		
						<xsl:for-each select="s:Components">
							<xsl:for-each select="s:Dimension | s:TimeDimension | s:Attribute | s:PrimaryMeasure | s:CrossSectionalMeasure">
								<xsl:apply-templates select="." mode="Concepts">
									<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
									<xsl:with-param name="KFID" select="$KFID"/>
								</xsl:apply-templates>
							</xsl:for-each>
						</xsl:for-each>

					</body>
				</html>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="Header">
		<xsl:param name="KeyFamName"/>
		<h1><img src="SDMXLogo.gif" alt="Statistical Data and Metadata Exchange"/><br/><xsl:value-of select="$KeyFamName"/></h1>
	</xsl:template>
	
	<xsl:template name="Menu">
		<a name="Menu"/>
		<table border="2" class="section">
			<tbody>
				<tr>
					<td class="menuCells" width="25%"><a href="#Instructions" class="menuLink">Instructions</a></td>
					<td class="menuCells" width="25%"><a href="#Basic" class="menuLink">Basic Information</a></td>
				</tr>
				<tr>
					<td class="menuCells" width="25%"><a href="#Dimensions" class="menuLink">Dimensions</a></td>
					<td class="menuCells" width="25%"><a href="#Attributes" class="menuLink">Attributes</a></td>
				</tr>
				<tr>
					<td class="menuCells" width="25%"><a href="#Groups" class="menuLink">Groups</a></td>
					<td class="menuCells" width="25%"><a href="#XSInfo" class="menuLink">Cross Sectional Information</a></td>
				</tr>
<!--				<tr>
					<td class="menuCells" width="25%"><a href="#ConceptTable" class="menuLink">Concepts</a></td>
					<td class="menuCells" width="25%"><a href="#CodeListTable" class="menuLink">Code Lists</a></td>
				</tr> -->
			</tbody>
		</table><br/>
		<br/>
	</xsl:template>

	<xsl:template name="Instructions">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="Instructions"/>
		<h2>Key Family Viewer: <xsl:value-of select="$KeyFamName"/></h2>
		<p>
		This reference provides a view of the details of the <xsl:value-of select="$KeyFamName"/> key family.  Use the links at the top of this page 		to view the details of the key family.  The content of these sections are described below.  To return to this menu, click the Return to Menu 		links at the top of each section.
		</p>
		<xsl:call-template name="InstructionsContent">
			<xsl:with-param name="Content" select="'section'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="Basic">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="Basic"/>
		<table border="2" cellpadding="4" class="section">
			<tbody>
				<tr>
					<td>
						<xsl:call-template name="BasicsContent">
							<xsl:with-param name="KFID" select="$KFID"/>
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table><br/><br/>
	</xsl:template>
	

	<xsl:template name="Dimensions">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="Dimensions"/>
		<table border="2" cellpadding="4" class="section">
			<tbody>
				<tr>
					<td>
						<xsl:call-template name="DimensionsContent">
							<xsl:with-param name="KFID" select="$KFID"/>
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table><br/><br/>
	</xsl:template>

	<xsl:template name="Attributes">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="Attributes"/>
		<table border="2" cellpadding="4" class="section">
			<tbody>
				<tr>
					<td>
						<xsl:call-template name="AttributesContent">
							<xsl:with-param name="KFID" select="$KFID"/>
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table><br/><br/>
	</xsl:template>

	<xsl:template name="Groups">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="Groups"/>
		<table border="2" cellpadding="4" class="section">
			<tbody>
				<tr>
					<td>
						<xsl:call-template name="GroupsContent">
							<xsl:with-param name="KFID" select="$KFID"/>
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table><br/><br/>
	</xsl:template>

	<xsl:template name="Cross">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="XSInfo"/>
		<table border="2" cellpadding="4" class="section">
			<tbody>
				<tr>
					<td>
						<xsl:call-template name="CrossContent">
							<xsl:with-param name="KFID" select="$KFID"/>
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table><br/><br/>
	</xsl:template>

	<xsl:template match="s:Dimension | s:TimeDimension" mode="Page">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="Dim{@conceptRef}"/>
		<table border="2" cellpadding="4" class="section">
			<tbody>
				<tr>
					<td>
						<xsl:call-template name="DimOrAttPageContent">
							<xsl:with-param name="KFID" select="$KFID"/>
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table><br/><br/>
	</xsl:template>

	<xsl:template match="s:Attribute | s:PrimaryMeasure" mode="Page">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="Att{@conceptRef}"/>
		<table border="2" cellpadding="4" class="section">
			<tbody>
				<tr>
					<td>
						<xsl:call-template name="DimOrAttPageContent">
							<xsl:with-param name="KFID" select="$KFID"/>
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table><br/><br/>
	</xsl:template>

	<xsl:template match="s:Dimension | s:TimeDimension | s:Attribute | s:PrimaryMeasure | s:CrossSectionalMeasure" mode="Codes">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:variable name="Type">
			<xsl:apply-templates select="." mode="GetType"/>
		</xsl:variable>
		<xsl:if test="$Type!='common:TimePeriodType' and $Type!='xs:string'">
			<a name="{$Type}"/>
			<table border="2" cellpadding="4" class="section">
				<tbody>
					<tr>
						<td>
							<xsl:apply-templates select="." mode="CreateTypeHTMLPage">
								<xsl:with-param name="KFID" select="$KFID"/>
							</xsl:apply-templates>
						</td>
					</tr>
				</tbody>
			</table><br/><br/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="s:Dimension | s:TimeDimension | s:Attribute | s:PrimaryMeasure | s:CrossSectionalMeasure" mode="Concepts">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="{@conceptRef}"/>
		<table border="2" cellpadding="4" class="section">
			<tbody>
				<tr>
					<td>
						<xsl:apply-templates select="." mode="CreateConceptHTMLPage">
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:apply-templates>
					</td>
				</tr>
			</tbody>
		</table><br/><br/>
	</xsl:template>

	<xsl:template match="s:Group" mode="Page">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="Grp{@id}"/>
		<table border="2" cellpadding="4" class="section">
			<tbody>
				<tr>
					<td>
						<xsl:call-template name="GroupPageContent">
							<xsl:with-param name="KFID" select="$KFID"/>
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
						</xsl:call-template>		
					</td>
				</tr>
			</tbody>
		</table><br/><br/>
	</xsl:template>

	<xsl:template match="s:CrossSectionalMeasure" mode="Page">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<a name="CSM{@conceptRef}"/>
		<table border="2" cellpadding="4" class="section">
			<tbody>
				<tr>
					<td>
						<xsl:call-template name="CrossPageContent">
							<xsl:with-param name="KFID" select="$KFID"/>
							<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
						</xsl:call-template>		
					</td>
				</tr>
			</tbody>
		</table><br/><br/>
	</xsl:template>

</xsl:stylesheet>
