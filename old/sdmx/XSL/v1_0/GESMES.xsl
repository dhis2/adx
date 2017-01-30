<?xml version="1.0"?>
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" 
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic"
version="1.0">
	<xsl:output method="text"/>
	<xsl:decimal-format name="DEIT" decimal-separator="," grouping-separator="."/>
	<xsl:decimal-format name="FR" decimal-separator="," grouping-separator=" "/>
	
	<xsl:param name="KeyFamURI">notPassed</xsl:param>
	
	<xsl:template match="/">UNA:+.? '<xsl:choose>
			<!--When the message holds data /-->
			<xsl:when test="message:GenericData">
			<xsl:variable name="KeyFamLoc">
				<xsl:choose>
					<xsl:when test="$KeyFamURI = 'notPassed' and message:GenericData/message:DataSet/@keyFamilyURI"><xsl:value-of 		select="message:GenericData/message:DataSet/@keyFamilyURI"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$KeyFamURI"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="KeyFamID">
				<xsl:value-of select="/message:GenericData/message:DataSet/generic:KeyFamilyRef"/>
			</xsl:variable>
			<xsl:variable name="KeyFamStruc" select="document($KeyFamLoc, .)/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]"/>
UNB+UNOC:3+<xsl:value-of select="message:GenericData/message:Header/message:Sender/@id"/>+<xsl:value-of select="message:GenericData/message:Header/message:Receiver/@id"/>+<xsl:value-of select="substring(message:GenericData/message:Header/message:Prepared,3,2)"/>
				<xsl:value-of select="substring(message:GenericData/message:Header/message:Prepared,6,2)"/>
				<xsl:value-of select="substring(message:GenericData/message:Header/message:Prepared,9,2)"/>:<xsl:value-of select="substring(message:GenericData/message:Header/message:Prepared,12,2)"/>
				<xsl:value-of select="substring(message:GenericData/message:Header/message:Prepared,15,2)"/>+IREF000001++SDMX-EDI<xsl:choose>
					<xsl:when test="message:GenericData/message:Header/message:Test='true'">
						<xsl:value-of select="'++++1'"/>
					</xsl:when>
				</xsl:choose>'
UNH+MREF000001+GESMES:2:1:E6'
BGM+74'
NAD+Z02+<xsl:value-of select="message:GenericData/message:Header/message:DataSetAgency"/>'
NAD+MR+<xsl:value-of select="message:GenericData/message:Header/message:Receiver/@id"/>'
NAD+MS+<xsl:value-of select="message:GenericData/message:Header/message:Sender/@id"/>'
DSI+<xsl:value-of select="message:GenericData/message:Header/message:DataSetID"/>'<!-- Changed from KeyFamilyRef JG -->
STS+3+<xsl:choose>
					<xsl:when test="message:GenericData/message:Header/message:DataSetAction='Update'">7</xsl:when>
					<xsl:when test="message:GenericData/message:Header/message:DataSetAction='Delete'">6</xsl:when>
				</xsl:choose>'
DTM+242:<xsl:value-of select="substring(message:GenericData/message:Header/message:Prepared,1,4)"/>
				<xsl:value-of select="substring(message:GenericData/message:Header/message:Prepared,6,2)"/>
				<xsl:value-of select="substring(message:GenericData/message:Header/message:Prepared,9,2)"/>
				<xsl:value-of select="substring(message:GenericData/message:Header/message:Prepared,12,2)"/>
				<xsl:value-of select="substring(message:GenericData/message:Header/message:Prepared,15,2)"/>:203'<xsl:choose>
					<xsl:when test="message:GenericData/message:Header/message:ReportingBegin">
						<xsl:choose>
							<xsl:when test="message:GenericData/message:Header/message:ReportingEnd">DTM+Z02:<xsl:value-of select="substring(message:GenericData/message:Header/message:ReportingBegin,1,4)"/>
								<xsl:value-of select="substring(message:GenericData/message:Header/message:ReportingBegin,6,2)"/>
								<xsl:value-of select="substring(message:GenericData/message:Header/message:ReportingBegin,9,2)"/>-<xsl:value-of select="substring(message:GenericData/message:Header/message:ReportingEnd,1,4)"/>
								<xsl:value-of select="substring(message:GenericData/message:Header/message:ReportingEnd,6,2)"/>
								<xsl:value-of select="substring(message:GenericData/message:Header/message:ReportingEnd,9,2)"/>:711</xsl:when>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
