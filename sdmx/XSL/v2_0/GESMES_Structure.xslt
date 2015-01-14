<?xml version="1.0"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/message" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/structure" 
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v2_0/generic"
version="1.0">
	<xsl:output method="text"/>
	
	<xsl:template match="message:Structure">
		<xsl:variable name="agency">
			<xsl:choose>
				<xsl:when test="message:Header/message:KeyFamilyAgency">
					<xsl:value-of select="message:Header/message:KeyFamilyAgency"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="message:CodeLists/structure:CodeList/@agencyID"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
UNH+MREF000001+GESMES:2:1:E6' 
BGM+73'
NAD+Z02+<xsl:value-of select="$agency"/>'
NAD+MR+<xsl:choose><xsl:when test="message:Structure/message:Header/message:Receiver/@id"><xsl:value-of select="message:Header/message:Receiver/@id"/></xsl:when><xsl:otherwise>SYSTEM</xsl:otherwise></xsl:choose>'
NAD+MS+<xsl:value-of select="message:Header/message:Sender/@id"/>'<xsl:apply-templates select="message:CodeLists | message:Concepts | message:KeyFamilies" mode="output-structure"/>
		<xsl:variable name="OtherSegmentCount" select="6"/>
		<xsl:variable name="CodeListCount" select="count(message:CodeLists/structure:CodeList) + count(message:CodeLists/structure:CodeList/structure:Code)*2"/>
		<xsl:variable name="LongCodeCount">
			<xsl:call-template name="GetLongCodeCount">
				<xsl:with-param name="iterations" select="count(message:CodeLists/structure:CodeList/structure:Code[string-length(structure:Description[1]) > 350])"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ConceptCount" select="count(message:Concepts//structure:Concept)*2"/>
		<xsl:variable name="LongConceptCount">
			<xsl:call-template name="GetLongConceptCount">
				<xsl:with-param name="iterations" select="count(message:Concepts//structure:Concept[string-length(structure:Name[1]) > 350])"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="LongKeyFamNameCount">
			<xsl:call-template name="GetLongKeyFamNameCount">
				<xsl:with-param name="iterations" select="count(message:KeyFamilies/structure:KeyFamily[string-length(structure:Name[1]) > 350])"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="KeyFamCount" select="count(message:KeyFamilies/structure:KeyFamily)*8+count(message:KeyFamilies/structure:KeyFamily/structure:Components/structure:Dimension)*3+count(message:KeyFamilies/structure:KeyFamily/structure:Components/structure:Attribute[(@isTimeFormat != 'true' or not(@isTimeFormat)) and @codelist])*5+count(message:KeyFamilies/structure:KeyFamily/structure:Components/structure:Attribute[(@isTimeFormat != 'true' or not(@isTimeFormat)) and not(@codelist)])*4"/>
UNT+<xsl:value-of select="$OtherSegmentCount + $CodeListCount + $LongCodeCount + $ConceptCount + $LongConceptCount + $KeyFamCount + $LongKeyFamNameCount"/>+MREF000001'</xsl:template>
	
	<xsl:template match="message:CodeLists" mode="output-structure">
		<xsl:for-each select="structure:CodeList">
			<xsl:variable name="CodeListName">
				<xsl:call-template name="escape-chars">
					<xsl:with-param name="string" select="structure:Name"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="CodeListNameTrunc" select="substring($CodeListName,1,70)"/>
VLI+<xsl:value-of select="@id"/>+++<xsl:value-of select="$CodeListNameTrunc"/>'<xsl:for-each select="structure:Code">
			<xsl:variable name="CodeDesc">
				<xsl:call-template name="escape-chars">
					<xsl:with-param name="string" select="structure:Description"/>
				</xsl:call-template>
			</xsl:variable>
CDV+<xsl:value-of select="@value"/>'
FTX+ACM+++<xsl:call-template name="break-free-text"><xsl:with-param name="free-text" select="$CodeDesc"/></xsl:call-template></xsl:for-each>
		</xsl:for-each>	
	</xsl:template>
	
	<xsl:template match="message:Concepts" mode="output-structure">
		<xsl:for-each select="//structure:Concept">
			<xsl:variable name="ConceptName">
				<xsl:call-template name="escape-chars">
					<xsl:with-param name="string" select="structure:Name"/>
				</xsl:call-template>
			</xsl:variable>
STC+<xsl:value-of select="@id"/>'
FTX+ACM+++<xsl:call-template name="break-free-text"><xsl:with-param name="free-text" select="$ConceptName"/></xsl:call-template></xsl:for-each>
	</xsl:template>
	
	<xsl:template match="message:KeyFamilies" mode="output-structure">
		<xsl:for-each select="structure:KeyFamily">
			<xsl:variable name="KeyFamName">
				<xsl:call-template name="escape-chars">
					<xsl:with-param name="string" select="structure:Name"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="DimCount" select="count(structure:Components/structure:Dimension)"/>
ASI+<xsl:value-of select="@id"/>'
FTX+ACM+++<xsl:call-template name="break-free-text"><xsl:with-param name="free-text" select="$KeyFamName"/></xsl:call-template><xsl:for-each select="structure:Components/structure:Dimension ">
SCD+<xsl:choose><xsl:when test="@isFrequencyDimension='true'">13</xsl:when>
<xsl:otherwise>4</xsl:otherwise></xsl:choose>+<xsl:value-of select="@conceptRef"/>++++:<xsl:value-of select="position()"/>'<xsl:variable name="CodeList" select="@codelist"/>
ATT+3+5+:::AN<xsl:variable name="MaxCodeLen"><xsl:for-each select="//structure:CodeList[@id = $CodeList]/structure:Code"><xsl:sort select="string-length(@value)" order="descending"/><xsl:value-of select="string-length(@value)"/>x</xsl:for-each></xsl:variable><xsl:value-of select="substring-before($MaxCodeLen,'x')"/>'
IDE+1+<xsl:value-of select="@codelist"/>'</xsl:for-each>
SCD+1+TIME_PERIOD++++:<xsl:value-of select="$DimCount + 1"/>'
ATT+3+5+:::AN..35'
SCD+1+TIME_FORMAT++++:<xsl:value-of select="$DimCount + 2"/>'
ATT+3+5+:::AN3'
SCD+3+<xsl:value-of select="structure:Components/structure:PrimaryMeasure/@conceptRef"/>++++:<xsl:value-of select="$DimCount + 3"/>'
ATT+3+5+:::AN..15'<xsl:for-each select="structure:Components/structure:Attribute[@attachmentLevel='Observation']"><xsl:variable name="Concept" select="@conceptRef"/>
SCD+3+<xsl:value-of select="@conceptRef"/>++++:<xsl:value-of select="position() + $DimCount + 3"/>'<xsl:variable name="CodeList" select="@codelist"/>
ATT+3+5+:::<xsl:choose>
	<xsl:when test="structure:TextFormat"><xsl:choose>
		<xsl:when test="structure:TextFormat/@maxLength and structure:TextFormat/@minLength and structure:TextFormat/@maxLength=structure:TextFormat/@minLength">AN<xsl:value-of select="structure:TextFormat/@maxLength"></xsl:value-of></xsl:when>
		<xsl:when test="structure:TextFormat/@maxLength">AN..<xsl:value-of select="structure:TextFormat/@maxLength"></xsl:value-of></xsl:when>
		<xsl:otherwise>AN..350</xsl:otherwise></xsl:choose></xsl:when>
		<xsl:otherwise>AN<xsl:variable name="MaxCodeLen"><xsl:for-each select="//structure:CodeList[@id = $CodeList]/structure:Code"><xsl:sort select="string-length(@value)" order="descending"/><xsl:value-of select="string-length(@value)"/>x</xsl:for-each></xsl:variable><xsl:value-of select="substring-before($MaxCodeLen,'x')"/>
</xsl:otherwise>
</xsl:choose>'
ATT+3+35+<xsl:choose><xsl:when test="@assignmentStatus='Mandatory'">2</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>:USS'
ATT+3+32+5:ALV'<xsl:if test="@codelist !=''">
IDE+1+<xsl:value-of select="@codelist"/>'</xsl:if></xsl:for-each>
<xsl:for-each select="structure:Components/structure:Attribute[@attachmentLevel != 'Observation' and (@isTimeFormat != 'true' or not(@isTimeFormat))]"><xsl:variable name="Concept" select="@conceptRef"/>
SCD+Z09+<xsl:value-of select="@conceptRef"/>'<xsl:variable name="CodeList" select="@codelist"/>
ATT+3+5+:::<xsl:choose>
	<xsl:when test="structure:TextFormat"><xsl:choose>
		<xsl:when test="structure:TextFormat/@maxLength and structure:TextFormat/@minLength and structure:TextFormat/@maxLength=structure:TextFormat/@minLength">AN<xsl:value-of select="structure:TextFormat/@maxLength"></xsl:value-of></xsl:when>
		<xsl:when test="structure:TextFormat/@maxLength">AN..<xsl:value-of select="structure:TextFormat/@maxLength"></xsl:value-of></xsl:when>
		<xsl:otherwise>AN..350</xsl:otherwise></xsl:choose></xsl:when>
	<xsl:otherwise>AN<xsl:variable name="MaxCodeLen"><xsl:for-each select="//structure:CodeList[@id = $CodeList]/structure:Code"><xsl:sort select="string-length(@value)" order="descending"/><xsl:value-of select="string-length(@value)"/>x</xsl:for-each></xsl:variable><xsl:value-of select="substring-before($MaxCodeLen,'x')"/>
</xsl:otherwise>
</xsl:choose>'
ATT+3+35+<xsl:choose><xsl:when test="@assignmentStatus='Mandatory'">2</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>:USS'
ATT+3+32+<xsl:choose><xsl:when test="@attachmentLevel='Observation'">5</xsl:when>
<xsl:when test="@attachmentLevel='Group'">9</xsl:when>
<xsl:when test="@attachmentLevel='Series'">4</xsl:when>
<xsl:when test="@attachmentLevel='DataSet'">1</xsl:when></xsl:choose>:ALV'<xsl:if test="@codelist !=''">
IDE+1+<xsl:value-of select="@codelist"/>'</xsl:if></xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="GetLongCodeCount">
		<xsl:param name="i">1</xsl:param>
		<xsl:param name="value">0</xsl:param>
		<xsl:param name="iterations">0</xsl:param>
 	 	<xsl:choose>
		  <xsl:when test="$iterations >= $i">
		    <xsl:variable name="valueString">
		    	<xsl:for-each select="//structure:Code[string-length(structure:Description[1])>350]">
		    		<xsl:if test="position() = $i"><xsl:value-of select="structure:Description[1]"/></xsl:if>
		    	</xsl:for-each>
		    </xsl:variable>
		    <xsl:variable name="new-seg-count" select="floor(string-length($valueString) div 350)"/>
		    <xsl:call-template name="GetLongCodeCount">
		      <xsl:with-param name="i" select="$i + 1"/>
		      <xsl:with-param name="value" select="$value + $new-seg-count"/>
		      <xsl:with-param name="iterations" select="$iterations"/>
		    </xsl:call-template>
		  </xsl:when>
		  <xsl:otherwise>
		   <xsl:value-of select="$value"/>
		  </xsl:otherwise>
  		</xsl:choose>
	</xsl:template>

	<xsl:template name="GetLongConceptCount">
		<xsl:param name="i">1</xsl:param>
		<xsl:param name="value">0</xsl:param>
		<xsl:param name="iterations">0</xsl:param>
 	 	<xsl:choose>
		  <xsl:when test="$iterations >= $i">
		    <xsl:variable name="valueString">
		    	<xsl:for-each select="//structure:Concept[string-length(structure:Name[1])>350]">
		    		<xsl:if test="position() = $i"><xsl:value-of select="structure:Name[1]"/></xsl:if>
		    	</xsl:for-each>
		    </xsl:variable>
		    <xsl:variable name="new-seg-count" select="floor(string-length($valueString) div 350)"/>
		    <xsl:call-template name="GetLongConceptCount">
		      <xsl:with-param name="i" select="$i + 1"/>
		      <xsl:with-param name="value" select="$value + $new-seg-count"/>
		      <xsl:with-param name="iterations" select="$iterations"/>
		    </xsl:call-template>
		  </xsl:when>
		  <xsl:otherwise>
		   <xsl:value-of select="$value"/>
		  </xsl:otherwise>
  		</xsl:choose>
	</xsl:template>

	<xsl:template name="GetLongKeyFamNameCount">
		<xsl:param name="i">1</xsl:param>
		<xsl:param name="value">0</xsl:param>
		<xsl:param name="iterations">0</xsl:param>
 	 	<xsl:choose>
		  <xsl:when test="$iterations >= $i">
		    <xsl:variable name="valueString">
		    	<xsl:for-each select="//structure:KeyFamily[string-length(structure:Name[1])>350]">
		    		<xsl:if test="position() = $i"><xsl:value-of select="structure:Name[1]"/></xsl:if>
		    	</xsl:for-each>
		    </xsl:variable>
		    <xsl:variable name="new-seg-count" select="floor(string-length($valueString) div 350)"/>
		    <xsl:call-template name="GetLongKeyFamNameCount">
		      <xsl:with-param name="i" select="$i + 1"/>
		      <xsl:with-param name="value" select="$value + $new-seg-count"/>
		      <xsl:with-param name="iterations" select="$iterations"/>
		    </xsl:call-template>
		  </xsl:when>
		  <xsl:otherwise>
		   <xsl:value-of select="$value"/>
		  </xsl:otherwise>
  		</xsl:choose>
	</xsl:template>
		
</xsl:stylesheet>
