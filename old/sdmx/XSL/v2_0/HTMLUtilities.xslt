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
	
	<xsl:include href="ReferenceUtilities.xslt"/>
	<xsl:include href="SchemaUtilities.xslt"/>
	
	<xsl:template mode="OutputHTMLPage" match="s:Concept">
		<xsl:param name="originalConcept" select="s:Concept/@id"/>
		<xsl:param name="KFID"/>
		<xsl:choose>
			<xsl:when test="@isExternalReference = 'true' or parent::s:ConceptScheme/@isExternalReference = 'true'">
				<xsl:variable name="docLoc">
					<xsl:choose>
						<xsl:when test="@uri"><xsl:value-of select="@uri"/></xsl:when>
						<xsl:when test="parent::s:ConceptScheme/@uri"><xsl:value-of select="parent::s:ConceptScheme/@uri"/></xsl:when>
					</xsl:choose>
				</xsl:variable>
				<!-- Get External Document -->
				<xsl:variable name="externalDoc" select="document($docLoc, .)"/>
				<xsl:variable name="ID" select="@id"/>
				<xsl:variable name="Agency" select="@agencyID"/>
				<xsl:variable name="Version" select="@version"/>
				<xsl:choose>
					<xsl:when test="parent::s:ConceptScheme">
						<xsl:variable name="SchemeID" select="parent::s:ConceptScheme/@id"/>
						<xsl:variable name="SchemeAgency" select="parent::s:ConceptScheme/@agencyID"/>
						<xsl:variable name="SchemeVersion" select="parent::s:ConceptScheme/@version"/>
						<xsl:apply-templates select="$externalDoc/m:Structure/m:Concepts/s:ConceptScheme[@id = $SchemeID and @agencyID = $SchemeAgency and 
(@version = $SchemeVersion or not(boolean($SchemeVersion)))]/s:Concept[@id = $ID and (@version = $Version or not(boolean(@version)))]" mode="OutputHTMLPage">
							<xsl:with-param name="originalConcept" select="$originalConcept"/>
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$externalDoc/m:Structure/m:Concepts/s:Concept[@id = $ID and (@agencyID=$Agency or not(boolean(@agencyID))) and (@version=$Version or not(boolean(@version)))]" mode="OutputHTMLPage">
							<xsl:with-param name="originalConcept" select="$originalConcept"/>
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@parent">
						<xsl:variable name="ID" select="@parent"/>
						<xsl:apply-templates select="parent::s:ConceptScheme/s:Concept[@id = $ID]" mode="OutputHTMLPage">
							<xsl:with-param name="originalConcept" select="$originalConcept"/>
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="@coreRepresentation">
						<xsl:variable name="Agency">
							<xsl:value-of select="@coreRepresentationAgency"/>
						</xsl:variable>
						<xsl:variable name="ID">
							<xsl:value-of select="@coreRepresentation"/>
						</xsl:variable>
						<!-- Get code list -->
						<xsl:apply-templates select="ancestor::m:Structure/m:CodeLists/s:CodeList[@id = $ID and (@agencyID=$Agency or not(boolean($Agency)))]" mode="OutputHTMLPage">
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="s:TextFormat">
						<xsl:apply-templates mode="OutputHTMLPage" select="s:TextFormat">
							<xsl:with-param name="conceptName" select="$originalConcept"/>
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<!-- No output here -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="OutputDefaultRepresentationHTML" match="s:Concept">
		<xsl:param name="isTime" select="'false'"/>
		<xsl:choose>
			<xsl:when test="@isExternalReference = 'true' or parent::s:ConceptScheme/@isExternalReference = 'true'">
				<xsl:variable name="docLoc">
					<xsl:choose>
						<xsl:when test="@uri"><xsl:value-of select="@uri"/></xsl:when>
						<xsl:when test="parent::s:ConceptScheme/@uri"><xsl:value-of select="parent::s:ConceptScheme/@uri"/></xsl:when>
					</xsl:choose>
				</xsl:variable>
				<!-- Get External Document -->
				<xsl:variable name="externalDoc" select="document($docLoc, .)"/>
				<xsl:variable name="ID" select="@id"/>
				<xsl:variable name="Agency" select="@agencyID"/>
				<xsl:variable name="Version" select="@version"/>
				<xsl:choose>
					<xsl:when test="parent::s:ConceptScheme">
						<xsl:variable name="SchemeID" select="parent::s:ConceptScheme/@id"/>
						<xsl:variable name="SchemeAgency" select="parent::s:ConceptScheme/@agencyID"/>
						<xsl:variable name="SchemeVersion" select="parent::s:ConceptScheme/@version"/>
						<xsl:apply-templates select="$externalDoc/m:Structure/m:Concepts/s:ConceptScheme[@id = $SchemeID and @agencyID = $SchemeAgency and 
