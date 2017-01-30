<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" version="1.0">
	<xsl:output method="text"/>
		
	<xsl:param name="KeyFamURI">notPassed</xsl:param>
	
	<xsl:template match="message:GenericData">
		<xsl:variable name="KeyFamLoc">
			<xsl:choose>
				<xsl:when test="$KeyFamURI = 'notPassed' and message:GenericData/message:DataSet/@keyFamilyURI">
					<xsl:value-of select="message:DataSet/@keyFamilyURI"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$KeyFamURI"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="KeyFamID">
			<xsl:value-of select="message:DataSet/generic:KeyFamilyRef"/>
		</xsl:variable>
		<xsl:variable name="KeyFamStruct" select="document($KeyFamLoc, .)/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]"/>
		<xsl:variable name="FreqDim" select="$KeyFamStruct/structure:Components/structure:Dimension[@isFrequencyDimension='true']/@concept"/>
		<xsl:apply-templates select="message:Header" mode="create-header"/>
		<xsl:for-each select="message:DataSet//generic:Series">
			<xsl:apply-templates select="." mode="create-arr">
				<xsl:with-param name="freq-dim" select="$FreqDim"/>
			</xsl:apply-templates>
		</xsl:for-each>
		<xsl:if test="//generic:Attributes/generic:Value[@concept != 'OBS_STATUS' and @concept != 'OBS_CONF' and @concept != 'OBS_PRE_BREAK']">
FNS+Attributes:10'<xsl:apply-templates select="message:DataSet/generic:Attributes" mode="output-atts">
				<xsl:with-param name="KeyFamStruct" select="$KeyFamStruct"/>
			</xsl:apply-templates>
			<xsl:if test="message:DataSet/generic:Group/generic:Attributes or message:DataSet//generic:Series/generic:Attributes">
REL+Z01+4'</xsl:if>
			<xsl:for-each select="message:DataSet/generic:Group/generic:Attributes">
				<xsl:apply-templates select="." mode="output-atts">
					<xsl:with-param name="KeyFamStruct" select="$KeyFamStruct"/>
				</xsl:apply-templates>
			</xsl:for-each>
			<xsl:for-each select="message:DataSet//generic:Series/generic:Attributes">
				<xsl:apply-templates select="." mode="output-atts">
					<xsl:with-param name="KeyFamStruct" select="$KeyFamStruct"/>
				</xsl:apply-templates>
			</xsl:for-each>
			<xsl:if test="message:DataSet//generic:Series/generic:Obs/generic:Attributes/generic:Value[@concept != 'OBS_STATUS' and @concept != 'OBS_CONF' and @concept != 'OBS_PRE_BREAK']">
REL+Z01+5'<xsl:for-each select="message:DataSet//generic:Series/generic:Obs/generic:Attributes[generic:Value[@concept!='OBS_STATUS' and @concept!='OBS_CONF' and @concept!='OBS_PRE_BREAK']]">
					<xsl:apply-templates select="." mode="output-atts">
						<xsl:with-param name="KeyFamStruct" select="$KeyFamStruct"/>
					</xsl:apply-templates>
				</xsl:for-each>				
			</xsl:if>
		</xsl:if>
		<xsl:call-template name="endMessage">
			<xsl:with-param name="freq-dim" select="$FreqDim"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="message:Header" mode="create-header">
		<xsl:variable name="agency">
			<xsl:choose>
				<xsl:when test="message:DataSetAgency">
					<xsl:value-of select="message:DataSetAgency"/>
				</xsl:when>
				<xsl:when test="/message:GenericData/message:DataSet/@dataProviderID">
					<xsl:value-of select="/message:GenericData/message:DataSet/@dataProviderID"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="message:Sender/@id"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
UNH+MREF000001+GESMES:2:1:E6'
BGM+74'
NAD+Z02+<xsl:value-of select="$agency"/>'
NAD+MR+<xsl:choose>
			<xsl:when test="message:Receiver/@id">
				<xsl:value-of select="message:Receiver/@id"/>
			</xsl:when>
			<xsl:otherwise>SYSTEM</xsl:otherwise>
		</xsl:choose>'