IDE+5+<xsl:value-of select="message:GenericData/message:DataSet/generic:KeyFamilyRef"/>'
GIS+AR3'
GIS+1:::-'<xsl:for-each select="//generic:Series">
ARR++<xsl:for-each select="generic:SeriesKey/generic:Value"><xsl:value-of select="@value"/>:</xsl:for-each>
						<xsl:variable name="Frequency" select="generic:SeriesKey/generic:Value[@concept='FREQ']/@value"/>
						<xsl:variable name="TimePeriod">
							<xsl:choose>
								<xsl:when test="$Frequency ='Q'">
									<xsl:value-of select="substring(generic:Obs/generic:Time,1,4)"/>
									<xsl:choose>
										<xsl:when test="3>=substring(generic:Obs/generic:Time,6,2)">
											<xsl:value-of select="1"/>
										</xsl:when>
										<xsl:when test="6>=substring(generic:Obs/generic:Time,6,2)">
											<xsl:value-of select="2"/>
										</xsl:when>
										<xsl:when test="9>=substring(generic:Obs/generic:Time,6,2)">
											<xsl:value-of select="3"/>
										</xsl:when>
										<xsl:when test="12>=substring(generic:Obs/generic:Time,6,2)">
											<xsl:value-of select="4"/>
										</xsl:when>
									</xsl:choose>
									<xsl:value-of select="substring(generic:Obs[last()]/generic:Time,1,4)"/>
									<xsl:choose>
										<xsl:when test="3 >=substring(generic:Obs[last()]/generic:Time,6,2)">
											<xsl:value-of select="1"/>
										</xsl:when>
										<xsl:when test="6 >= substring(generic:Obs[last()]/generic:Time,6,2)">
											<xsl:value-of select="2"/>
										</xsl:when>
										<xsl:when test="9 >= substring(generic:Obs[last()]/generic:Time,6,2)">
											<xsl:value-of select="3"/>
										</xsl:when>
										<xsl:when test="12 >= substring(generic:Obs[last()]/generic:Time,6,2)">
											<xsl:value-of select="4"/>
										</xsl:when>
									</xsl:choose>:708</xsl:when>
								<xsl:when test="$Frequency ='M'">
									<xsl:value-of select="substring(generic:Obs/generic:Time,1,4)"/>
									<xsl:value-of select="substring(generic:Obs/generic:Time,6,2)"/>
									<xsl:value-of select="substring(generic:Obs[last()]/generic:Time,1,4)"/>
									<xsl:value-of select="substring(generic:Obs[last()]/generic:Time,6,2)"/>:710</xsl:when>
								<xsl:when test="$Frequency ='A'">
									<xsl:value-of select="substring(generic:Obs/generic:Time,1,4)"/>
									<xsl:value-of select="substring(generic:Obs[last()]/generic:Time,1,4)"/>:702</xsl:when>
							</xsl:choose>
						</xsl:variable>
<xsl:value-of select="$TimePeriod"/>:<xsl:for-each select="generic:Obs">
							<xsl:variable name="ObsValue">
								<xsl:choose>
									<xsl:when test="not(generic:ObsValue/@value) or generic:ObsValue/@value='NaN'">-</xsl:when>
									<xsl:otherwise><xsl:value-of select="generic:ObsValue/@value"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$ObsValue"/><xsl:if test="generic:Attributes/generic:Value[@concept='OBS_STATUS']">:<xsl:value-of select="generic:Attributes/generic:Value[@concept='OBS_STATUS']/@value"/></xsl:if><xsl:if test="generic:Attributes/generic:Value[@concept='OBS_CONF'] or generic:Attributes/generic:Value[@concept='OBS_PRE_BREAK']">:<xsl:value-of select="generic:Attributes/generic:Value[@concept='OBS_CONF']/@value"/><xsl:if test="generic:Attributes/generic:Value[@concept='OBS_PRE_BREAK']">:<xsl:value-of select="generic:Attributes/generic:Value[@concept='OBS_PRE_BREAK']/@value"/></xsl:if></xsl:if>
							<xsl:choose>
								<xsl:when test="position() !=last()">+</xsl:when>
							</xsl:choose>
						</xsl:for-each>'</xsl:for-each>