(@version = $SchemeVersion or not(boolean($SchemeVersion)))]/s:Concept[@id = $ID and (@version = $Version or not(boolean(@version)))]" mode="OutputDefaultRepresentationHTML">
							<xsl:with-param name="isTime" select="$isTime"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$externalDoc/m:Structure/m:Concepts/s:Concept[@id = $ID and (@agencyID=$Agency or not(boolean(@agencyID))) and (@version=$Version or not(boolean(@version)))]" mode="OutputDefaultRepresentationHTML">
							<xsl:with-param name="isTime" select="$isTime"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@parent">
						<xsl:variable name="ID" select="@parent"/>
						<xsl:apply-templates select="parent::s:ConceptScheme/s:Concept[@id = $ID]" mode="OutputDefaultRepresentationHTML">
							<xsl:with-param name="isTime" select="$isTime"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="@coreRepresentation">
						<xsl:variable name="Agency">
							<xsl:value-of select="@coreRepresentationAgency"/>
						</xsl:variable>
						<xsl:variable name="ID">
							<xsl:value-of select="@coreRepresentation"/>
						</xsl:variable>
						<!-- Get code list -->
						<xsl:apply-templates select="ancestor::m:Structure/m:CodeLists/s:CodeList[@id = $ID and (@agencyID=$Agency or not(boolean($Agency)))]" mode="OutputHTML"/>
					</xsl:when>
					<xsl:when test="s:TextFormat">
						<xsl:apply-templates mode="OutputHTML" select="s:TextFormat"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$isTime='true'">Time Period</xsl:when>
							<xsl:otherwise>String</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="GetValueDescription" match="s:Concept">
		<xsl:param name="value" select="'N/A'"/>
		<xsl:choose>
			<xsl:when test="@isExternalReference = 'true' or parent::s:ConceptScheme/@isExternalReference = 'true'">
				<xsl:variable name="docLoc">
					<xsl:choose>
						<xsl:when test="@uri"><xsl:value-of select="@uri"/></xsl:when>
						<xsl:when test="parent::s:ConceptScheme/@uri"><xsl:value-of select="parent::s:ConceptScheme/@uri"/></xsl:when>
					</xsl:choose>
				</xsl:variable>
				<!-- Get External Document -->
				<xsl:variable name="externalDoc" select="document($docLoc, .)"/>
				<xsl:variable name="ID" select="@id"/>
				<xsl:variable name="Agency" select="@agencyID"/>
				<xsl:variable name="Version" select="@version"/>
				<xsl:choose>
					<xsl:when test="parent::s:ConceptScheme">
						<xsl:variable name="SchemeID" select="parent::s:ConceptScheme/@id"/>
						<xsl:variable name="SchemeAgency" select="parent::s:ConceptScheme/@agencyID"/>
						<xsl:variable name="SchemeVersion" select="parent::s:ConceptScheme/@version"/>
						<xsl:apply-templates select="$externalDoc/m:Structure/m:Concepts/s:ConceptScheme[@id = $SchemeID and @agencyID = $SchemeAgency and 