NAD+MS+<xsl:value-of select="message:Sender/@id"/>'
<xsl:variable name="dataSetID">
			<xsl:choose>
				<xsl:when test="message:DataSetID">
					<xsl:value-of select="message:DataSetID"/>
				</xsl:when>
				<xsl:when test="/message:GenericData/message:DataSet/@datasetID">
					<xsl:value-of select="/message:GenericData/message:DataSet/@datasetID"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="message:ID"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>DSI+<xsl:value-of select="$dataSetID"/>'
STS+3+<xsl:choose>
			<xsl:when test="message:DataSetAction='Delete'">6</xsl:when>
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>'
DTM+242:<xsl:value-of select="substring(message:Prepared,1,4)"/>
		<xsl:value-of select="substring(message:Prepared,6,2)"/>
		<xsl:value-of select="substring(message:Prepared,9,2)"/>
		<xsl:value-of select="substring(message:Prepared,12,2)"/>
		<xsl:value-of select="substring(message:Prepared,15,2)"/>:203'<xsl:choose>
			<xsl:when test="message:ReportingBegin">
				<xsl:choose>
					<xsl:when test="message:ReportingEnd">
DTM+Z02:<xsl:value-of select="substring(message:ReportingBegin,1,4)"/>
						<xsl:value-of select="substring(message:ReportingBegin,6,2)"/>
						<xsl:value-of select="substring(message:ReportingBegin,9,2)"/><xsl:value-of select="substring(message:ReportingEnd,1,4)"/>
						<xsl:value-of select="substring(message:ReportingEnd,6,2)"/>
						<xsl:value-of select="substring(message:ReportingEnd,9,2)"/>:711'</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
IDE+5+<xsl:value-of select="/message:GenericData/message:DataSet/generic:KeyFamilyRef"/>'
GIS+AR3'
GIS+1:::-'</xsl:template>
	
	<xsl:template name="endMessage">
		<xsl:param name="freq-dim" select="'FREQ'"/>
		<xsl:variable name="SeriesCountString">
			<xsl:for-each select="message:DataSet//generic:Series">
				<xsl:apply-templates select="." mode="count-arr">
					<xsl:with-param name="freq-dim" select="$freq-dim"/>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="SeriesCount" select="string-length($SeriesCountString)"/>
		<xsl:variable name="DataSetAttCount" select="count(//message:DataSet[generic:Attributes]) + count(//message:DataSet/generic:Attributes/generic:Value)*2"/>
		<xsl:variable name="GroupAttCount" select="count(//generic:Group[generic:Attributes]) + count(//generic:Group/generic:Attributes/generic:Value)*2"/>
		<xsl:variable name="SeriesAttCount" select="count(//generic:Series[generic:Attributes]) + count(//generic:Series/generic:Attributes/generic:Value)*2"/>
		<xsl:variable name="ObsAttCount" select="count(//generic:Obs[generic:Attributes/generic:Value[@concept!= 'OBS_STATUS' and @concept != 'OBS_CONF' and @concept != 'OBS_PRE_BREAK']]) + count(//generic:Obs/generic:Attributes/generic:Value[@concept != 'OBS_STATUS' and @concept != 'OBS_CONF' and @concept != 'OBS_PRE_BREAK'])*2"/>
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
		<xsl:variable name="LongTextCount">
			<xsl:call-template name="GetLongAttCount">
				<xsl:with-param name="iterations" select="count(//generic:Value[string-length(@value)>350])"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="OtherSegmentCount">13</xsl:variable>
UNT+<xsl:value-of select="$SeriesCount + $DataSetAttCount + $GroupAttCount + $SeriesAttCount + $ObsAttCount + $AttHeadingCount +  $OtherSegmentCount + $LongTextCount"/>+MREF000001'</xsl:template>
	
	<xsl:template name="GetLongAttCount">
		<xsl:param name="i">1</xsl:param>
		<xsl:param name="value">0</xsl:param>
		<xsl:param name="iterations">0</xsl:param>
 	 	<xsl:choose>
		  <xsl:when test="$iterations >= $i">
		    <xsl:variable name="valueString">
		    	<xsl:for-each select="//generic:Value[string-length(@value)>350]">
		    		<xsl:if test="position() = $i"><xsl:value-of select="@value"/></xsl:if>
		    	</xsl:for-each>
		    </xsl:variable>
		    <xsl:variable name="new-seg-count" select="floor(string-length($valueString) div 350)"/>
		    <xsl:call-template name="GetLongAttCount">
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
	
	<xsl:template match="generic:Series" mode="create-arr">
		<xsl:param name="start-obs" select="1"/>
		<xsl:param name="freq-dim" select="'FREQ'"/>