<xsl:if test="//generic:Attributes/generic:Value[@concept != 'OBS_STATUS' and @concept != 'OBS_CONF' and @concept != 'OBS_PRE_BREAK']">
FNS+Attributes:10'</xsl:if><!-- Attributes -->
<xsl:for-each select="message:GenericData/message:DataSet/generic:Attributes">
REL+Z01+1'
ARR+0'<xsl:for-each select="generic:Value">
<xsl:variable name="AttConcept" select="@concept"/>
<xsl:choose>
	<xsl:when test="not($KeyFamStruc/structure:Components/structure:Attribute[@concept = $AttConcept]/@codelist)">
IDE+Z11+<xsl:value-of select="$AttConcept"/>'
FTX+ACM+++<xsl:value-of select="@value"/>'</xsl:when>
	<xsl:otherwise>
IDE+Z10+<xsl:value-of select="$AttConcept"/>'
CDV+<xsl:value-of select="@value"/>'</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</xsl:for-each>
<xsl:if test="//generic:Group/generic:Attributes or //generic:Series/generic:Attributes">
REL+Z01+4'</xsl:if>
<xsl:for-each select="message:GenericData/message:DataSet/generic:Group[generic:Attributes]">
ARR+<xsl:value-of select="count(generic:Series/generic:SeriesKey/generic:Value)"/>+<xsl:for-each select="generic:Series/generic:SeriesKey/generic:Value"><xsl:variable name="KeyConcept" select="@concept"/><xsl:value-of select="../../../generic:GroupKey/generic:Value[@concept = $KeyConcept]/@value"/><xsl:if test="position() !=last()">:</xsl:if></xsl:for-each>'<xsl:for-each select="generic:Attributes/generic:Value">
<xsl:variable name="AttConcept" select="@concept"/>
<xsl:choose>
	<xsl:when test="not($KeyFamStruc/structure:Components/structure:Attribute[@concept = $AttConcept]/@codelist)">
IDE+Z11+<xsl:value-of select="$AttConcept"/>'
FTX+ACM+++<xsl:value-of select="@value"/>'</xsl:when>
	<xsl:otherwise>
IDE+Z10+<xsl:value-of select="$AttConcept"/>'
CDV+<xsl:value-of select="@value"/>'</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</xsl:for-each>
<xsl:for-each select="message:GenericData/message:DataSet/generic:Series[generic:Attributes]">
ARR+<xsl:value-of select="count(generic:SeriesKey/generic:Value)"/>+<xsl:for-each select="generic:SeriesKey/generic:Value"><xsl:value-of select="@value"/><xsl:if test="position() !=last()">:</xsl:if></xsl:for-each>'<xsl:for-each select="generic:Attributes/generic:Value">
<xsl:variable name="AttConcept" select="@concept"/>
<xsl:choose>
	<xsl:when test="not($KeyFamStruc/structure:Components/structure:Attribute[@concept = $AttConcept]/@codelist)">
IDE+Z11+<xsl:value-of select="$AttConcept"/>'
FTX+ACM+++<xsl:value-of select="@value"/>'</xsl:when>
	<xsl:otherwise>
