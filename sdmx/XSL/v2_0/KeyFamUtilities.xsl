<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:m="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:c="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" 
xmlns:s="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
exclude-result-prefixes="xsl s m c">

<xsl:include href="HTMLUtilities.xslt"/>

	<xsl:template name="Head">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<head>
			<title lang="{$KeyFamName/@xml:lang}"><xsl:value-of select="$KeyFamName"/></title>
			<style type="text/css">
			body {margin-top: 25; margin-right: 25; margin-left: 25; margin-bottom: 0; background-color: white}
			table {border-color: #0000DD}
			h1 {color: #0000DD; font-size: 18pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: center; line-height: 125%}
			h2 {color: #0000DD; font-size: 12pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left}
			li {list-style-type: none; padding-left: 0px}
			p {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: normal; text-align: left}
			.menuitem {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; line-height: 125%}
			.listitem {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; text-indent: 0px; line-height: 125%}
			.thead {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 100%;  background-color: #AAAAAA; border-color: #0000DD; vertical-align: top}
			.tablehead1 {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 100%; background-color: #AAAAAA; border-color: #0000DD; text-align: center; vertical-align: top}
			.tablehead2 {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 60%; background-color: #CCCCCC; border-color: #0000DD; vertical-align: top}
			.tablehead3 {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 20%; background-color: #CCCCCC; border-color: #0000DD; vertical-align: top}
			.tablehead4 {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 10%; background-color: #CCCCCC; border-color: #0000DD; vertical-align: top}
			.field {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 20%;  background-color: #AAAAAA; border-color: #0000DD; vertical-align: top}
			.field1 {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 100%; background-color: #AAAAAA; border-color: #003366; vertical-align: top}
			.field2 {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; text-indent: 10px; width: 20%; background-color: #CCCCCC; border-color: #0000DD; vertical-align: top}
			.field3 {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 20%; background-color: #AAAAAA; border-color: #003366; vertical-align: top}
			.field4 {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 20%; background-color: #CCCCCC; border-color: #0000DD; vertical-align: top}
			.field5 {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 80%; background-color: #CCCCCC; border-color: #0000DD; vertical-align: top}
			.field6 {color: #0000DD; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 60%; background-color: #CCCCCC; border-color: #0000DD; vertical-align: top}
			.data {color: black; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: normal; text-align: left; width: 80%; background-color: white; border-color: #0000DD; vertical-align: top}
			.dataLnk {color: black; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: normal; text-align: left; background-color: white; border-color: #0000DD; vertical-align: top}
			.data1 {color: black; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: normal; text-align: left; width: 40%; background-color: white; border-color: #0000DD; vertical-align: top}
			.data2 {color: black; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: normal; text-align: left; width: 20%; background-color: white; border-color: #0000DD; vertical-align: top}
			.data3 {color: black; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: normal; text-align: left; width: 10%; background-color: white; border-color: #0000DD; vertical-align: top}
			.allowedvals {width: 100%}
			.section {width: 100%; background-color:#EEEEEE; border-color: #0000DD;}
			.menuCells {color: white; font-size: 9pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: center; background-color: #AAAAAA; border-color: #0000DD}
			.menuLink {color: #0000DD}
			.menuLink:visited {color: #0000DD}
			.menuReturn {color: #0000DD; font-size: 8pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: right}
			.menuReturn:visited {color: #0000DD}			
			</style>
		</head>
	</xsl:template>

	<xsl:template name="InstructionsContent">
		<xsl:variable name="Content" select="'page'"/>
		<p>
		<b>Instructions</b><br/><br/>
		This link will return you to this page at any time.<br/><br/>
		<b>Basic Information</b><br/><br/>
		This <xsl:value-of select="$Content"/> contains the basic information about the key family, such as ID and version, as well as any 				annotations.  From this page, you can also view the details of the key family Agency by clicking on the agency name.<br/><br/>
		<b>Dimensions</b><br/><br/>
		This <xsl:value-of select="$Content"/> contains all dimensions of the key family.  Only the basic information (name, concept ID, and allowed 		values) is displayed here.  To view more details about a particular dimension,  you can click on the dimension name, contained in the first 		row of each table.  This will take you to a more detailed display of that dimension, including; concept ID, the code list associated with it, 		allowed values, cross sectional measures and attachments, associated groups, and annotations. From this page, you can view more information 		about a concept (also applies to the main key family dimension <xsl:value-of select="$Content"/>), code list, or group by clicking on it.<br/>		<br/>
		<b>Attributes</b><br/><br/>
		This <xsl:value-of select="$Content"/> contains all attributes of the key family (including the primary measure).  Only the basic information 		(name, concept ID, allowed values/text format, assignment status, and attachment level) is displayed here.  To view more details about a 			particular attribute,  you can 	click on the attribute name, contained in the first row of each table.  This will take you to a more detailed 		display of that attribute, including; concept ID, allowed values/text format, assignment status, and attachment level, cross sectional and 		group attachments, and annotations. From this page, you can view more information about a concept (also applies to the main key family 			dimension page), code list, cross sectional measure, or group by clicking on it.<br/><br/>
		<b>Groups</b><br/><br/>
		This <xsl:value-of select="$Content"/> contains the basic information about all groups in the key family, if applicable.  Only the dimensions 		associated with the group are displayed on this page.  You can view more detailed information about a group or a dimension associated with a 		group by clicking on its name. Clicking on the group name will display more detailed information about a group, including; ID, dimensions 			associated with it, attributes attached to it, and annotations.  You can view more details of any of these dimensions or attributes by 			clicking on them.<br/><br/>
		<b>Cross Sectional Information</b><br/><br/>
		This <xsl:value-of select="$Content"/> contains the cross sectional information associated with the key family, if applicable.  Attachment 		levels for all attributes and dimensions are displayed, as well as the cross sectional measures.  You view more details about any attribute, 		dimension, or cross sectional measure by clicking on its name.  Clicking on the name of a cross sectional measure will display all detailed 		information about that measure, including concept ID, dimension, value, attached attributes, and annotations.  Again, more detail about any 		concept, dimension, or attribute can be viewed by clicking on it.
		</p>
	</xsl:template>
	
	<xsl:template name="BasicsContent">
		<!-- TODO: Fix links for single/multiple document -->
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>	
		<xsl:call-template name="GetHeader">
			<xsl:with-param name="Title">Basic Key Family Information</xsl:with-param>
		</xsl:call-template>
		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<tr>
					<td class="field" valign="top">ID</td>
					<td class="data" valign="top">
						<xsl:value-of select="$KFID"/>
					</td>
				</tr>
				<xsl:variable name="AgencyID" select="@agencyID"/>
				<xsl:variable name="AgencyName" select="@agencyID">
					<!-- TODO: Need template to get this - similar to concept name -->
				</xsl:variable>
				<xsl:variable name="Link">
					<xsl:choose>
						<xsl:when test="$isSingleDoc='true'">
							<xsl:value-of select="concat('#Ag', $AgencyID)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('Ag', $AgencyID, '.html')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<tr>
					<td class="field" valign="top">Agency</td>
					<td class="data" valign="top">
						<a href="{$Link}" class="data"><xsl:value-of select="$AgencyName"/></a>
					</td>
				</tr>
				<xsl:if test="@version">
					<tr>
						<td class="field" valign="top">Version</td>
						<td class="data" valign="top">
							<xsl:value-of select="@version"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@urn">
					<tr>
						<td class="field" valign="top">URN</td>
						<td class="data" valign="top">
							<xsl:value-of select="@urn"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@isFinal">
					<tr>
						<td class="field" valign="top">Final</td>
						<td class="data" valign="top">
							<xsl:value-of select="@isFinal"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@validFrom">
					<tr>
						<td class="field" valign="top">Valid From</td>
						<td class="data" valign="top">
							<xsl:value-of select="@validFrom"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@validTo">
					<tr>
						<td class="field" valign="top">Valid To</td>
						<td class="data" valign="top">
							<xsl:value-of select="@validTo"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="s:Description">
					<xsl:variable name="Description">
						<xsl:call-template name="GetDescription"/>
					</xsl:variable>
					<tr>
						<td class="field" valign="top">Description</td>
						<td class="data" valign="top">
							<xsl:value-of select="$Description"/>
						</td>
					</tr>
				</xsl:if>
			</tbody>
		</table><br/>
		
		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<tr>
					<th colspan="4" class="tablehead1">Dimensions</th>
				</tr>
				<tr>
					<th colspan="2"  class="tablehead2">Statistical Concept</th>
					<th class="tablehead3">Sequence</th>
					<th class="tablehead3">Representation	</th>
				</tr>
				<xsl:for-each select="s:Components/s:Dimension">
					<xsl:variable name="Concept" select="@conceptRef"/>
					<xsl:variable name="Type">
						<xsl:apply-templates mode="GetType" select="."/>
					</xsl:variable>
					<xsl:variable name="ConceptName">
						<xsl:apply-templates mode="GetName" select=".">
							<xsl:with-param name="lang" select="$lang"/>
						</xsl:apply-templates>
					</xsl:variable>
					<xsl:variable name="LinkDim">
						<xsl:choose>
							<xsl:when test="$isSingleDoc='true'">
								<xsl:value-of select="concat('#Dim', $Concept)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($Concept, '.html')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="LinkConcept">
						<xsl:choose>
							<xsl:when test="$isSingleDoc='true'">
								<xsl:value-of select="concat('#', $Concept)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($Concept, '.html')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr>
						<td class="data1">
							<a href="{$LinkDim}" class="dataLnk"><xsl:value-of select="$ConceptName"/></a>
						</td>
						<td class="data2">
							<a href="{$LinkConcept}" class="dataLnk"><xsl:value-of select="$Concept"/></a>
						</td>
						<td class="data2">
							<xsl:value-of select="position()"/>
						</td>
						<xsl:choose>
							<xsl:when test="$Type='xs:string'">
								<td class="data2">
									<xsl:value-of select="'String'"/>
								</td>
							</xsl:when>
							<xsl:when test="$Type='common:TimePeriodType'">
								<td class="data2">
									<xsl:value-of select="'Time Period'"/>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="LinkType">
									<xsl:choose>
										<xsl:when test="$isSingleDoc='true'">
											<xsl:value-of select="concat('#', $Type)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat($Type, '.html')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<td class="data2">
									<a href="{$LinkType}" class="dataLnk"><xsl:value-of select="$Type"/></a>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</xsl:for-each>
			</tbody>
		</table><br/>

		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<tr>
					<th colspan="5" class="tablehead1">Attributes</th>
				</tr>
				<tr>
					<th colspan="2" class="tablehead2">Statistical Concept</th>
					<th class="tablehead4">Attachment</th>
					<th class="tablehead4">Usage</th>
					<th class="tablehead3">Representation</th>
				</tr>
				<xsl:for-each select="s:Components/s:PrimaryMeasure | s:Components/s:Attribute">
					<xsl:variable name="Concept" select="@conceptRef"/>
					<xsl:variable name="Type">
						<xsl:apply-templates mode="GetType" select="."/>
					</xsl:variable>
					<xsl:variable name="ConceptName">
						<xsl:apply-templates mode="GetName" select=".">
							<xsl:with-param name="lang" select="$lang"/>
						</xsl:apply-templates>
					</xsl:variable>
					<xsl:variable name="LinkAtt">
						<xsl:choose>
							<xsl:when test="$isSingleDoc='true'">
								<xsl:value-of select="concat('#Att', $Concept)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($Concept, '.html')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="LinkConcept">
						<xsl:choose>
							<xsl:when test="$isSingleDoc='true'">
								<xsl:value-of select="concat('#', $Concept)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($Concept, '.html')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr>
						<td class="data1">
							<a href="{$LinkAtt}" class="dataLnk"><xsl:if test="self::s:PrimaryMeasure">Primary Measure-</xsl:if><xsl:value-of select="$ConceptName"/></a>
						</td>
						<td class="data2">
							<a href="{$LinkConcept}" class="dataLnk"><xsl:value-of select="$Concept"/></a>
						</td>
						<td class="data3">
							<xsl:value-of select="@attachmentLevel"/><xsl:if test="self::s:PrimaryMeasure">Observation</xsl:if>
						</td>
						<td class="data3">
							<xsl:value-of select="@assignmentStatus"/><xsl:if test="self::s:PrimaryMeasure">Mandatory</xsl:if>
						</td>
						<xsl:choose>
							<xsl:when test="$Type='xs:string'">
								<td class="data2">
									<xsl:value-of select="'String'"/>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="LinkType">
									<xsl:choose>
										<xsl:when test="$isSingleDoc='true'">
											<xsl:value-of select="concat('#', $Type)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat($Type, '.html')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<td class="data2">
									<a href="{$LinkType}" class="dataLnk"><xsl:value-of select="$Type"/></a>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</xsl:for-each>
			</tbody>
		</table><br/>
		<xsl:for-each select="s:Annotations/c:Annotation">
			<xsl:apply-templates select="." mode="Table"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="DimensionsContent">
		<xsl:call-template name="GetHeader">
			<xsl:with-param name="Title">Key Family Dimensions</xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="s:Components/s:Dimension">
			<xsl:apply-templates select="." mode="Overview"/>
		</xsl:for-each>
		<xsl:apply-templates select="s:Components/s:TimeDimension" mode="Overview"/>
	</xsl:template>

	<xsl:template name="DimOrAttPageContent">
		<xsl:variable name="Concept" select="@conceptRef"/>
		<xsl:variable name="Type">
			<xsl:apply-templates mode="GetType" select="."/>
		</xsl:variable>
		<xsl:variable name="ConceptName">
			<xsl:apply-templates mode="GetName" select="."/>
		</xsl:variable>
		<xsl:variable name="LinkConcept">
			<xsl:choose>
				<xsl:when test="$isSingleDoc='true'">
					<xsl:value-of select="concat('#', $Concept)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($Concept, '.html')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="self::s:Attribute">
				<xsl:call-template name="GetHeader">
					<xsl:with-param name="Title">Key Family Attribute: <xsl:value-of select="$ConceptName"/></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="self::s:PrimaryMeasure">
				<xsl:call-template name="GetHeader">
					<xsl:with-param name="Title">Key Family Attribute (Primary Measure): <xsl:value-of select="$ConceptName"/></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="GetHeader">
					<xsl:with-param name="Title">Key Family Dimension: <xsl:value-of select="$ConceptName"/></xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<tr>
					<td class="field3" valign="top">Concept ID</td>
					<td class="data" valign="top">
						<a href="{$LinkConcept}" class="dataLnk"><xsl:value-of select="$Concept"/></a>
					</td>
				</tr>
				<xsl:variable name="DimType">
					<xsl:choose>
						<xsl:when test="self::s:TimeDimension">Time</xsl:when>
						<xsl:when test="self::s:PrimaryMeasure">Primary Measure</xsl:when>
						<xsl:when test="@*[contains(name(),'is')][.='true']">
							<xsl:for-each select="@*[contains(name(),'is')][.='true']">
								<xsl:choose>
									<xsl:when test="contains(name(),'isTimeFormat')">Time Format</xsl:when>
									<xsl:when test="contains(name(),'isFrequency')">Frequency</xsl:when>
									<xsl:when test="contains(name(),'isMeasure')">Measure</xsl:when>
									<xsl:when test="contains(name(),'isEntity')">Entity</xsl:when>
									<xsl:when test="contains(name(),'isCount')">Count</xsl:when>
									<xsl:when test="contains(name(),'isIdentity')">Identity</xsl:when>
									<xsl:when test="contains(name(),'isNonObservationTime')">Non Observation Time</xsl:when>
								</xsl:choose>
								<xsl:if test="position()!=last()">, </xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>Regular</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<tr>
					<xsl:choose>
						<xsl:when test="self::s:Attribute">
							<td class="field3" valign="top">Attribute Type</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="field3" valign="top">Dimension Type</td>
						</xsl:otherwise>
					</xsl:choose>
					
					<td class="data1" valign="top">
						<xsl:value-of 	select="$DimType"/>
					</td>
				</tr>
				<tr>
					<td class="field3" valign="top">Representation Type</td>
					<xsl:choose>
						<xsl:when test="$Type='xs:string'">
							<td class="data1">
								<xsl:value-of select="'String'"/>
							</td>
						</xsl:when>
						<xsl:when test="$Type='common:TimePeriodType'">
							<td class="data1">
								<xsl:value-of select="'Time Period'"/>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="LinkType">
								<xsl:choose>
									<xsl:when test="$isSingleDoc='true'">
										<xsl:value-of select="concat('#', $Type)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($Type, '.html')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<td class="data1">
								<a href="{$LinkType}" class="dataLnk"><xsl:value-of select="$Type"/></a>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td class="field3" valign="top">Representation</td>
					<td class="data">
						<xsl:apply-templates mode="CreateTypeHTML" select="."/>
					</td>
				</tr>
				<xsl:if test="@attachmentLevel">
					<tr>
						<td class="field3" valign="top">Attachment Level</td>
						<td class="data" valign="top"><xsl:value-of select="@attachmentLevel"/></td>
					</tr>
				</xsl:if>
				<xsl:if test="@assignmentStatus">
					<tr>
						<td class="field3" valign="top">Assignment Status</td>
						<td class="data" valign="top"><xsl:value-of select="@assignmentStatus"/></td>
					</tr>
				</xsl:if>
				<xsl:if test="../s:Group[s:DimensionRef=$Concept]">
					<tr>
						<td class="field3" valign="top">Associated Groups</td>
						<td class="data" valign="top">
							<xsl:for-each select="../s:Group[s:DimensionRef=$Concept]">
								<xsl:variable name="LinkGroup">
									<xsl:choose>
										<xsl:when test="$isSingleDoc='true'">
											<xsl:value-of select="concat('#Grp', @id)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat('Grp', @id, '.html')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<a href="{$LinkGroup}" class="data"><xsl:value-of select="@id"/></a><xsl:if test="not(position()=last())"><br/></xsl:if>
							</xsl:for-each>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="s:AttachmentGroup">
					<tr>
						<td class="field3" valign="top">Group Attachments</td>
						<td class="data" valign="top">
							<xsl:for-each select="s:AttachmentGroup">
								<xsl:variable name="LinkGroup">
									<xsl:choose>
										<xsl:when test="$isSingleDoc='true'">
											<xsl:value-of select="concat('#Grp', .)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat('Grp', ., '.html')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<a href="{$LinkGroup}" class="data"><xsl:value-of select="."/></a><xsl:if test="not(position()=last())"><br/></xsl:if>
							</xsl:for-each>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="s:AttachmentMeasure">
					<tr>
						<td class="field3" valign="top">Measure Attachments</td>
						<td class="data" valign="top">
							<xsl:for-each select="s:AttachmentMeasure">
								<xsl:variable name="LinkMeas">
									<xsl:choose>
										<xsl:when test="$isSingleDoc='true'">
											<xsl:value-of select="concat('#CSM', .)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat('CSM', ., '.html')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<a href="{$LinkMeas}" class="data"><xsl:value-of select="."/></a><xsl:if test="not(position()=last())"><br/></xsl:if>
							</xsl:for-each>
						</td>
					</tr>
				</xsl:if>
				
				<xsl:if test="@*[contains(name(),'crossSectionalAttach')][.='true']">
					<tr>
						<td class="field3" valign="top">Cross Sectional Attachments</td>
						<td class="data" valign="top">
							<xsl:for-each select="@*[contains(name(),'crossSectionalAttach')][.='true']">
								<xsl:choose>
									<xsl:when test="name()='crossSectionalAttachDataSet'">Data Set</xsl:when>
									<xsl:when test="name()='crossSectionalAttachGroup'">Group</xsl:when>
									<xsl:when test="name()='crossSectionalAttachSection'">Section</xsl:when>
									<xsl:when test="name()='crossSectionalAttachObservation'">Observation</xsl:when>
								</xsl:choose>
								<xsl:if test="position()!=last()"><br/></xsl:if>
							</xsl:for-each>
						</td>
					</tr>
				</xsl:if>
				
			</tbody>
		</table><br/>
		<xsl:if test="@isMeasureDimension='true'">
			<xsl:variable name="Dim" select="."/>
			<xsl:for-each select="../s:CrossSectionalMeasure[@measureDimension=$Concept]">
				<table cellpadding="3" cellspacing="1" border="1" width="100%">
					<tbody>
						<xsl:variable name="CSConcept" select="@conceptRef"/>
						<xsl:variable name="CSConceptName">
							<xsl:apply-templates mode="GetName" select="."/>
						</xsl:variable>
						<xsl:variable name="LinkCS">
							<xsl:choose>
								<xsl:when test="$isSingleDoc='true'">
									<xsl:value-of select="concat('#CSM', $CSConcept)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('CSM', $CSConcept, '.html')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="LinkCSConcept">
							<xsl:choose>
								<xsl:when test="$isSingleDoc='true'">
									<xsl:value-of select="concat('#', $CSConcept)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat($CSConcept, '.html')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="Code" select="@code"/>
						<xsl:variable name="CodeDisplayName">
							<xsl:apply-templates select="$Dim" mode="GetValueDescription">
								<xsl:with-param name="value" select="$Code"/>
							</xsl:apply-templates>
						</xsl:variable>						
						<tr>
							<th class="field1" colspan="2">
								<a href="{$LinkCS}" class="field1">Cross Sectional Measure: <xsl:value-of select="$CSConceptName"/></a>
							</th>
						</tr>
						<tr>
							<td class="field2" valign="top">Concept ID</td>
							<td class="data" valign="top">
								<a href="{$LinkCSConcept}" class="data"><xsl:value-of select="$CSConcept"/></a>
							</td>
						</tr>
						<tr>
							<td class="field2" valign="top">Measure</td>
							<td class="data" valign="top"><xsl:value-of select="$Code"/> - <xsl:value-of select="$CodeDisplayName"/></td>
						</tr>
					</tbody>
				</table><br/>
			</xsl:for-each>
		</xsl:if>

		<xsl:for-each select="s:Annotations/c:Annotation">
			<xsl:apply-templates select="." mode="Table"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="AttributesContent">
		<xsl:call-template name="GetHeader">
			<xsl:with-param name="Title">Key Family Attributes</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates select="s:Components/s:PrimaryMeasure" mode="Overview"/>
		<xsl:for-each select="s:Components/s:Attribute">
			<xsl:apply-templates select="." mode="Overview"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="GroupsContent">
		<xsl:call-template name="GetHeader">
			<xsl:with-param name="Title">Key Family Groups</xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="s:Components/s:Group">
			<xsl:variable name="Link">
				<xsl:choose>
					<xsl:when test="$isSingleDoc='true'">
						<xsl:value-of select="concat('#Grp', @id)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('Grp', @id, '.html')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<table cellpadding="3" cellspacing="1" border="1" width="100%">
				<tbody>
					<tr>
						<th class="field1" colspan="2">
							<a href="{$Link}" class="field1"><xsl:value-of select="@id"/></a>                   
						</th>
					</tr>
					<xsl:for-each select="s:DimensionRef">
						<xsl:variable name="Concept" select="."/>
						<xsl:variable name="ConceptName">
							<xsl:apply-templates mode="GetName" select="../../s:Dimension[@conceptRef=$Concept]">
								<xsl:with-param name="lang" select="$lang"/>
							</xsl:apply-templates>
						</xsl:variable>
						<xsl:variable name="LinkDim">
							<xsl:choose>
								<xsl:when test="$isSingleDoc='true'">
									<xsl:value-of select="concat('#Dim', $Concept)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('Dim', $Concept, '.html')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<tr>
							<td class="field2">Dimension</td>
							<td class="data">
								<a href="{$LinkDim}" class="data"><xsl:value-of select="$ConceptName"/></a>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table><br/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="GroupPageContent">
		<xsl:call-template name="GetHeader">
			<xsl:with-param name="Title">Key Family Group: <xsl:value-of select="@id"/></xsl:with-param>
		</xsl:call-template>
		<xsl:variable name="GroupID" select="@id"/>
		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<tr>
					<td class="field3" valign="top">ID</td><td class="data" valign="top"><xsl:value-of select="@id"/></td>
				</tr>
				<xsl:if test="s:Description">
					<xsl:variable name="Description">
						<xsl:call-template name="GetDescription"/>
					</xsl:variable>
					<tr>
						<td class="field3" valign="top">Description</td>
						<td class="data1" valign="top">
							<xsl:value-of select="$Description"/>
						</td>                                             
					</tr>
				</xsl:if>
				<xsl:for-each select="s:DimensionRef">
					<xsl:variable name="Concept" select="."/>
					<xsl:variable name="ConceptName">
						<xsl:apply-templates mode="GetName" select="../../s:Dimension[@conceptRef=$Concept]">
							<xsl:with-param name="lang" select="$lang"/>
						</xsl:apply-templates>
					</xsl:variable>
					<xsl:variable name="LinkDim">
						<xsl:choose>
							<xsl:when test="$isSingleDoc='true'">
								<xsl:value-of select="concat('#Dim', $Concept)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('Dim', $Concept, '.html')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr>
						<td class="field3" valign="top">Dimension</td>
						<td class="data" valign="top">
							<a href="{$LinkDim}" class="data"><xsl:value-of select="$ConceptName"/></a>
						</td>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="../s:Attribute[s:AttachmentGroup=$GroupID]">
					<xsl:variable name="Concept" select="@conceptRef"/>
					<xsl:variable name="ConceptName">
						<xsl:apply-templates mode="GetName" select=".">
							<xsl:with-param name="lang" select="$lang"/>
						</xsl:apply-templates>
					</xsl:variable>
					<xsl:variable name="LinkAtt">
						<xsl:choose>
							<xsl:when test="$isSingleDoc='true'">
								<xsl:value-of select="concat('#Att', $Concept)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('Att', $Concept, '.html')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr>
						<td class="field3" valign="top">Attached Attrbiute</td>
						<td class="data" valign="top">
							<a href="{$LinkAtt}" class="dataLnk"><xsl:value-of select="$ConceptName"/></a>
						</td>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="s:AttachmentConstraintRef">
					<tr>
						<td class="field3" valign="top">Attachment Constraint</td>
						<td class="data" valign="top">
							<xsl:value-of select="."/>
						</td>
					</tr>				
				</xsl:for-each>
			</tbody>
		</table><br/>
	
		<xsl:for-each select="s:Annotations/c:Annotation">
			<xsl:apply-templates select="." mode="Table"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="CrossContent">
		<xsl:call-template name="GetHeader">
			<xsl:with-param name="Title">Key Family Cross Sectional Information</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="s:Components/*[self::s:Dimension or self::s:Attribute or self::s:TimeDimension][@crossSectionalAttachDataSet='true']">
			<table cellpadding="3" cellspacing="1" border="1" width="100%">
				<tbody>
					<tr>
						<th class="field1" colspan="2">Data Set Attachments</th>
					</tr>
					<xsl:for-each select="s:Components/*[self::s:Dimension or self::s:TimeDimension][@crossSectionalAttachDataSet='true']">
						<xsl:apply-templates select="." mode="CrossTable"/>
					</xsl:for-each>
					<xsl:for-each select="s:Components/s:Attribute[@crossSectionalAttachDataSet='true']">
						<xsl:apply-templates select="." mode="CrossTable"/>
					</xsl:for-each>
				</tbody>
			</table><br/>
		</xsl:if>
		<xsl:if test="s:Components/*[self::s:Dimension or self::s:Attribute or self::s:TimeDimension][@crossSectionalAttachGroup='true']">
			<table cellpadding="3" cellspacing="1" border="1" width="100%">
				<tbody>
					<tr>
						<th class="field1" colspan="2">Group Attachments</th>
					</tr>
					<xsl:for-each select="s:Components/*[self::s:Dimension or self::s:TimeDimension][@crossSectionalAttachGroup='true']">
						<xsl:apply-templates select="." mode="CrossTable"/>
					</xsl:for-each>
					<xsl:for-each select="s:Components/s:Attribute[@crossSectionalAttachGroup='true']">
						<xsl:apply-templates select="." mode="CrossTable"/>
					</xsl:for-each>
				</tbody>
			</table><br/>     
		</xsl:if>
		<xsl:if test="s:Components/*[self::s:Dimension or self::s:Attribute or self::s:TimeDimension][@crossSectionalAttachSection='true']">
			<table cellpadding="3" cellspacing="1" border="1" width="100%">
				<tbody>
					<tr>
						<th class="field1" colspan="2">Section Attachments</th>
					</tr>
					<xsl:for-each select="s:Components/*[self::s:Dimension or self::s:TimeDimension][@crossSectionalAttachSection='true']">
						<xsl:apply-templates select="." mode="CrossTable"/>
					</xsl:for-each>
					<xsl:for-each select="s:Components/s:Attribute[@crossSectionalAttachSection='true']">
						<xsl:apply-templates select="." mode="CrossTable"/>
					</xsl:for-each>
				</tbody>
			</table><br/>     
		</xsl:if>
		<xsl:if test="s:Components/*[self::s:Dimension or self::s:Attribute or self::s:TimeDimension][@crossSectionalAttachObservation='true']">
			<table cellpadding="3" cellspacing="1" border="1" width="100%">
				<tbody>
					<tr>
						<th class="field1" colspan="2">Observation Attachments</th>
					</tr>
					<xsl:for-each select="s:Components/*[self::s:Dimension or self::s:TimeDimension][@crossSectionalAttachObservation='true']">
						<xsl:apply-templates select="." mode="CrossTable"/>
					</xsl:for-each>
					<xsl:for-each select="s:Components/s:Attribute[@crossSectionalAttachObservation='true']">
						<xsl:apply-templates select="." mode="CrossTable"/>
					</xsl:for-each>
				</tbody>
			</table><br/>     
		</xsl:if>
		<xsl:for-each select="s:Components/s:CrossSectionalMeasure">
			<xsl:variable name="Concept" select="@conceptRef"/>
			<xsl:variable name="LinkConcept">
				<xsl:choose>
					<xsl:when test="$isSingleDoc='true'">
						<xsl:value-of select="concat('#CSM', $Concept)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('CSM', $Concept, '.html')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="Type">
				<xsl:apply-templates mode="GetType" select="."/>
			</xsl:variable>
			<xsl:variable name="Dim" select="@measureDimension"/>
			<xsl:variable name="LinkDim">
				<xsl:choose>
					<xsl:when test="$isSingleDoc='true'">
						<xsl:value-of select="concat('#Dim', $Dim)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('Dim', $Dim, '.html')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="Code" select="@code"/>
			<xsl:variable name="ConceptName">
				<xsl:apply-templates mode="GetName" select="."/>
			</xsl:variable>
			<xsl:variable name="DimConceptName">
				<xsl:apply-templates mode="GetName" select="../s:Dimension[@conceptRef=$Dim]"/>
			</xsl:variable>
			<xsl:variable name="CodeDisplayName">
				<xsl:apply-templates select="../s:Dimension[@conceptRef=$Dim]" mode="GetValueDescription">
					<xsl:with-param name="value" select="$Code"/>
				</xsl:apply-templates>
			</xsl:variable>
			<table cellpadding="3" cellspacing="1" border="1" width="100%">
				<tbody>
					<tr>
						<th class="field1" colspan="2">
							<a href="{$LinkConcept}" class="field1"><xsl:value-of select="$ConceptName"/></a>
						</th>
					</tr>
					<tr>
						<td class="field2" valign="top">Dimension</td>
						<td class="data" valign="top">
							<a href="{$LinkDim}" class="dataLnk"><xsl:value-of select="$DimConceptName"/></a>
						</td>
					</tr>
					<tr>
						<td class="field2" valign="top">Value</td>
						<td class="data" valign="top"><xsl:value-of select="$Code"/> - <xsl:value-of select="$CodeDisplayName"/></td>
					</tr>
					<tr>
						<td class="field2">Representation Type</td>
						<xsl:choose>
							<xsl:when test="$Type='xs:string'">
								<td class="data">
									<xsl:value-of select="'String'"/>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="LinkType">
									<xsl:choose>
										<xsl:when test="$isSingleDoc='true'">
											<xsl:value-of select="concat('#', $Type)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat($Type, '.html')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<td class="data">
									<a href="{$LinkType}" class="dataLnk"><xsl:value-of select="$Type"/></a>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
					<tr>
						<td class="field2">Representation</td>
						<td class="data">
							<xsl:apply-templates mode="CreateTypeHTML" select="."/>
						</td>
					</tr>
				</tbody>
			</table><br/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="CrossPageContent">
		<xsl:variable name="ConceptName">
			<xsl:apply-templates mode="GetName" select="."/>
		</xsl:variable>
		<xsl:call-template name="GetHeader">
			<xsl:with-param name="Title">Key Family Cross Sectional Measure: <xsl:value-of select="$ConceptName"/></xsl:with-param>
		</xsl:call-template>
		<xsl:variable name="Concept" select="@conceptRef"/>
		<xsl:variable name="LinkConcept">
			<xsl:choose>
				<xsl:when test="$isSingleDoc='true'">
					<xsl:value-of select="concat('#', $Concept)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($Concept, '.html')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Type">
			<xsl:apply-templates mode="GetType" select="."/>
		</xsl:variable>
		<xsl:variable name="Dim" select="@measureDimension"/>
		<xsl:variable name="LinkDim">
			<xsl:choose>
				<xsl:when test="$isSingleDoc='true'">
					<xsl:value-of select="concat('#Dim', $Dim)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('Dim', $Dim, '.html')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Code" select="@code"/>
		<xsl:variable name="DimConceptName">
			<xsl:apply-templates mode="GetName" select="../s:Dimension[@conceptRef=$Dim]"/>
		</xsl:variable>
		<xsl:variable name="CodeDisplayName">
			<xsl:apply-templates select="../s:Dimension[@conceptRef=$Dim]" mode="GetValueDescription">
				<xsl:with-param name="value" select="$Code"/>
			</xsl:apply-templates>
		</xsl:variable>
		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<tr>
					<td class="field3" valign="top">Concept ID</td>
					<td class="data" valign="top">
						<a href="{$LinkConcept}" class="data"><xsl:value-of select="$Concept"/></a>
					</td>
				</tr>
				<tr>
					<td class="field3" valign="top">Dimension</td>
					<td class="data" valign="top">
						<a href="{$LinkDim}" class="data"><xsl:value-of select="$DimConceptName"/></a>
					</td>
				</tr>
				<tr>
					<td class="field3" valign="top">Value</td>
					<td class="data" valign="top">
						<xsl:value-of select="$Code"/> - <xsl:value-of select="$CodeDisplayName"/>
					</td>
				</tr>
				<xsl:for-each select="../s:Attribute[s:AttachmentMeasure=$Concept]">
					<xsl:variable name="AttConcept" select="@conceptRef"/>
					<xsl:variable name="AttDisplayName">
						<xsl:apply-templates mode="GetName" select="."/>
					</xsl:variable>
					<xsl:variable name="LinkAtt">
						<xsl:choose>
							<xsl:when test="$isSingleDoc='true'">
								<xsl:value-of select="concat('#Att', $AttConcept)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('Att', $AttConcept, '.html')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr>
						<td class="field3" valign="top">Attached Attribute</td>
						<td class="data" valign="top">
							<a href="{$LinkAtt}" class="dataLnk"><xsl:value-of select="$AttDisplayName"/></a>
						</td>
					</tr>
				</xsl:for-each>
				<tr>
					<td class="field3">Representation Type</td>
					<xsl:choose>
						<xsl:when test="$Type='xs:string'">
							<td class="data">
								<xsl:value-of select="'String'"/>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="LinkType">
								<xsl:choose>
									<xsl:when test="$isSingleDoc='true'">
										<xsl:value-of select="concat('#', $Type)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($Type, '.html')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<td class="data">
								<a href="{$LinkType}" class="dataLnk"><xsl:value-of select="$Type"/></a>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td class="field3">Representation</td>
					<td class="data">
						<xsl:apply-templates mode="CreateTypeHTML" select="."/>
					</td>
				</tr>
			</tbody>
		</table><br/>
		<xsl:for-each select="s:Annotations/c:Annotation">
			<xsl:apply-templates select="." mode="Table"/>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template match="s:Dimension | s:Attribute | s:TimeDimension" mode="CrossTable">
		<xsl:variable name="Concept" select="@conceptRef"/>
		<xsl:variable name="ConceptName">
			<xsl:apply-templates mode="GetName" select="."/>
		</xsl:variable>
		<xsl:variable name="LinkPre">
			<xsl:choose>
				<xsl:when test="self::s:Attribute">Att</xsl:when>
				<xsl:otherwise>Dim</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Link">
			<xsl:choose>
				<xsl:when test="$isSingleDoc='true'">
					<xsl:value-of select="concat('#', $LinkPre, $Concept)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($LinkPre, $Concept, '.html')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<xsl:choose>
				<xsl:when test="self::s:Dimension or self::s:TimeDimension">
					<td class="field2" valign="top">Dimension</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="field2" valign="top">Attribute</td>
				</xsl:otherwise>
			</xsl:choose>
			<td class="data" valign="top">
				<a href="{$Link}" class="dataLnk"><xsl:value-of select="$ConceptName"/></a>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="s:Dimension | s:TimeDimension" mode="Overview">
		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<xsl:variable name="Concept" select="@conceptRef"/>
				<xsl:variable name="Type">
					<xsl:apply-templates mode="GetType" select="."/>
				</xsl:variable>
				<xsl:variable name="ConceptName">
					<xsl:apply-templates mode="GetName" select="."/>
				</xsl:variable>
				<xsl:variable name="Link">
					<xsl:choose>
						<xsl:when test="$isSingleDoc='true'">
							<xsl:value-of select="concat('#Dim', $Concept)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('Dim', $Concept, '.html')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="LinkConcept">
					<xsl:choose>
						<xsl:when test="$isSingleDoc='true'">
							<xsl:value-of select="concat('#', $Concept)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($Concept, '.html')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<tr>
					<th class="field1" colspan="2">
						<a href="{$Link}" class="field1"><xsl:if test="self::s:PrimaryMeasure">Primary Measure-</xsl:if><xsl:value-of select="$ConceptName"/></a>
					</th>
				</tr>
				<tr>
					<td class="field2">Concept ID</td>
					<td class="data"><a href="{$LinkConcept}" class="data"><xsl:value-of select="$Concept"/></a></td>
				</tr>
				<tr>
					<td class="field2">Representation Type</td>
					<xsl:choose>
						<xsl:when test="$Type='xs:string'">
							<td class="data">
								<xsl:value-of select="'String'"/>
							</td>
						</xsl:when>
						<xsl:when test="$Type='common:TimePeriodType'">
							<td class="data">
								<xsl:value-of select="'Time Period'"/>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="LinkType">
								<xsl:choose>
									<xsl:when test="$isSingleDoc='true'">
										<xsl:value-of select="concat('#', $Type)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($Type, '.html')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<td class="data">
								<a href="{$LinkType}" class="dataLnk"><xsl:value-of select="$Type"/></a>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td class="field2">Representation</td>
					<td class="data">
						<xsl:apply-templates mode="CreateTypeHTML" select="."/>
					</td>
				</tr>
			</tbody>
		</table><br/>	
	</xsl:template>

	<xsl:template match="s:Attribute | s:PrimaryMeasure" mode="Overview">
		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<xsl:variable name="Concept" select="@conceptRef"/>
				<xsl:variable name="Type">
					<xsl:apply-templates mode="GetType" select="."/>
				</xsl:variable>
				<xsl:variable name="ConceptName">
					<xsl:apply-templates mode="GetName" select=".">
						<xsl:with-param name="lang" select="$lang"/>
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:variable name="Link">
					<xsl:choose>
						<xsl:when test="$isSingleDoc='true'">
							<xsl:value-of select="concat('#Att', $Concept)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('Att', $Concept, '.html')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="LinkConcept">
					<xsl:choose>
						<xsl:when test="$isSingleDoc='true'">
							<xsl:value-of select="concat('#', $Concept)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($Concept, '.html')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<tr>
					<th class="field1" colspan="2">
						<a href="{$Link}" class="field1"><xsl:value-of select="$ConceptName"/></a>
					</th>
				</tr>
				<tr>
					<td class="field2">Concept ID</td>
					<td class="data"><a href="{$LinkConcept}" class="dataLnk"><xsl:value-of select="$Concept"/></a></td>
				</tr>
				<tr>
					<td class="field2">Representation Type</td>
					<xsl:choose>
						<xsl:when test="$Type='xs:string'">
							<td class="data">
								<xsl:value-of select="'String'"/>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="LinkType">
								<xsl:choose>
									<xsl:when test="$isSingleDoc='true'">
										<xsl:value-of select="concat('#', $Type)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($Type, '.html')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<td class="data">
								<a href="{$LinkType}" class="dataLnk"><xsl:value-of select="$Type"/></a>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td class="field2">Representation</td>
					<td class="data">
						<xsl:apply-templates mode="CreateTypeHTML" select="."/>
					</td>
				</tr>
				<xsl:if test="self::s:Attribute">
					<tr>
						<td class="field2">Attachment Level</td>
						<td class="data">
							<xsl:value-of select="@attachmentLevel"/>
						</td>
					</tr>
					<tr>
						<td class="field2">Assignment Status</td>
						<td class="data">
							<xsl:value-of select="@assignmentStatus"/>
						</td>
					</tr>
				</xsl:if>
			</tbody>
		</table><br/>
	</xsl:template>

	<xsl:template match="s:Code" mode="Annotations">
		<xsl:param name="KFID"/>
		<xsl:choose>
			<xsl:when test="$isSingleDoc='true'">
				<xsl:call-template name="CodeAnnotations"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="KeyFam" select="../../m:KeyFamilies/s:KeyFamily[@id=$KFID]"/>
				<xsl:variable name="KeyFamNamePos">
					<xsl:choose>
						<xsl:when test="$lang='notPassed' or not($KeyFam/s:Name[@xml:lang=$lang])">
							<xsl:value-of select="position()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="position()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="KeyFamName" select="$KeyFam/s:Name[position() = $KeyFamNamePos]"/>
				<xsl:document href="{$KFID}/{../@id}{@value}Ann.html" method="html" version="4.0" indent="yes">
					<xsl:call-template name="Head">
						<xsl:with-param name="KFID" select="$KFID"/>
						<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
					</xsl:call-template>
					<body>
						<xsl:call-template name="CodeAnnotations"/>
					</body>
				</xsl:document>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="CodeAnnotations">
		<xsl:for-each select="s:Annotations/c:Annotation">
			<xsl:apply-templates mode="Table" select="."/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c:Annotation" mode="Table">
		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<tr>
					<th class="tablehead1" colspan="2">Annotation</th>
				</tr>
				<xsl:if test="c:AnnotationTitle">
					<tr>
						<td class="field2" valign="top">Title</td>
						<td class="data" valign="top">
							<xsl:value-of select="c:AnnotationTitle"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="c:AnnotationType">
					<tr>
						<td class="field2" valign="top">Type</td>
						<td class="data" valign="top">
							<xsl:value-of select="c:AnnotationType"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="c:AnnotationURL">
					<tr>
						<td class="field2" valign="top">URL</td>
						<td class="data" valign="top">
							<a href="{c:AnnotationURL}" target="newwindow"><xsl:value-of select="c:AnnotationURL"/></a>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="c:AnnotationText">
					<xsl:variable name="Text">
						<xsl:choose>
							<xsl:when test="$lang='notPassed' or not(c:AnnotationText[@xml:lang=$lang])">
								<xsl:value-of select="c:AnnotationText[1]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="c:AnnotationText[@xml:lang=$lang]"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr>
						<td class="field2" valign="top">Text</td>
						<td class="data" valign="top">
							<xsl:value-of select="$Text"/>
						</td>
					</tr>
				</xsl:if>                          
			</tbody>
		</table><br/>
	</xsl:template>
	
	<xsl:template name="GetDescription">
		<xsl:choose>
			<xsl:when test="$lang='notPassed' or not(s:Description[@xml:lang=$lang])">
				<xsl:value-of select="s:Description[1]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="s:Description[@xml:lang=$lang]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="GetHeader">
		<xsl:param name="Title"/>
		<xsl:choose>
			<xsl:when test="$isSingleDoc='true'">
				<table width="100%">
					<tbody>
						<tr>
							<td><h2><xsl:value-of select="$Title"/></h2></td>
							<td align="right" valign="top"><a class="menuReturn" href="#Menu">^Return to Menu^</a></td>
						</tr>
					</tbody>
				</table><br/>
			</xsl:when>
			<xsl:otherwise><h2><xsl:value-of select="$Title"/></h2></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>