ARR++<xsl:for-each select="generic:SeriesKey/generic:Value"><xsl:value-of select="@value"/>:</xsl:for-each>
		<xsl:variable name="freq-val" select="generic:SeriesKey/generic:Value[@concept=$freq-dim]/@value"/>
		<xsl:variable name="last-obs">
			<xsl:apply-templates select="." mode="get-last-obs">
				<xsl:with-param name="curr-obs" select="$start-obs"/>
				<xsl:with-param name="freq-val" select="$freq-val"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="last-obs-pos" select="substring-before($last-obs, ':')"/>
		<xsl:variable name="TimePeriod">
			<xsl:apply-templates select="." mode="get-time-period">
				<xsl:with-param name="start-obs" select="$start-obs"/>
				<xsl:with-param name="freq-val" select="$freq-val"/>
			</xsl:apply-templates>
			<xsl:if test="$start-obs!=$last-obs-pos">
				<xsl:apply-templates select="." mode="get-time-period">
					<xsl:with-param name="start-obs" select="number($last-obs-pos)"/>
					<xsl:with-param name="freq-val" select="$freq-val"/>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:call-template name="getTimeFormat">
				<xsl:with-param name="one" select="$start-obs"/>
				<xsl:with-param name="two" select="$last-obs-pos"/>
				<xsl:with-param name="freq-val" select="$freq-val"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$TimePeriod"/>:<xsl:apply-templates select="generic:Obs[position() >= $start-obs and $last-obs-pos >= position()]" mode="output-obs"/>
		<xsl:if test="count(generic:Obs)>$last-obs-pos">
			<xsl:apply-templates select="." mode="create-arr">
				<xsl:with-param name="start-obs" select="$last-obs-pos+1"/>
				<xsl:with-param name="freq-dim" select="$freq-dim"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="generic:Series" mode="count-arr">
		<xsl:param name="start-obs" select="1"/>
		<xsl:param name="freq-dim" select="'FREQ'"/>
		<xsl:variable name="freq-val" select="generic:SeriesKey/generic:Value[@concept=$freq-dim]/@value"/>
		<xsl:variable name="last-obs">
			<xsl:apply-templates select="." mode="get-last-obs">
				<xsl:with-param name="curr-obs" select="$start-obs"/>
				<xsl:with-param name="freq-val" select="$freq-val"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="last-obs-pos" select="substring-before($last-obs, ':')"/>
		<xsl:if test="count(generic:Obs)>$last-obs-pos">
			<xsl:apply-templates select="." mode="count-arr">
				<xsl:with-param name="start-obs" select="$last-obs-pos+1"/>
				<xsl:with-param name="freq-dim" select="$freq-dim"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:value-of select="'.'"/>
	</xsl:template>
	
	<xsl:template match="generic:Series" mode="get-time-period">
		<xsl:param name="start-obs" select="1"/>
		<xsl:param name="freq-val"/>
		<xsl:apply-templates select="generic:Obs[$start-obs]" mode="output-time-period">
			<xsl:with-param name="freq-val" select="$freq-val"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="generic:Series" mode="get-last-obs">
		<xsl:param name="curr-obs" select="1"/>
		<xsl:param name="freq-val"/>
		<xsl:for-each select="generic:Obs[$curr-obs]/following-sibling::generic:Obs">
			<xsl:variable name="current-time-period">
				<xsl:apply-templates select="preceding-sibling::generic:Obs[1]" mode="output-time-period">
					<xsl:with-param name="freq-val" select="$freq-val"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:variable name="following-time-period">
				<xsl:apply-templates select="." mode="output-time-period">
					<xsl:with-param name="freq-val" select="$freq-val"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:variable name="isSequential">
				<xsl:call-template name="isSequential">
					<xsl:with-param name="one" select="$current-time-period"/>
					<xsl:with-param name="two" select="$following-time-period"/>
					<xsl:with-param name="freq-val" select="$freq-val"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$isSequential='false'"><xsl:value-of select="$curr-obs + position()-1"/>:</xsl:when>
				<xsl:when test="position()=last()"><xsl:value-of select="$curr-obs + last()"/>:</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		<xsl:value-of select="count(generic:Obs)"/>:
	</xsl:template>
	
	<xsl:template match="generic:Obs" mode="output-obs">
		<xsl:variable name="ObsValue">
			<xsl:choose>
				<xsl:when test="not(generic:ObsValue/@value) or generic:ObsValue/@value='NaN'">-</xsl:when>
				<xsl:otherwise><xsl:value-of select="generic:ObsValue/@value"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$ObsValue"/><xsl:if test="generic:Attributes/generic:Value[@concept='OBS_STATUS']">:<xsl:value-of select="generic:Attributes/generic:Value[@concept='OBS_STATUS']/@value"/></xsl:if><xsl:if test="generic:Attributes/generic:Value[@concept='OBS_CONF'] or generic:Attributes/generic:Value[@concept='OBS_PRE_BREAK']">:<xsl:value-of select="generic:Attributes/generic:Value[@concept='OBS_CONF']/@value"/><xsl:if test="generic:Attributes/generic:Value[@concept='OBS_PRE_BREAK']">:<xsl:value-of select="generic:Attributes/generic:Value[@concept='OBS_PRE_BREAK']/@value"/></xsl:if></xsl:if>
		<xsl:choose>
			<xsl:when test="position() !=last()">+</xsl:when>
			<xsl:otherwise>'</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
	<xsl:template match="message:DataSet/generic:Attributes" mode="output-atts">
		<xsl:param name="KeyFamStruct"/>