IDE+Z10+<xsl:value-of select="$AttConcept"/>'
CDV+<xsl:value-of select="@value"/>'</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</xsl:for-each>
<xsl:if test="//generic:Obs/generic:Attributes/generic:Value[@concept != 'OBS_STATUS' and @concept != 'OBS_CONF' and @concept != 'OBS_PRE_BREAK']">
REL+Z01+5'</xsl:if>
<xsl:for-each select="//generic:Obs[generic:Attributes/generic:Value[@concept != 'OBS_STATUS' and @concept != 'OBS_CONF' and @concept != 'OBS_PRE_BREAK']]">
ARR+<xsl:value-of select="count(../generic:SeriesKey/generic:Value)+2"/>+<xsl:for-each select="../generic:SeriesKey/generic:Value"><xsl:value-of select="@value"/>:</xsl:for-each>
<xsl:variable name="Frequency" select="../generic:SeriesKey/generic:Value[@concept='FREQ']/@value"/>
<xsl:variable name="TimePeriod">
	<xsl:choose>
		<xsl:when test="$Frequency ='Q'">
			<xsl:value-of select="substring(generic:Time,1,4)"/>
			<xsl:choose>
				<xsl:when test="3>=substring(generic:Time,6,2)">
					<xsl:value-of select="1"/>
				</xsl:when>
				<xsl:when test="6>=substring(generic:Time,6,2)">
					<xsl:value-of select="2"/>
				</xsl:when>
				<xsl:when test="9>=substring(generic:Time,6,2)">
					<xsl:value-of select="3"/>
				</xsl:when>
				<xsl:when test="12>=substring(generic:Time,6,2)">
					<xsl:value-of select="4"/>
				</xsl:when>
			</xsl:choose>:708</xsl:when>
		<xsl:when test="$Frequency ='M'">
			<xsl:value-of select="substring(generic:Time,1,4)"/>
			<xsl:value-of select="substring(generic:Time,6,2)"/>:710</xsl:when>
		<xsl:when test="$Frequency ='A'">
			<xsl:value-of select="substring(generic:Time,1,4)"/>:702</xsl:when>
	</xsl:choose>
</xsl:variable>
<xsl:value-of select="$TimePeriod"/>'<xsl:for-each select="generic:Attributes/generic:Value[@concept != 'OBS_STATUS' and @concept != 'OBS_CONF' and @concept != 'OBS_PRE_BREAK']">
<xsl:variable name="AttConcept" select="@concept"/>
<xsl:choose>
	<xsl:when test="not($KeyFamStruc/structure:Components/structure:Attribute[@concept = $AttConcept]/@codelist)">
IDE+Z11+<xsl:value-of select="$AttConcept"/>'
FTX+ACM+++<xsl:value-of select="@value"/>'</xsl:when>
	<xsl:otherwise>
IDE+Z10+<xsl:value-of select="$AttConcept"/>'
CDV+<xsl:value-of select="@value"/>'</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</xsl:for-each>
<xsl:variable name="SeriesCount" select="count(//generic:Series)"/>
<xsl:variable name="DataSetAttCount" select="count(//message:DataSet[generic:Attributes]) + count(//message:DataSet/generic:Attributes/generic:Value)*2"/>
<xsl:variable name="GroupAttCount" select="count(//generic:Group[generic:Attributes]) + count(//generic:Group/generic:Attributes/generic:Value)*2"/>
<xsl:variable name="SeriesAttCount" select="count(//generic:Series[generic:Attributes]) + count(//generic:Series/generic:Attributes/generic:Value)*2"/>
<xsl:variable name="ObsAttCount" select="count(//generic:Obs[generic:Attributes/generic:Value[@concept != 'OBS_STATUS' and @concept != 'OBS_CONF' and @concept != 'OBS_PRE_BREAK']]) + count(//generic:Obs/generic:Attributes/generic:Value[@concept != 'OBS_STATUS' and @concept != 'OBS_CONF' and @concept != 'OBS_PRE_BREAK'])*2"/>
<xsl:variable name="AttHeadingCount">
<xsl:choose>
	<xsl:when test="$DataSetAttCount >0 and ($GroupAttCount > 0 or $SeriesAttCount > 0) and $ObsAttCount > 0">4</xsl:when>
	<xsl:when test="$DataSetAttCount >0 and ($GroupAttCount > 0 or $SeriesAttCount > 0) and $ObsAttCount = 0">3</xsl:when>
	<xsl:when test="$DataSetAttCount >0 and ($GroupAttCount = 0 and $SeriesAttCount = 0) and $ObsAttCount > 0">3</xsl:when>
	<xsl:when test="$DataSetAttCount =0 and ($GroupAttCount > 0 or $SeriesAttCount > 0) and $ObsAttCount > 0">3</xsl:when>
	<xsl:when test="$DataSetAttCount >0 and ($GroupAttCount = 0 and $SeriesAttCount = 0) and $ObsAttCount = 0">2</xsl:when>
	<xsl:when test="$DataSetAttCount =0 and ($GroupAttCount > 0 or $SeriesAttCount > 0) and $ObsAttCount = 0">2</xsl:when>
	<xsl:when test="($GroupAttCount > 0 or $SeriesAttCount > 0) and $ObsAttCount > 0"></xsl:when>	
	<xsl:when test="$DataSetAttCount =0 and ($GroupAttCount = 0 and $SeriesAttCount = 0) and $ObsAttCount > 0">2</xsl:when>
	<xsl:when test="$DataSetAttCount =0 and ($GroupAttCount = 0 and $SeriesAttCount = 0) and $ObsAttCount = 0">0</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="OtherSegmentCount">15</xsl:variable>
