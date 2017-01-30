<?xml version="1.0"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/common" 
xmlns:m="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:s="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:exslt="http://exslt.org/common" 
extension-element-prefixes="exslt"
exclude-result-prefixes="s m" 
version="1.0">

	<!-- Global Variables for URNs -->
	<xsl:variable name="conceptPreURN" select="'urn:sdmx:org.sdmx.infomodel.conceptscheme.Concept='"/>
	<xsl:variable name="codelistPreURN" select="'urn:sdmx:org.sdmx.infomodel.codelist.CodeList='"/>
	
	<!-- Keys For Concepts -->
	<xsl:key name="ConceptKey0" match="/m:Structure/m:Concepts/s:ConceptScheme/s:Concept" use="concat(@urn, 'v', @version)"/>
	<xsl:key name="ConceptKey1" match="/m:Structure/m:Concepts/s:ConceptScheme/s:Concept" use="@urn"/>
	<xsl:key name="ConceptKey2" match="/m:Structure/m:Concepts/s:ConceptScheme/s:Concept" use="concat('urn:sdmx:org.sdmx.infomodel.conceptscheme.Concept=', ../@agencyID, ':', ../@id, '.', @id, 'v', @version)"/>
	<xsl:key name="ConceptKey3" match="/m:Structure/m:Concepts/s:ConceptScheme/s:Concept" use="concat('urn:sdmx:org.sdmx.infomodel.conceptscheme.Concept=', ../@agencyID, ':', ../@id, '.', @id)"/>	
	<xsl:key name="ConceptKey4" match="/m:Structure/m:Concepts/s:ConceptScheme/s:Concept" use="concat('urn:sdmx:org.sdmx.infomodel.conceptscheme.Concept=', 'SDMX:', ../@id, '.', @id, 'v', @version)"/>
	<xsl:key name="ConceptKey5" match="/m:Structure/m:Concepts/s:ConceptScheme/s:Concept" use="concat('urn:sdmx:org.sdmx.infomodel.conceptscheme.Concept=', 'SDMX:', ../@id, '.', @id)"/>
	<xsl:key name="ConceptKey6" match="/m:Structure/m:Concepts//s:Concept" use="concat(@agencyID | ../@agencyID, '::', @id, '::', @version)"/>
	<xsl:key name="ConceptKey7" match="/m:Structure/m:Concepts//s:Concept" use="concat(@agencyID | ../@agencyID, '::', @id)"/>	
	<xsl:key name="ConceptKey8" match="/m:Structure/m:Concepts//s:Concept" use="concat(@id, '::', @version)"/>
	<xsl:key name="ConceptKey9" match="/m:Structure/m:Concepts//s:Concept" use="@id"/>

	<!-- Keys For Codelists -->
	<xsl:key name="CodeListKey0" match="/m:Structure/m:CodeLists/s:CodeList" use="concat(@urn, 'v', @version)"/>
	<xsl:key name="CodeListKey1" match="/m:Structure/m:CodeLists/s:CodeList" use="@urn"/>	
	<xsl:key name="CodeListKey2" match="/m:Structure/m:CodeLists/s:CodeList" use="concat('urn:sdmx:org.sdmx.infomodel.codelist.CodeList=', @agencyID, ':', @id, 'v', @version)"/>
	<xsl:key name="CodeListKey3" match="/m:Structure/m:CodeLists/s:CodeList" use="concat('urn:sdmx:org.sdmx.infomodel.codelist.CodeList=', @agencyID, ':', @id)"/>
	<xsl:key name="CodeListKey4" match="/m:Structure/m:CodeLists/s:CodeList" use="concat('urn:sdmx:org.sdmx.infomodel.codelist.CodeList=', 'SDMX:', @id, 'v', @version)"/>
	<xsl:key name="CodeListKey5" match="/m:Structure/m:CodeLists/s:CodeList" use="concat('urn:sdmx:org.sdmx.infomodel.codelist.CodeList=', 'SDMX:', @id)"/>
	
	<xsl:template name="GetConceptKey">
		<xsl:param name="search"/>
		<xsl:choose>
			<xsl:when test="key('ConceptKey0', $search)">ConceptKey0</xsl:when>
			<xsl:when test="key('ConceptKey1', $search)">ConceptKey1</xsl:when>
			<xsl:when test="key('ConceptKey2', $search)">ConceptKey2</xsl:when>
			<xsl:when test="key('ConceptKey3', $search)">ConceptKey3</xsl:when>
			<xsl:when test="key('ConceptKey4', $search)">ConceptKey4</xsl:when>
			<xsl:when test="key('ConceptKey5', $search)">ConceptKey5</xsl:when>
			<xsl:when test="key('ConceptKey6', $search)">ConceptKey6</xsl:when>
			<xsl:when test="key('ConceptKey7', $search)">ConceptKey7</xsl:when>
			<xsl:when test="key('ConceptKey8', $search)">ConceptKey8</xsl:when>
			<xsl:when test="key('ConceptKey9', $search)">ConceptKey9</xsl:when>			
			<xsl:otherwise>ConceptKey0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="GetCodelistKey">
		<xsl:param name="search"/>
		<xsl:choose>
			<xsl:when test="key('CodeListKey0', $search)">CodeListKey0</xsl:when>
			<xsl:when test="key('CodeListKey1', $search)">CodeListKey1</xsl:when>
			<xsl:when test="key('CodeListKey2', $search)">CodeListKey2</xsl:when>
			<xsl:when test="key('CodeListKey3', $search)">CodeListKey3</xsl:when>
			<xsl:when test="key('CodeListKey4', $search)">CodeListKey4</xsl:when>
			<xsl:when test="key('CodeListKey5', $search)">CodeListKey5</xsl:when>
			<xsl:otherwise>CodeListKey0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template mode="GetConceptKeyValue" match="s:Attribute | s:Dimension | s:PrimaryMeasure | s:CrossSectionalMeasure | s:TimeDimension">
		<xsl:choose>
			<xsl:when test="@conceptSchemeRef">
				<xsl:variable name="Agency">
					<xsl:choose>
						<xsl:when test="@conceptSchemeAgency"><xsl:value-of select="@conceptSchemeAgency"/></xsl:when>
						<xsl:otherwise>SDMX</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="Version">
					<xsl:if test="@conceptVersion"><xsl:value-of select="concat('v', @conceptVersion)"/></xsl:if>
				</xsl:variable>
				<xsl:value-of select="concat($conceptPreURN, $Agency, ':', @conceptSchemeRef, '.', @conceptRef, $Version)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Version">
					<xsl:if test="@conceptVersion"><xsl:value-of select="concat('::', @conceptVersion)"/></xsl:if>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="@conceptAgency">
						<xsl:value-of select="concat(@conceptAgency, '::', @conceptRef, $Version)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(@conceptRef, $Version)"/>							
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
	<xsl:template mode="GetCodelistKeyValue" match="s:Concept | s:Attribute | s:Dimension | s:PrimaryMeasure | s:CrossSectionalMeasure | s:TimeDimension">
		<xsl:variable name="Agency">
			<xsl:choose>
				<xsl:when test="@codelistAgency"><xsl:value-of select="@codelistAgency"/></xsl:when>
				<xsl:otherwise>SDMX</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Version">
			<xsl:if test="@codelistVersion"><xsl:value-of select="concat('v', @codelistVersion)"/></xsl:if>
		</xsl:variable>
		<xsl:value-of select="concat($codelistPreURN, $Agency, ':', @codelist, $Version)"/>
	</xsl:template>
		
</xsl:stylesheet>