REL+Z01+1'
ARR+0'<xsl:for-each select="generic:Value">
			<xsl:apply-templates select="." mode="output-att">
				<xsl:with-param name="KeyFamStruct" select="$KeyFamStruct"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="generic:Group/generic:Attributes" mode="output-atts">
		<xsl:param name="KeyFamStruct"/>
ARR+<xsl:value-of select="count(../generic:Series[1]/generic:SeriesKey/generic:Value)"/>+<xsl:for-each select="../generic:Series[1]/generic:SeriesKey/generic:Value"><xsl:variable name="KeyConcept" select="@concept"/><xsl:value-of select="../../../generic:GroupKey/generic:Value[@concept = $KeyConcept]/@value"/><xsl:if test="position() !=last()">:</xsl:if></xsl:for-each>'<xsl:for-each select="generic:Value">
			<xsl:apply-templates select="." mode="output-att">
				<xsl:with-param name="KeyFamStruct" select="$KeyFamStruct"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>	
	
	<xsl:template match="generic:Series/generic:Attributes" mode="output-atts">
		<xsl:param name="KeyFamStruct"/>
ARR+<xsl:value-of select="count(../generic:SeriesKey/generic:Value)"/>+<xsl:for-each select="../generic:SeriesKey/generic:Value"><xsl:value-of select="@value"/><xsl:if test="position() !=last()">:</xsl:if></xsl:for-each>'<xsl:for-each select="generic:Value">
			<xsl:apply-templates select="." mode="output-att">
				<xsl:with-param name="KeyFamStruct" select="$KeyFamStruct"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="generic:Obs/generic:Attributes" mode="output-atts">
		<xsl:param name="KeyFamStruct"/>
		<xsl:param name="freq-dim" select="'FREQ'"/>
		<xsl:variable name="freq-val" select="../../generic:SeriesKey/generic:Value[@concept=$freq-dim]/@value"/>
		<xsl:variable name="TimePeriod">
			<xsl:apply-templates select="parent::generic:Obs" mode="output-time-period">
				<xsl:with-param name="freq-val" select="$freq-val"/>
			</xsl:apply-templates>
			<xsl:call-template name="getTimeFormat">
				<xsl:with-param name="one" select="1"/>
				<xsl:with-param name="two" select="1"/>
				<xsl:with-param name="freq-val" select="$freq-val"/>
			</xsl:call-template>
		</xsl:variable>
ARR+<xsl:value-of select="count(../../generic:SeriesKey/generic:Value)+2"/>+<xsl:for-each select="../../generic:SeriesKey/generic:Value"><xsl:value-of select="@value"/>:</xsl:for-each><xsl:value-of select="$TimePeriod"/>'<xsl:for-each select="generic:Value[@concept!='OBS_STATUS' and @concept!='OBS_CONF' and @concept!='OBS_PRE_BREAK']">
			<xsl:apply-templates select="." mode="output-att">
				<xsl:with-param name="KeyFamStruct" select="$KeyFamStruct"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="generic:Value" mode="output-att">
		<xsl:param name="KeyFamStruct"/>
		<xsl:variable name="AttConcept" select="@concept"/>
		<xsl:choose>
			<xsl:when test="not($KeyFamStruct/structure:Components/structure:Attribute[@concept = $AttConcept]/@codelist)">