UNT+<xsl:value-of select="$SeriesCount + $DataSetAttCount + $GroupAttCount + $SeriesAttCount + $ObsAttCount + $AttHeadingCount +  $OtherSegmentCount"/>+MREF000001'
UNZ+1+IREF000001'</xsl:when>

<!-- When the message is the keyfamily definition-->
		<xsl:when test="message:Structure">
UNB+UNOC:3+<xsl:value-of select="message:Structure/message:Header/message:Sender/@id"/>+<xsl:value-of select="message:Structure/message:Header/message:Receiver/@id"/>+<xsl:value-of select="substring(message:Structure/message:Header/message:Prepared,3,2)"/>
				<xsl:value-of select="substring(message:Structure/message:Header/message:Prepared,6,2)"/>
				<xsl:value-of select="substring(message:Structure/message:Header/message:Prepared,9,2)"/>:<xsl:value-of select="substring(message:Structure/message:Header/message:Prepared,12,2)"/>
				<xsl:value-of select="substring(message:Structure/message:Header/message:Prepared,15,2)"/>+IREF000001>++SDMX-EDI<xsl:choose>
					<xsl:when test="message:Structure/message:Header/message:Test='true'">
						<xsl:value-of select="'++++1'"/>
					</xsl:when>
				</xsl:choose>'

UNH+MREF000001+GESMES:2:1:E6' 
BGM+73'
NAD+Z02+<xsl:value-of select="message:Structure/message:Header/message:KeyFamilyAgency"/>'
NAD+MR+<xsl:value-of select="message:Structure/message:Header/message:Receiver/@id"/>'
NAD+MS+<xsl:value-of select="message:Structure/message:Header/message:Sender/@id"/>'<xsl:for-each select="message:Structure/message:CodeLists/structure:CodeList">
VLI+<xsl:value-of select="@id"/>+++<xsl:variable name="CodeListName"><xsl:call-template name="escape-chars"><xsl:with-param name="string" select="structure:Name"/></xsl:call-template></xsl:variable><xsl:value-of select="substring($CodeListName,1,70)"/>'<xsl:for-each select="structure:Code">
CDV+<xsl:value-of select="@value"/>'<xsl:variable name="CodeDesc"><xsl:call-template name="escape-chars"><xsl:with-param name="string" select="structure:Description"/></xsl:call-template></xsl:variable>
<xsl:variable name="FinalCodeDesc">
<xsl:choose>
	<xsl:when test="string-length($CodeDesc) &lt;= 70">
		<xsl:value-of select="$CodeDesc"/>
	</xsl:when>
	<xsl:when test="string-length($CodeDesc) &gt; 70 and string-length($CodeDesc) &lt;= 140">
		<xsl:value-of select="substring($CodeDesc,1,70)"/>:<xsl:value-of select="substring($CodeDesc,71,70)"/>
	</xsl:when>
	<xsl:when test="string-length($CodeDesc) &gt; 140 and string-length($CodeDesc) &lt;= 210">
		<xsl:value-of select="substring($CodeDesc,1,70)"/>:<xsl:value-of select="substring($CodeDesc,71,70)"/>:<xsl:value-of select="substring($CodeDesc,141,70)"/>
	</xsl:when>
	<xsl:when test="string-length($CodeDesc) &gt; 210 and string-length($CodeDesc) &lt;= 280">
		<xsl:value-of select="substring($CodeDesc,1,70)"/>:<xsl:value-of select="substring($CodeDesc,71,70)"/>:<xsl:value-of select="substring($CodeDesc,141,70)"/>:<xsl:value-of select="substring($CodeDesc,211,70)"/>
	</xsl:when>
	<xsl:when test="string-length($CodeDesc) &gt; 280 and string-length($CodeDesc) &lt;= 350">
		<xsl:value-of select="substring($CodeDesc,1,70)"/>:<xsl:value-of select="substring($CodeDesc,71,70)"/>:<xsl:value-of select="substring($CodeDesc,141,70)"/>:<xsl:value-of select="substring($CodeDesc,211,70)"/>:<xsl:value-of select="substring($CodeDesc,281,70)"/>
	</xsl:when>	