(@version = $SchemeVersion or not(boolean($SchemeVersion)))]/s:Concept[@id = $ID and (@version = $Version or not(boolean(@version)))]" mode="GetValueDescription">
							<xsl:with-param name="value" select="$value"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$externalDoc/m:Structure/m:Concepts/s:Concept[@id = $ID and (@agencyID=$Agency or not(boolean(@agencyID))) and (@version=$Version or not(boolean(@version)))]" mode="GetValueDescription">
							<xsl:with-param name="value" select="$value"/>					
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@parent">
						<xsl:variable name="ID" select="@parent"/>
						<xsl:apply-templates select="parent::s:ConceptScheme/s:Concept[@id = $ID]" mode="GetValueDescription">
							<xsl:with-param name="value" select="$value"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="@coreRepresentation">
						<xsl:variable name="Agency">
							<xsl:value-of select="@coreRepresentationAgency"/>
						</xsl:variable>
						<xsl:variable name="ID">
							<xsl:value-of select="@coreRepresentation"/>
						</xsl:variable>
						<xsl:apply-templates select="ancestor::m:Structure/m:CodeLists/s:CodeList[@id = $ID and (@agencyID=$Agency or not(boolean($Agency)))]" mode="GetValueDescription">
							<xsl:with-param name="value" select="$value"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="s:CodeList" mode="OutputHTML">
		<xsl:choose>
			<xsl:when test="@isExternalReference = 'true'">
				<!-- If a codelist is an external reference, the codelist will be retrieved
				from the external source. -->
				<xsl:variable name="externalDoc" select="document(@uri, .)"/>
				<xsl:variable name="ID" select="@id"/>
				<xsl:variable name="Agency" select="@agencyID"/>
				<xsl:variable name="Version" select="@version"/>
				<xsl:apply-templates select="$externalDoc/m:Structure/m:CodeLists/s:CodeList[@id=$ID and (@agencyID=$Agency or not(boolean($Agency))) and (@version=$Version or not(boolean($Version)))]" mode="OutputHTML"/>				
			</xsl:when>
			<xsl:otherwise>
				<select class="allowedvals">
					<optgroup label="Allowed Values">
						<xsl:for-each select="s:Code">
							<xsl:variable name="Description">
								<xsl:choose>
									<xsl:when test="$lang='notPassed' or not(s:Description[@xml:lang=$lang])">
										<xsl:value-of select="s:Description[1]"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="s:Description[@xml:lang=$lang]"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<option><xsl:value-of select="@value"/> - <xsl:value-of select="$Description"/></option>
						</xsl:for-each>
					</optgroup>
				</select>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="s:CodeList" mode="OutputHTMLPage">
		<xsl:param name="KFID"/>
		<xsl:choose>
			<xsl:when test="@isExternalReference = 'true'">
				<!-- If a codelist is an external reference, the codelist will be retrieved
				from the external source. -->
				<xsl:variable name="externalDoc" select="document(@uri, .)"/>
				<xsl:variable name="ID" select="@id"/>
				<xsl:variable name="Agency" select="@agencyID"/>
				<xsl:variable name="Version" select="@version"/>
				<xsl:apply-templates select="$externalDoc/m:Structure/m:CodeLists/s:CodeList[@id=$ID and (@agencyID=$Agency or not(boolean($Agency))) and (@version=$Version or not(boolean($Version)))]" mode="OutputHTMLPage"/>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="CodelistName">
					<xsl:choose>
						<xsl:when test="$lang='notPassed'">
							<xsl:value-of select="s:Name[1]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="s:Name[@xml:lang=$lang]">
									<xsl:value-of select="s:Name[@xml:lang=$lang]"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="s:Name[1]"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="GetHeader">
					<xsl:with-param name="Title">Key Family Code List: <xsl:value-of select="$CodelistName"/></xsl:with-param>
				</xsl:call-template>
				<table cellpadding="3" cellspacing="1" border="1" width="100%">
					<tbody>
						<tr>
							<td class="field" valign="top">ID</td>
							<td class="data" valign="top"><xsl:value-of select="@id"/></td>
						</tr>
						<tr>
							<td class="field" valign="top">Agency</td>
							<td class="data" valign="top">
								<a href="Ag{@agencyID}.html" class="data1"><xsl:value-of select="@agencyID"/></a>
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
				<xsl:if test="s:Code">
					<xsl:choose>
						<xsl:when test="s:Code/s:Annotations">
							<table cellpadding="3" cellspacing="1" border="1" width="100%">
								<tbody>
									<tr>
										<th class="field1" colspan="3">Codes</th>
									</tr>
									<tr>
										<th class="field4">Value</th>
										<th class="field6">Description</th>
										<th class="field4">Annotations</th>
									</tr>
									<xsl:for-each select="s:Code">
										<tr>
											<td class="data2" valign="top">
												<xsl:value-of select="@value"/>
											</td>
											<xsl:variable name="Description">
												<xsl:call-template name="GetDescription"/>
											</xsl:variable>
											<td class="data3">
												<xsl:value-of select="$Description"/>
											</td>
											<td class="data2" valign="top">
												<xsl:choose>
													<xsl:when test="s:Annotations">
														<xsl:variable name="AnnLink">
															<xsl:choose>
																<xsl:when test="$isSingleDoc='true'">
																	<xsl:value-of select="concat('#', ../@id, @value, 'Ann')"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="concat(../@id, @value, 'Ann', '.html')"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:variable>
														<a href="{$AnnLink}" class="data2">View</a>
													</xsl:when>
													<xsl:otherwise>None</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table><br/>
							<xsl:for-each select="s:Code[s:Annotations]">
								<xsl:apply-templates select="." mode="Annotations">
									<xsl:with-param name="KFID" select="$KFID"/>
								</xsl:apply-templates>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<table cellpadding="3" cellspacing="1" border="1" width="100%">
								<tbody>
									<tr>
										<th class="field1" colspan="3">Codes</th>
									</tr>
									<tr>
										<th class="field4" valign="top">Value</th>
										<th class="field5" valign="top">Description</th>
									</tr>
									<xsl:for-each select="s:Code">
										<xsl:variable name="Description">
											<xsl:call-template name="GetDescription"/>
										</xsl:variable>
										<tr>
											<td class="data2" valign="top">
												<xsl:value-of select="@value"/>
											</td>
											<td class="data1" valign="top">
												<xsl:value-of select="$Description"/>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table><br/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:for-each select="s:Annotations/common:Annotation">
					<xsl:apply-templates select="." mode="Table"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="s:CodeList" mode="GetValueDescription">
		<xsl:param name="value" select="'N/A'"/>
		<xsl:choose>
			<xsl:when test="@isExternalReference = 'true'">
				<!-- If a codelist is an external reference, the codelist will be retrieved
				from the external source. -->
				<xsl:variable name="externalDoc" select="document(@uri, .)"/>
				<xsl:variable name="ID" select="@id"/>
				<xsl:variable name="Agency" select="@agencyID"/>
				<xsl:variable name="Version" select="@version"/>
				<xsl:apply-templates select="$externalDoc/m:Structure/m:CodeLists/s:CodeList[@id=$ID and (@agencyID=$Agency or not(boolean($Agency))) and (@version=$Version or not(boolean($Version)))]" mode="GetValueDescription">
					<xsl:with-param name="value" select="$value"/>
				</xsl:apply-templates>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Code" select="s:Code[@value=$value]"/>
				<xsl:choose>
					<xsl:when test="not($Code)">
						<xsl:value-of select="$value"/>
					</xsl:when>
					<xsl:when test="$lang='notPassed'">
						<xsl:value-of select="$Code/s:Description[1]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$Code/s:Description[@xml:lang=$lang]">
								<xsl:value-of select="$Code/s:Description[@xml:lang=$lang]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$Code/s:Description[1]"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="s:TextFormat" mode="OutputHTML">
		<xsl:param name="conceptName"/>
		<xsl:choose>
			<xsl:when test="@textType = 'Timespan'">Timespan</xsl:when>
			<xsl:when test="@textType = 'String'">String</xsl:when>
			<xsl:when test="@textType = 'BigInteger'">Big Integer</xsl:when>
			<xsl:when test="@textType = 'Integer'">Integer</xsl:when>
			<xsl:when test="@textType = 'Long'">Long</xsl:when>
			<xsl:when test="@textType = 'Short'">Short</xsl:when>
			<xsl:when test="@textType = 'Deciaml'">Decimal</xsl:when>
			<xsl:when test="@textType = 'Float'">Float</xsl:when>
			<xsl:when test="@textType = 'Double'">Double</xsl:when>
			<xsl:when test="@textType = 'Boolean'">Boolean</xsl:when>
			<xsl:when test="@textType = 'DateTime'">Date Time</xsl:when>
			<xsl:when test="@textType = 'Time'">Time</xsl:when>
			<xsl:when test="@textType = 'Date'">Date</xsl:when>
			<xsl:when test="@textType = 'Year'">Year</xsl:when>
			<xsl:when test="@textType = 'Month'">Month</xsl:when>
			<xsl:when test="@textType = 'Day'">Day</xsl:when>
			<xsl:when test="@textType = 'MonthDay'">Month - Day</xsl:when>
			<xsl:when test="@textType = 'YearMonth'">Year - Month</xsl:when>
			<xsl:when test="@textType = 'Duration'">Duration</xsl:when>
			<xsl:when test="@textType = 'URI'">URI</xsl:when>
			<xsl:when test="@textType = 'Count'">Count</xsl:when>
			<xsl:when test="@textType = 'InclusiveValueRange'">Inclusive Value Range</xsl:when>
			<xsl:when test="@textType = 'ExclusiveValueRange'">Exclusive Value Range</xsl:when>
			<xsl:when test="@textType = 'Incremental'">Incremental</xsl:when>
			<xsl:otherwise>String</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="@minLength"><br/>Min Length: <xsl:value-of select="@minLength"/></xsl:if>
		<xsl:if test="@maxLength"><br/>Max Length: <xsl:value-of select="@maxLength"/></xsl:if>
		<xsl:if test="@startValue"><br/>Start: <xsl:value-of select="@startValue"/></xsl:if>
		<xsl:if test="@endValue"><br/>End: <xsl:value-of select="@endValue"/></xsl:if>
		<xsl:if test="@interval"><br/>Interval: <xsl:value-of select="@interval"/></xsl:if>
		<xsl:if test="@timeInterval"><br/>Time Interval: <xsl:value-of select="@timeInterval"/></xsl:if>
		<xsl:if test="@decimals"><br/>Decimals: <xsl:value-of select="@decimals"/></xsl:if>
		<xsl:if test="@pattern"><br/>Pattern: <xsl:value-of select="@pattern"/></xsl:if>
	</xsl:template>

	<xsl:template match="s:TextFormat" mode="OutputHTMLPage">
		<xsl:param name="conceptName"/>
		<xsl:variable name="Base">
			<xsl:choose>
				<xsl:when test="@textType = 'Timespan'">Timespan</xsl:when>
				<xsl:when test="@textType = 'String'">String</xsl:when>
				<xsl:when test="@textType = 'BigInteger'">Big Integer</xsl:when>
				<xsl:when test="@textType = 'Integer'">Integer</xsl:when>
				<xsl:when test="@textType = 'Long'">Long</xsl:when>
				<xsl:when test="@textType = 'Short'">Short</xsl:when>
				<xsl:when test="@textType = 'Deciaml'">Decimal</xsl:when>
				<xsl:when test="@textType = 'Float'">Float</xsl:when>
				<xsl:when test="@textType = 'Double'">Double</xsl:when>
				<xsl:when test="@textType = 'Boolean'">Boolean</xsl:when>
				<xsl:when test="@textType = 'DateTime'">Date Time</xsl:when>
				<xsl:when test="@textType = 'Time'">Time</xsl:when>
				<xsl:when test="@textType = 'Date'">Date</xsl:when>
				<xsl:when test="@textType = 'Year'">Year</xsl:when>
				<xsl:when test="@textType = 'Month'">Month</xsl:when>
				<xsl:when test="@textType = 'Day'">Day</xsl:when>
				<xsl:when test="@textType = 'MonthDay'">Month - Day</xsl:when>
				<xsl:when test="@textType = 'YearMonth'">Year - Month</xsl:when>
				<xsl:when test="@textType = 'Duration'">Duration</xsl:when>
				<xsl:when test="@textType = 'URI'">URI</xsl:when>
				<xsl:when test="@textType = 'Count'">Count</xsl:when>
				<xsl:when test="@textType = 'InclusiveValueRange'">Inclusive Value Range</xsl:when>
				<xsl:when test="@textType = 'ExclusiveValueRange'">Exclusive Value Range</xsl:when>
				<xsl:when test="@textType = 'Incremental'">Incremental</xsl:when>
				<xsl:otherwise>String</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="GetHeader">
			<xsl:with-param name="Title">Key Family Simple Type: <xsl:value-of select="$conceptName"/>Type</xsl:with-param>
		</xsl:call-template>
		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<tr>
					<td class="field" valign="top">Base Type</td>
					<td class="data" valign="top"><xsl:value-of select="$Base"/></td>
				</tr>
				<xsl:if test="@minLength">
					<tr>
						<td class="field" valign="top">Minimum Length</td>
						<td class="data" valign="top">
							<xsl:value-of select="@minLength"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@maxLength">
					<tr>
						<td class="field" valign="top">Maximum Length</td>
						<td class="data" valign="top">
							<xsl:value-of select="@maxLength"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@startValue">
					<tr>
						<td class="field" valign="top">Start Value</td>
						<td class="data" valign="top">
							<xsl:value-of select="@startValue"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@endValue">
					<tr>
						<td class="field" valign="top">End Value</td>
						<td class="data" valign="top">
							<xsl:value-of select="@endValue"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@interval">
					<tr>
						<td class="field" valign="top">Interval</td>
						<td class="data" valign="top">
							<xsl:value-of select="@interval"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@timeInterval">
					<tr>
						<td class="field" valign="top">Time Interval</td>
						<td class="data" valign="top">
							<xsl:value-of select="@timeInterval"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@decimals">
					<tr>
						<td class="field" valign="top">Decimals</td>
						<td class="data" valign="top">
							<xsl:value-of select="@decimals"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@pattern">
					<tr>
						<td class="field" valign="top">Pattern</td>
						<td class="data" valign="top">
							<xsl:value-of select="@pattern"/>
						</td>
					</tr>
				</xsl:if>
			</tbody>
		</table><br/>
	</xsl:template>
	
	<xsl:template mode="CreateTypeHTMLPage" match="s:Attribute | s:Dimension | s:TimeDimension | s:PrimaryMeasure | s:CrossSectionalMeasure">
		<xsl:param name="KFID"/>
		<xsl:choose>
			<xsl:when test="@codelist">
				<!-- Code List Was Specified -->
				<xsl:variable name="codelistKeyValue">
					<xsl:apply-templates select="." mode="GetCodelistKeyValue"/>
				</xsl:variable>
				<xsl:variable name="codelistKey">
					<xsl:call-template name="GetCodelistKey">
						<xsl:with-param name="search" select="$codelistKeyValue"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="codelist" select="key($codelistKey, $codelistKeyValue)"/>
				<xsl:choose>
					<xsl:when test="not($codelist)">
						<xsl:comment>Could not find codelist for <xsl:value-of select="local-name()"/>: <xsl:value-of select="@conceptRef"/> (<xsl:value-of select="$codelistKeyValue"/>)</xsl:comment>
					</xsl:when>
					<xsl:otherwise>
						<!-- Output Codelist -->
						<xsl:apply-templates select="$codelist" mode="OutputHTMLPage">
							<xsl:with-param name="KFID" select="$KFID"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="s:TextFormat">
				<!-- Text Format Was Specified -->
				<xsl:apply-templates mode="OutputHTMLPage" select="s:TextFormat">
					<xsl:with-param name="conceptName" select="@conceptRef"/>
					<xsl:with-param name="KFID" select="$KFID"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-- No Representation was supplied, need to check for default representation -->
				<!-- Get Concept -->
				<xsl:variable name="conceptKeyValue">
					<xsl:apply-templates mode="GetConceptKeyValue" select="."/>
				</xsl:variable>
				<xsl:variable name="conceptKey">
					<xsl:call-template name="GetConceptKey">
						<xsl:with-param name="search" select="$conceptKeyValue"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="concept" select="key($conceptKey, $conceptKeyValue)"/>
				<!-- Need to make sure we have only one concept, if not, get the latest version of the concept -->
				<xsl:variable name="conceptVersion">
					<xsl:for-each select="$concept">
						<xsl:sort select="@version"/>
						<xsl:sort select="parent::ConceptScheme/@version"/>
						<xsl:if test="position() = last()"><xsl:value-of select="concat(parent::ConceptScheme/@version, ':SDMX:', @version)"/></xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="useSchemeVersion" select="substring-before($conceptVersion, ':SDMX:')"/>
				<xsl:variable name="useConceptVersion" select="substring-after($conceptVersion, ':SDMX:')"/>
				<xsl:variable name="finalConcept" select="$concept[(parent::ConceptScheme/@version = $useSchemeVersion or not(parent::ConceptScheme) or $useSchemeVersion='') and (@version = $useConceptVersion or $useConceptVersion='')][1]"/>
				<xsl:apply-templates select="$finalConcept" mode="OutputHTMLPage">
					<xsl:with-param name="originalConcept" select="@conceptRef"/>
					<xsl:with-param name="KFID" select="$KFID"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<xsl:template mode="CreateConceptHTMLPage" match="s:Attribute | s:Dimension | s:TimeDimension | s:PrimaryMeasure | s:CrossSectionalMeasure">
		<!-- No Representation was supplied, need to check for default representation -->
		<!-- Get Concept -->
		<xsl:variable name="conceptKeyValue">
			<xsl:apply-templates mode="GetConceptKeyValue" select="."/>
		</xsl:variable>
		<xsl:variable name="conceptKey">
			<xsl:call-template name="GetConceptKey">
				<xsl:with-param name="search" select="$conceptKeyValue"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="concept" select="key($conceptKey, $conceptKeyValue)"/>
		<!-- Need to make sure we have only one concept, if not, get the latest version of the concept -->
		<xsl:variable name="conceptVersion">
			<xsl:for-each select="$concept">
				<xsl:sort select="@version"/>
				<xsl:sort select="parent::ConceptScheme/@version"/>
				<xsl:if test="position() = last()"><xsl:value-of select="concat(parent::ConceptScheme/@version, ':SDMX:', @version)"/></xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="useSchemeVersion" select="substring-before($conceptVersion, ':SDMX:')"/>
		<xsl:variable name="useConceptVersion" select="substring-after($conceptVersion, ':SDMX:')"/>
		<xsl:variable name="finalConcept" select="$concept[(parent::ConceptScheme/@version = $useSchemeVersion or not(parent::ConceptScheme) or $useSchemeVersion='') and (@version = $useConceptVersion or $useConceptVersion='')][1]"/>
		<xsl:variable name="ConceptName">
			<xsl:choose>
				<xsl:when test="$lang='notPassed'">
					<xsl:value-of select="$finalConcept/s:Name[1]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$finalConcept/s:Name[@xml:lang=$lang]">
							<xsl:value-of select="$finalConcept/s:Name[@xml:lang=$lang]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$finalConcept/s:Name[1]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="GetHeader">
			<xsl:with-param name="Title">Key Family Concept: <xsl:value-of select="$ConceptName"/></xsl:with-param>
		</xsl:call-template>
		<table cellpadding="3" cellspacing="1" border="1" width="100%">
			<tbody>
				<xsl:if test="$finalConcept/parent::s:ConceptScheme">
					<xsl:variable name="ConceptSchemeName">
						<xsl:choose>
							<xsl:when test="$lang='notPassed'">
								<xsl:value-of select="$finalConcept/parent::s:ConceptScheme/s:Name[1]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$finalConcept/parent::s:ConceptScheme/s:Name[@xml:lang=$lang]">
										<xsl:value-of select="$finalConcept/parent::s:ConceptScheme/s:Name[@xml:lang=$lang]"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$finalConcept/parent::s:ConceptScheme/s:Name[1]"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr>
						<td class="field" valign="top">Concept Scheme</td>
						<td class="data" valign="top"><xsl:value-of select="$ConceptSchemeName"/></td>
					</tr>
					<tr>
						<td class="field" valign="top">Concept Scheme ID</td>
						<td class="data" valign="top"><xsl:value-of select="$finalConcept/parent::s:ConceptScheme/@id"/></td>
					</tr>
				</xsl:if>
				<tr>
					<td class="field" valign="top">ID</td>
					<td class="data" valign="top"><xsl:value-of select="$finalConcept/@id"/></td>
				</tr>
				<xsl:if test="$finalConcept/@agencyID">
					<tr>
						<td class="field" valign="top">Agency</td>
						<td class="data" valign="top">
							<a href="Ag{$finalConcept/@agencyID}.html" class="data1"><xsl:value-of select="$finalConcept/@agencyID"/></a>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="$finalConcept/@version">
					<tr>
						<td class="field" valign="top">Version</td>
						<td class="data" valign="top">
							<xsl:value-of select="$finalConcept/@version"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="$finalConcept/@urn">
					<tr>
						<td class="field" valign="top">URN</td>
						<td class="data" valign="top">
							<xsl:value-of select="$finalConcept/@urn"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="$finalConcept/s:Description">
					<xsl:variable name="Description">
						<xsl:choose>
							<xsl:when test="$lang='notPassed' or not($finalConcept/s:Description[@xml:lang=$lang])">
								<xsl:value-of select="$finalConcept/s:Description[1]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$finalConcept/s:Description[@xml:lang=$lang]"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr>
						<td class="field" valign="top">Description</td>
						<td class="data" valign="top">
							<xsl:value-of select="$Description"/>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<td class="field" valign="top">Default Representation</td>
					<td class="data" valign="top">
						<xsl:apply-templates select="$finalConcept" mode="OutputDefaultRepresentationHTML"/>
					</td>
				</tr>
			</tbody>
		</table><br/>
		<xsl:for-each select="$finalConcept/s:Annotations/common:Annotation">
			<xsl:apply-templates select="." mode="Table"/>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template mode="CreateTypeHTML" match="s:Attribute | s:Dimension | s:TimeDimension | s:PrimaryMeasure | s:CrossSectionalMeasure">
		<xsl:choose>
			<xsl:when test="@codelist">
				<!-- Code List Was Specified -->
				<xsl:variable name="codelistKeyValue">
					<xsl:apply-templates select="." mode="GetCodelistKeyValue"/>
				</xsl:variable>
				<xsl:variable name="codelistKey">
					<xsl:call-template name="GetCodelistKey">
						<xsl:with-param name="search" select="$codelistKeyValue"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="codelist" select="key($codelistKey, $codelistKeyValue)"/>
				<xsl:choose>
					<xsl:when test="not($codelist)">
						<xsl:comment>Could not find codelist for <xsl:value-of select="local-name()"/>: <xsl:value-of select="@conceptRef"/> (<xsl:value-of select="$codelistKeyValue"/>)</xsl:comment>
					</xsl:when>
					<xsl:otherwise>
						<!-- Output Codelist -->
						<xsl:apply-templates select="$codelist" mode="OutputHTML"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="s:TextFormat">
				<!-- Text Format Was Specified -->
				<xsl:apply-templates mode="OutputHTML" select="s:TextFormat">
					<xsl:with-param name="conceptName" select="@conceptRef"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-- No Representation was supplied, need to check for default representation -->
				<!-- Get Concept -->
				<xsl:variable name="conceptKeyValue">
					<xsl:apply-templates mode="GetConceptKeyValue" select="."/>
				</xsl:variable>
				<xsl:variable name="conceptKey">
					<xsl:call-template name="GetConceptKey">
						<xsl:with-param name="search" select="$conceptKeyValue"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="concept" select="key($conceptKey, $conceptKeyValue)"/>
				<!-- Need to make sure we have only one concept, if not, get the latest version of the concept -->
				<xsl:variable name="conceptVersion">
					<xsl:for-each select="$concept">
						<xsl:sort select="@version"/>
						<xsl:sort select="parent::ConceptScheme/@version"/>
						<xsl:if test="position() = last()"><xsl:value-of select="concat(parent::ConceptScheme/@version, ':SDMX:', @version)"/></xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="useSchemeVersion" select="substring-before($conceptVersion, ':SDMX:')"/>
				<xsl:variable name="useConceptVersion" select="substring-after($conceptVersion, ':SDMX:')"/>
				<xsl:variable name="finalConcept" select="$concept[(parent::ConceptScheme/@version = $useSchemeVersion or not(parent::ConceptScheme) or $useSchemeVersion='') and (@version = $useConceptVersion or $useConceptVersion='')][1]"/>
				<xsl:apply-templates select="$finalConcept" mode="OutputDefaultRepresentationHTML">
					<xsl:with-param name="isTime">
						<xsl:choose>
							<xsl:when test="self::s:TimeDimension">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<!-- 
	-->
	<xsl:template mode="GetValueDescription" match="s:Attribute | s:Dimension | s:TimeDimension | s:PrimaryMeasure | s:CrossSectionalMeasure">
		<xsl:param name="value" select="'N/A'"/>
		<xsl:choose>
			<xsl:when test="@codelist">
				<!-- Code List Was Specified -->
				<xsl:variable name="codelistKeyValue">
					<xsl:apply-templates select="." mode="GetCodelistKeyValue"/>
				</xsl:variable>
				<xsl:variable name="codelistKey">
					<xsl:call-template name="GetCodelistKey">
						<xsl:with-param name="search" select="$codelistKeyValue"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="codelist" select="key($codelistKey, $codelistKeyValue)"/>
				<xsl:choose>
					<xsl:when test="not($codelist)">
						<xsl:value-of select="$value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$codelist" mode="GetValueDescription">
							<xsl:with-param name="value" select="$value"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="s:TextFormat">
				<!-- Text Format Was Specified -->
				<xsl:value-of select="$value"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- No Representation was supplied, need to check for default representation -->
				<!-- Get Concept -->
				<xsl:variable name="conceptKeyValue">
					<xsl:apply-templates mode="GetConceptKeyValue" select="."/>
				</xsl:variable>
				<xsl:variable name="conceptKey">
					<xsl:call-template name="GetConceptKey">
						<xsl:with-param name="search" select="$conceptKeyValue"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="concept" select="key($conceptKey, $conceptKeyValue)"/>
				<!-- Need to make sure we have only one concept, if not, get the latest version of the concept -->
				<xsl:variable name="conceptVersion">
					<xsl:for-each select="$concept">
						<xsl:sort select="@version"/>
						<xsl:sort select="parent::ConceptScheme/@version"/>
						<xsl:if test="position() = last()"><xsl:value-of select="concat(parent::ConceptScheme/@version, ':SDMX:', @version)"/></xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="useSchemeVersion" select="substring-before($conceptVersion, ':SDMX:')"/>
				<xsl:variable name="useConceptVersion" select="substring-after($conceptVersion, ':SDMX:')"/>
				<xsl:variable name="finalConcept" select="$concept[(parent::ConceptScheme/@version = $useSchemeVersion or not(parent::ConceptScheme) or $useSchemeVersion='') and (@version = $useConceptVersion or $useConceptVersion='')][1]"/>
				<xsl:apply-templates select="$finalConcept" mode="GetValueDescription">
					<xsl:with-param name="value" select="$value"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<xsl:template mode="GetName" match="s:Attribute | s:Dimension | s:TimeDimension | s:PrimaryMeasure | s:CrossSectionalMeasure">
		<!-- Get Concept -->
		<xsl:variable name="conceptKeyValue">
			<xsl:apply-templates mode="GetConceptKeyValue" select="."/>
		</xsl:variable>
		<xsl:variable name="conceptKey">
			<xsl:call-template name="GetConceptKey">
				<xsl:with-param name="search" select="$conceptKeyValue"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="concept" select="key($conceptKey, $conceptKeyValue)"/>
		<!-- Need to make sure we have only one concept, if not, get the latest version of the concept -->
		<xsl:variable name="conceptVersion">
			<xsl:for-each select="$concept">
				<xsl:sort select="@version"/>
				<xsl:sort select="parent::ConceptScheme/@version"/>
				<xsl:if test="position() = last()"><xsl:value-of select="concat(parent::ConceptScheme/@version, ':SDMX:', @version)"/></xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="useSchemeVersion" select="substring-before($conceptVersion, ':SDMX:')"/>
		<xsl:variable name="useConceptVersion" select="substring-after($conceptVersion, ':SDMX:')"/>
		<xsl:variable name="finalConcept" select="$concept[(parent::ConceptScheme/@version = $useSchemeVersion or not(parent::ConceptScheme) or $useSchemeVersion='') and (@version = $useConceptVersion or $useConceptVersion='')][1]"/>
		<xsl:choose>
			<xsl:when test="$lang='notPassed'">
				<xsl:value-of select="$finalConcept/s:Name[1]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$finalConcept/s:Name[@xml:lang=$lang]">
						<xsl:value-of select="$finalConcept/s:Name[@xml:lang=$lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$finalConcept/s:Name[1]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