IDE+Z11+<xsl:value-of select="$AttConcept"/>'
FTX+ACM+++<xsl:call-template name="break-free-text"><xsl:with-param name="free-text" select="@value"/></xsl:call-template></xsl:when>
			<xsl:otherwise>
IDE+Z10+<xsl:value-of select="$AttConcept"/>'
CDV+<xsl:value-of select="@value"/>'</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="isSequential">
		<xsl:param name="one"/>
		<xsl:param name="two"/>
		<xsl:param name="freq-val"/>
		<xsl:choose>
			<xsl:when test="$freq-val='D'">
				<xsl:variable name="year" select="substring($one,1,4)"/>
				<xsl:variable name="month" select="substring($one,5,2)"/>
				<xsl:variable name="day" select="substring($one,7,2)"/>
				<xsl:variable name="test_two">
					<xsl:choose>
						<xsl:when test="$month='01' or $month='03' or $month='05' or $month='07' or $month='08' or $month='10'">
							<xsl:choose>
								<xsl:when test="$day=31">
									<xsl:variable name="newMonth" select="$month+1"/>
									<xsl:variable name="newMonthText">
										<xsl:choose>
											<xsl:when test="string-length($newMonth)=1"><xsl:value-of select="concat('0',$newMonth)"/></xsl:when>
											<xsl:otherwise><xsl:value-of select="$newMonth"/></xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="concat($year,$newMonthText,'01')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="newDay" select="$day+1"/>
									<xsl:variable name="newDayText">
										<xsl:choose>
											<xsl:when test="string-length($newDay)=1"><xsl:value-of select="concat('0',$newDay)"/></xsl:when>
											<xsl:otherwise><xsl:value-of select="$newDay"/></xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="concat($year,$month,$newDayText)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$month='02'">
							<xsl:choose>
								<xsl:when test="($year mod 4)=0">
									<xsl:choose>
										<xsl:when test="$day=29">
											<xsl:value-of select="concat($year,'0301')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="newDay" select="$day+1"/>
											<xsl:variable name="newDayText">
												<xsl:choose>
													<xsl:when test="string-length($newDay)=1"><xsl:value-of select="concat('0',$newDay)"/></xsl:when>
													<xsl:otherwise><xsl:value-of select="$newDay"/></xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:value-of select="concat($year,$month,$newDayText)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$day=28">
											<xsl:value-of select="concat($year,'0301')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="newDay" select="$day+1"/>
											<xsl:variable name="newDayText">
												<xsl:choose>
													<xsl:when test="string-length($newDay)=1"><xsl:value-of select="concat('0',$newDay)"/></xsl:when>
													<xsl:otherwise><xsl:value-of select="$newDay"/></xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:value-of select="concat($year,$month,$newDayText)"/>
										</xsl:otherwise>
									</xsl:choose>								
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$month='12'">
							<xsl:choose>
								<xsl:when test="$day=31">
									<xsl:value-of select="concat($year+1,'0101')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="newDay" select="$day+1"/>
									<xsl:variable name="newDayText">
										<xsl:choose>
											<xsl:when test="string-length($newDay)=1"><xsl:value-of select="concat('0',$newDay)"/></xsl:when>
											<xsl:otherwise><xsl:value-of select="$newDay"/></xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="concat($year,$month,$newDayText)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$day=30">
									<xsl:variable name="newMonth" select="$month+1"/>
									<xsl:variable name="newMonthText">
										<xsl:choose>
											<xsl:when test="string-length($newMonth)=1"><xsl:value-of select="concat('0',$newMonth)"/></xsl:when>
											<xsl:otherwise><xsl:value-of select="$newMonth"/></xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="concat($year,$newMonthText,'01')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="newDay" select="$day+1"/>
									<xsl:variable name="newDayText">
										<xsl:choose>
											<xsl:when test="string-length($newDay)=1"><xsl:value-of select="concat('0',$newDay)"/></xsl:when>
											<xsl:otherwise><xsl:value-of select="$newDay"/></xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="concat($year,$month,$newDayText)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$test_two = $two">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$freq-val='M'">
				<xsl:variable name="test_two">
					<xsl:variable name="year" select="substring($one,1,4)"/>
					<xsl:variable name="month" select="substring($one,5,2)"/>
					<xsl:choose>
						<xsl:when test="$month=12"><xsl:value-of select="concat($year+1,'01')"/></xsl:when>
						<xsl:otherwise>
							<xsl:variable name="newMonth" select="$month+1"/>
							<xsl:variable name="newMonthText">
								<xsl:choose>
									<xsl:when test="string-length($newMonth)=1"><xsl:value-of select="concat('0',$newMonth)"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$newMonth"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($year,$newMonthText)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$test_two = $two">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$freq-val='Q'">
				<xsl:variable name="test_two">
					<xsl:variable name="year" select="substring($one,1,4)"/>
					<xsl:variable name="quarter" select="substring($one,5,1)"/>
					<xsl:choose>
						<xsl:when test="$quarter=4"><xsl:value-of select="concat($year+1,'1')"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="concat($year,$quarter+1)"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$test_two = $two">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$freq-val='H'">
				<xsl:variable name="test_two">
					<xsl:variable name="year" select="substring($one,1,4)"/>
					<xsl:variable name="half" select="substring($one,5,1)"/>
					<xsl:choose>
						<xsl:when test="$half=2"><xsl:value-of select="concat($year+1,'1')"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="concat($year,'2')"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$test_two = $two">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$freq-val='A'">
				<xsl:choose>
					<xsl:when test="$one = $two - 1">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="getTimeFormat">
		<xsl:param name="one"/>
		<xsl:param name="two"/>
		<xsl:param name="freq-val"/>
		<xsl:choose>
			<xsl:when test="$freq-val='D'">
				<xsl:choose>
					<xsl:when test="$one = $two">:102</xsl:when>
					<xsl:otherwise>:711</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$freq-val='M'">
				<xsl:choose>
					<xsl:when test="$one = $two">:610</xsl:when>
					<xsl:otherwise>:710</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$freq-val='Q'">
				<xsl:choose>
					<xsl:when test="$one = $two">:608</xsl:when>
					<xsl:otherwise>:708</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$freq-val='H'">
				<xsl:choose>
					<xsl:when test="$one = $two">:604</xsl:when>
					<xsl:otherwise>:704</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$freq-val='A'">
				<xsl:choose>
					<xsl:when test="$one = $two">:602</xsl:when>
					<xsl:otherwise>:702</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="generic:Obs" mode="output-time-period">
		<xsl:param name="freq-val"/>
		<xsl:variable name="time" select="generic:Time"/>
		<xsl:choose>
			<xsl:when test="$freq-val='D'">
				<xsl:value-of select="substring($time,1,4)"/>
				<xsl:value-of select="substring($time,6,2)"/>
				<xsl:value-of select="substring($time,9,2)"/>
			</xsl:when>
			<xsl:when test="$freq-val='M'">
				<xsl:value-of select="substring($time,1,4)"/>
				<xsl:value-of select="substring($time,6,2)"/>
			</xsl:when>
			<xsl:when test="$freq-val='Q'">
				<xsl:value-of select="substring($time,1,4)"/>
				<xsl:choose>
					<xsl:when test="contains($time, '-Q')">
						<xsl:value-of select="substring($time,7,1)"/>
					</xsl:when>
					<xsl:when test="3>=substring($time,6,2)">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:when test="6>=substring($time,6,2)">
						<xsl:value-of select="2"/>
					</xsl:when>
					<xsl:when test="9>=substring($time,6,2)">
						<xsl:value-of select="3"/>
					</xsl:when>
					<xsl:when test="12>=substring($time,6,2)">
						<xsl:value-of select="4"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$freq-val='H'">
				<xsl:value-of select="substring($time,1,4)"/>
				<xsl:choose>
					<xsl:when test="contains($time, '-B')">
						<xsl:value-of select="substring($time,7,1)"/>
					</xsl:when>
					<xsl:when test="6>=substring($time,6,2)">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:when test="12>=substring($time,6,2)">
						<xsl:value-of select="2"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$freq-val='A'">
				<xsl:value-of select="substring($time,1,4)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
		
</xsl:stylesheet>