</xsl:choose>
</xsl:variable>
FTX+ACM+++<xsl:value-of select="$FinalCodeDesc"/>'</xsl:for-each>
</xsl:for-each>
UNT+<xsl:value-of select="6 + count(//structure:CodeList) + count(//structure:Code)*2"/>+MREF000001'

UNH+MREF000002+GESMES:2:1:E6' 
BGM+73'
NAD+Z02+<xsl:value-of select="message:Structure/message:Header/message:KeyFamilyAgency"/>'
NAD+MR+<xsl:value-of select="message:Structure/message:Header/message:Receiver/@id"/>'
NAD+MS+<xsl:value-of select="message:Structure/message:Header/message:Sender/@id"/>'<xsl:for-each select="message:Structure/message:Concepts/structure:Concept"><xsl:variable name="ConceptName"><xsl:call-template name="escape-chars"><xsl:with-param name="string" select="structure:Name"/></xsl:call-template></xsl:variable>
STC+<xsl:value-of select="@id"/>'
FTX+ACM+++<xsl:value-of select="substring($ConceptName,1,70)"/>'</xsl:for-each>
UNT+<xsl:value-of select="6 + count(//structure:Concept)*2"/>+MREF000002'

UNH+MREF000003+GESMES:2:1:E6' 
BGM+73'
NAD+Z02+<xsl:value-of select="message:Structure/message:Header/message:KeyFamilyAgency"/>'
NAD+MR+<xsl:value-of select="message:Structure/message:Header/message:Receiver/@id"/>'
NAD+MS+<xsl:value-of select="message:Structure/message:Header/message:Sender/@id"/>'<xsl:for-each select="message:Structure/message:KeyFamilies/structure:KeyFamily"><xsl:variable name="KeyFamName"><xsl:call-template name="escape-chars"><xsl:with-param name="string" select="structure:Name"/></xsl:call-template></xsl:variable>
ASI+<xsl:value-of select="@id"/>'<xsl:variable name="DimCount" select="count(structure:Components/structure:Dimension)"/>
FTX+ACM+++<xsl:value-of select="substring($KeyFamName,1,70)"/>'<xsl:for-each select="structure:Components/structure:Dimension ">
SCD+<xsl:choose><xsl:when test="@isFrequencyDimension='true'">13</xsl:when>
<xsl:otherwise>4</xsl:otherwise></xsl:choose>+<xsl:value-of select="@concept"/>++++:<xsl:value-of select="position()"/>'<xsl:variable name="CodeList" select="@codelist"/>
ATT+3+5+:::AN<xsl:variable name="MaxCodeLen"><xsl:for-each select="//structure:CodeList[@id = $CodeList]/structure:Code"><xsl:sort select="string-length(@value)" order="descending"/><xsl:value-of select="string-length(@value)"/>x</xsl:for-each></xsl:variable><xsl:value-of select="substring-before($MaxCodeLen,'x')"/>'
IDE+1+<xsl:value-of select="@codelist"/>'</xsl:for-each>
SCD+1+<xsl:value-of select="structure:Components/structure:TimeDimension/@concept"/>++++:<xsl:value-of select="$DimCount + 1"/>'
ATT+3+5+:::AN..35'
SCD+1+<xsl:value-of select="structure:Components/structure:Attribute[@isTimeFormat='true']/@concept"/>++++:<xsl:value-of select="$DimCount + 2"/>'
ATT+3+5+:::AN3'
IDE+1+<xsl:value-of select="structure:Components/structure:Attribute[@isTimeFormat='true']/@codelist"/>'
SCD+3+<xsl:value-of select="structure:Components/structure:PrimaryMeasure/@concept"/>++++:<xsl:value-of select="$DimCount + 3"/>'
ATT+3+5+:::AN..15'<xsl:for-each select="structure:Components/structure:Attribute[@attachmentLevel='Observation']"><xsl:variable name="Concept" select="@concept"/>
SCD+3+<xsl:value-of select="@concept"/>++++:<xsl:value-of select="position() + $DimCount + 3"/>'<xsl:variable name="CodeList" select="@codelist"/>
ATT+3+5+:::<xsl:choose>
	<xsl:when test="structure:TextFormat"><xsl:choose>
		<xsl:when test="structure:TextFormat/@TextType='AlphaNumFixed'">AN<xsl:value-of select="structure:TextFormat/@length"></xsl:value-of></xsl:when>
		<xsl:when test="structure:TextFormat/@TextType='AlphaNum'">AN..<xsl:value-of select="structure:TextFormat/@length"></xsl:value-of></xsl:when>
		<xsl:when test="structure:TextFormat/@TextType='NumFixed'">N<xsl:value-of select="structure:TextFormat/@length"></xsl:value-of></xsl:when></xsl:choose></xsl:when>
		<xsl:otherwise>AN<xsl:variable name="MaxCodeLen"><xsl:for-each select="//structure:CodeList[@id = $CodeList]/structure:Code"><xsl:sort select="string-length(@value)" order="descending"/><xsl:value-of select="string-length(@value)"/>x</xsl:for-each></xsl:variable><xsl:value-of select="substring-before($MaxCodeLen,'x')"/>'
IDE+1+<xsl:value-of select="@codelist"/></xsl:otherwise>
</xsl:choose>'
ATT+3+35+<xsl:choose><xsl:when test="@assignmentStatus='Mandatory'">2</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>:USS'
ATT+3+32+<xsl:choose><xsl:when test="@attachmentLevel='Observation'">5</xsl:when>
<xsl:when test="@attachmentLevel='Group'">9</xsl:when>
<xsl:when test="@attachmentLevel='Series'">4</xsl:when>
<xsl:when test="@attachmentLevel='Data'">1</xsl:when></xsl:choose>:ALV'<xsl:if test="@codelist !=''">
IDE+1+<xsl:value-of select="@codelist"/>'</xsl:if></xsl:for-each>
<xsl:for-each select="structure:Components/structure:Attribute[@attachmentLevel != 'Observation' and (@isTimeFormat != 'true' or not(@isTimeFormat))]"><xsl:variable name="Concept" select="@concept"/>
SCD+Z09+<xsl:value-of select="@concept"/>'<xsl:variable name="CodeList" select="@codelist"/>
ATT+3+5+:::<xsl:choose>
	<xsl:when test="structure:TextFormat"><xsl:choose>
		<xsl:when test="structure:TextFormat/@TextType='AlphaNumFixed'">AN<xsl:value-of select="structure:TextFormat/@length"></xsl:value-of></xsl:when>
		<xsl:when test="structure:TextFormat/@TextType='AlphaNum'">AN..<xsl:value-of select="structure:TextFormat/@length"></xsl:value-of></xsl:when>
		<xsl:when test="structure:TextFormat/@TextType='NumFixed'">N<xsl:value-of select="structure:TextFormat/@length"></xsl:value-of></xsl:when></xsl:choose></xsl:when>
	<xsl:otherwise>AN<xsl:variable name="MaxCodeLen"><xsl:for-each select="//structure:CodeList[@id = $CodeList]/structure:Code"><xsl:sort select="string-length(@value)" order="descending"/><xsl:value-of select="string-length(@value)"/>x</xsl:for-each></xsl:variable><xsl:value-of select="substring-before($MaxCodeLen,'x')"/>'
IDE+1+<xsl:value-of select="@codelist"/></xsl:otherwise>
</xsl:choose>'
ATT+3+35+<xsl:choose><xsl:when test="@assignmentStatus='Mandatory'">2</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>:USS'
ATT+3+32+<xsl:choose><xsl:when test="@attachmentLevel='Observation'">5</xsl:when>
<xsl:when test="@attachmentLevel='Group'">9</xsl:when>
<xsl:when test="@attachmentLevel='Series'">4</xsl:when>
<xsl:when test="@attachmentLevel='Data'">1</xsl:when></xsl:choose>:ALV'<xsl:if test="@codelist !=''">
IDE+1+<xsl:value-of select="@codelist"/>'</xsl:if></xsl:for-each>
UNT+<xsl:value-of select="8+count(structure:Components/structure:Dimension)*3+2+3+2+count(structure:Components/structure:Attribute[@attachmentLevel = 'Observation' and @codelist])*5+count(structure:Components/structure:Attribute[@attachmentLevel = 'Observation' and not(@codelist)])*4+count(structure:Components/structure:Attribute[@attachmentLevel != 'Observation' and (@isTimeFormat != 'true' or not(@isTimeFormat)) and @codelist])*5+count(structure:Components/structure:Attribute[@attachmentLevel != 'Observation' and (@isTimeFormat != 'true' or not(@isTimeFormat)) and not(@codelist)])*4"/>+MREF000003'
</xsl:for-each>
UNZ+1+IREF000001'
</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="escape-chars">
		<xsl:param name="string"/>
		<xsl:variable name="apos" select='"&apos;"'/>
		<xsl:variable name="colon" select="':'"/>
		<xsl:variable name="plus" select="'+'"/>
		<xsl:choose>
			<xsl:when test="contains($string, $apos)">
				<xsl:value-of select="substring-before($string, $apos)"/>
				<xsl:text>?'</xsl:text>
				<xsl:call-template name="escape-chars">
					<xsl:with-param name="string" select="substring-after($string, $apos)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($string, $colon)">
				<xsl:value-of select="substring-before($string, $colon)"/>
				<xsl:text>?:</xsl:text>
				<xsl:call-template name="escape-chars">
					<xsl:with-param name="string" select="substring-after($string, $colon)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($string, $plus)">
				<xsl:value-of select="substring-before($string, $plus)"/>
				<xsl:text>?+</xsl:text>
				<xsl:call-template name="escape-chars">
					<xsl:with-param name="string" select="substring-after($string, $plus)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
<!--	
	<xsl:template name="escape-chars">
		<xsl:param name="string"/>
		<xsl:variable name="apos" select='"&apos;"'/>
		<xsl:variable name="colon" select="':'"/>
		<xsl:variable name="plus" select="'+'"/>
		<xsl:variable name="string1">
			<xsl:choose>
				<xsl:when test="contains($string, $apos)">
					<xsl:value-of select="substring-before($string, $apos)"/>
					<xsl:text>?'</xsl:text>
					<xsl:call-template name="escape-chars">
						<xsl:with-param name="string" select="substring-after($string, $apos)"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$string"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="string2">
			<xsl:choose>
				<xsl:when test="contains($string1, $colon)">
					<xsl:value-of select="substring-before($string1, $colon)"/>
					<xsl:text>?:</xsl:text>
					<xsl:call-template name="escape-chars">
						<xsl:with-param name="string" select="substring-after($string1, $colon)"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$string1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($string2, $plus)">
				<xsl:value-of select="substring-before($string2, $plus)"/>
				<xsl:text>?+</xsl:text>
				<xsl:call-template name="escape-chars">
					<xsl:with-param name="string" select="substring-after($string2, $plus)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string2"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
-->
</xsl:stylesheet>
