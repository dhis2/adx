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
	
	<xsl:template mode="OutputDefaultRepresentation" match="s:Concept">
		<xsl:param name="originalConcept" select="s:Concept/@id"/>
		<xsl:param name="prevCodeLists"/>
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
(@version = $SchemeVersion or not(boolean($SchemeVersion)))]/s:Concept[@id = $ID and (@version = $Version or not(boolean(@version)))]" mode="OutputDefaultRepresentation">
							<xsl:with-param name="originalConcept" select="$originalConcept"/>
							<xsl:with-param name="prevCodeLists" select="$prevCodeLists"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$externalDoc/m:Structure/m:Concepts/s:Concept[@id = $ID and (@agencyID=$Agency or not(boolean(@agencyID))) and (@version=$Version or not(boolean(@version)))]" mode="OutputDefaultRepresentation">
							<xsl:with-param name="originalConcept" select="$originalConcept"/>							
							<xsl:with-param name="prevCodeLists" select="$prevCodeLists"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@parent">
						<xsl:variable name="ID" select="@parent"/>
						<xsl:apply-templates select="parent::s:ConceptScheme/s:Concept[@id = $ID]" mode="OutputDefaultRepresentation">
							<xsl:with-param name="originalConcept" select="$originalConcept"/>
							<xsl:with-param name="prevCodeLists" select="$prevCodeLists"/>
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
						<xsl:variable name="codelist" select="ancestor::m:Structure/m:CodeLists/s:CodeList[@id = $ID and (@agencyID=$Agency or not(boolean($Agency)))]"/>
						<xsl:choose>
							<xsl:when test="contains($prevCodeLists, concat(':', $codelist/@id, ':'))">
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="$codelist" mode="Output"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="s:TextFormat">
						<xsl:apply-templates mode="Output" select="s:TextFormat">
							<xsl:with-param name="conceptName" select="$originalConcept"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<!-- No output here, since it could be a Time concept, and therefore a type is not needed -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="GetDefaultType" match="s:Concept">
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
(@version = $SchemeVersion or not(boolean($SchemeVersion)))]/s:Concept[@id = $ID and (@version = $Version or not(boolean(@version)))]" mode="GetDefaultType"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$externalDoc/m:Structure/m:Concepts/s:Concept[@id = $ID and (@agencyID=$Agency or not(boolean(@agencyID))) and (@version=$Version or not(boolean(@version)))]" mode="GetDefaultType"/>
					</xsl:otherwise>
				</xsl:choose>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@parent">
						<xsl:variable name="ID" select="@parent"/>
						<xsl:apply-templates select="parent::s:ConceptScheme/s:Concept[@id = $ID]" mode="GetDefaultType"/>
					</xsl:when>
					<xsl:when test="@coreRepresentation">
						<xsl:value-of select="@coreRepresentation"/>
					</xsl:when>
					<xsl:when test="s:TextFormat">
						<xsl:value-of select="'TextType'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'None'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="IsDefaultTimespan" match="s:Concept">
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
						<xsl:apply-templates select="$externalDoc/m:Structure/m:Concepts/s:ConceptScheme[@id = $SchemeID and @agencyID = $SchemeAgency and (@version=$SchemeVersion or not(boolean($SchemeVersion)))]/s:Concept[@id = $ID and (@version=$Version or not(boolean($Version)))]" mode="IsDefaultTimespan"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$externalDoc/m:Structure/m:Concepts/s:Concept[@id = $ID and (@agencyID=$Agency or not(boolean($Agency))) and (@version=$Version or not(boolean($Version)))]" mode="IsDefaultTimespan"/>
					</xsl:otherwise>
				</xsl:choose>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@parent">
						<xsl:variable name="ID" select="@parent"/>
						<xsl:apply-templates select="parent::s:ConceptScheme/s:Concept[@id = $ID]" mode="IsDefaultTimespan"/>
					</xsl:when>
					<xsl:when test="@coreRepresentation">
						<xsl:value-of select="'false'"/>
					</xsl:when>
					<xsl:when test="s:TextFormat">
						<xsl:choose>
							<xsl:when test="s:TextFormat/@textType='Timespan'"><xsl:value-of select="'true'"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'false'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
	Template to output a codelist as a simpleType.
	-->
	<xsl:template match="s:CodeList" mode="Output">
		<xsl:choose>
			<xsl:when test="@isExternalReference = 'true'">
				<!-- If a codelist is an external reference, the codelist will be retrieved
				from the external source. -->
				<xsl:variable name="externalDoc" select="document(@uri, .)"/>
				<xsl:variable name="ID" select="@id"/>
				<xsl:variable name="Agency" select="@agencyID"/>
				<xsl:variable name="Version" select="@version"/>
				<xsl:apply-templates select="$externalDoc/m:Structure/m:CodeLists/s:CodeList[@id=$ID and (@agencyID=$Agency or not(boolean($Agency))) and (@version=$Version or not(boolean($Version)))]" mode="Output"/>				
			</xsl:when>
			<xsl:otherwise>
				<!-- If the codelist is found and not external, output the simpleType -->
				<xsl:element name="xs:simpleType">
					<xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
					<xsl:element name="xs:restriction">
						<xsl:attribute name="base">xs:string</xsl:attribute>
						<xsl:for-each select="s:Code">
							<xsl:element name="xs:enumeration">
								<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
								<xsl:element name="xs:annotation">
									<xsl:for-each select="s:Description">
										<xsl:element name="xs:documentation">
											<xsl:for-each select="@*">
												<xsl:copy/>
											</xsl:for-each>
											<xsl:value-of select="."/>
										</xsl:element>
										<!--Close xs:documentation-->
									</xsl:for-each>
								</xsl:element>
								<!--Close xs:annotation-->
							</xsl:element>
							<!--Close xs:enumeration-->
						</xsl:for-each>
					</xsl:element>
					<!--Close xs:restriction-->
				</xsl:element>
				<!--Close xs:simpleType-->				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
	Template to output TextFormat as a simpleType or complexType.
	-->
	<xsl:template match="s:TextFormat" mode="Output">
		<xsl:param name="conceptName"/>
		<xsl:choose>
			<xsl:when test="@textType = 'Timespan'">
				<!-- 
				No type needs to be generated for a Timespan.
				This designates that the attribute or measure to be created will
				have a type of xs:duration. In addition, another attribute will be created.
				 -->
			</xsl:when>
			<xsl:otherwise>
				<xs:simpleType name="{$conceptName}Type">
					<xs:restriction>
						<xsl:attribute name="base">
							<xsl:choose>
								<xsl:when test="@textType = 'String'">xs:string</xsl:when>
								<xsl:when test="@textType = 'BigInteger'">xs:integer</xsl:when>
								<xsl:when test="@textType = 'Integer'">xs:int</xsl:when>
								<xsl:when test="@textType = 'Long'">xs:long</xsl:when>
								<xsl:when test="@textType = 'Short'">xs:short</xsl:when>
								<xsl:when test="@textType = 'Decimal'">xs:decimal</xsl:when>
								<xsl:when test="@textType = 'Float'">xs:float</xsl:when>
								<xsl:when test="@textType = 'Double'">xs:double</xsl:when>
								<xsl:when test="@textType = 'Boolean'">xs:boolean</xsl:when>
								<xsl:when test="@textType = 'DateTime'">xs:dateTime</xsl:when>
								<xsl:when test="@textType = 'Time'">xs:time</xsl:when>
								<xsl:when test="@textType = 'Date'">xs:date</xsl:when>
								<xsl:when test="@textType = 'Year'">xs:gYear</xsl:when>
								<xsl:when test="@textType = 'Month'">xs:gMonth</xsl:when>
								<xsl:when test="@textType = 'Day'">xs:gDay</xsl:when>
								<xsl:when test="@textType = 'MonthDay'">xs:gMonthDay</xsl:when>
								<xsl:when test="@textType = 'YearMonth'">xs:gYearMonth</xsl:when>
								<xsl:when test="@textType = 'Duration'">xs:duration</xsl:when>
								<xsl:when test="@textType = 'URI'">xs:anyURI</xsl:when>
								<xsl:when test="@textType = 'Count'">xs:integer</xsl:when>
								<xsl:when test="@textType = 'InclusiveValueRange'">xs:double</xsl:when>
								<xsl:when test="@textType = 'ExclusiveValueRange'">xs:double</xsl:when>
								<xsl:when test="@textType = 'Incremental'">xs:double</xsl:when>
								<xsl:otherwise>xs:string</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="@textType = 'ExclusiveValueRange'">
								<xsl:element name="xs:minExclusive">
									<xsl:attribute name="value">
										<xsl:value-of select="@startValue"/>
									</xsl:attribute>
								</xsl:element>
								<xsl:element name="xs:maxExclusive">
									<xsl:attribute name="value">
										<xsl:value-of select="@endValue"/>
									</xsl:attribute>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="@minLength">
									<xsl:element name="xs:minLength">
										<xsl:attribute name="value">
											<xsl:value-of select="@minLength"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="@maxLength">
									<xsl:element name="xs:maxLength">
										<xsl:attribute name="value">
											<xsl:value-of select="@maxLength"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="@startValue">
									<xsl:element name="xs:minInclusive">
										<xsl:attribute name="value">
											<xsl:value-of select="@startValue"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="@endValue">
									<xsl:element name="xs:maxInclusive">
										<xsl:attribute name="value">
											<xsl:value-of select="@endValue"/>	
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="@decimals">
									<xsl:element name="xs:fractionDigits">
										<xsl:attribute name="value">
											<xsl:value-of select="@decimals"/>	
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="@patern">
									<xsl:element name="xs:pattern">
										<xsl:attribute name="value">
											<xsl:value-of select="@pattern"/>	
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xs:restriction>
				</xs:simpleType>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 
	This template creates the complexTypes and simpleTypes used to represent dimensions, measures, and attributes.
	It will first check the representation of the component itself. If none is supplied, then the default representation
	will be taken from the concept.
	-->
	<xsl:template mode="CreateTypes" match="s:Attribute | s:Dimension | s:TimeDimension | s:PrimaryMeasure | s:CrossSectionalMeasure">
		<xsl:variable name="PrevCodeLists">
			<xsl:for-each select="preceding-sibling::*">
				:<xsl:apply-templates mode="GetType" select="."/>:
			</xsl:for-each>
		</xsl:variable>
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
						<xsl:choose>
							<xsl:when test="contains($PrevCodeLists, concat(':',$codelist/@id,':'))">
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="$codelist" mode="Output"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="s:TextFormat">
				<!-- Text Format Was Specified -->
				<xsl:apply-templates mode="Output" select="s:TextFormat">
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
				<xsl:variable name="finalConcept" select="$concept[(parent::s:ConceptScheme/@version = $useSchemeVersion or not(boolean(parent::s:ConceptScheme)) or not(boolean(parent::s:ConceptScheme/@version))) and (@version = $useConceptVersion or not(boolean(@version)))][1]"/>
				<xsl:apply-templates select="$finalConcept" mode="OutputDefaultRepresentation">
					<xsl:with-param name="originalConcept" select="@conceptRef"/>
					<xsl:with-param name="prevCodeLists" select="$PrevCodeLists"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<xsl:template mode="GetType" match="s:Attribute | s:Dimension | s:PrimaryMeasure | s:CrossSectionalMeasure | s:TimeDimension">
		<xsl:choose>
			<xsl:when test="@codelist"><xsl:value-of select="@codelist"/></xsl:when>
			<xsl:when test="s:TextFormat"><xsl:value-of select="concat(@conceptRef, 'Type')"/></xsl:when>
			<xsl:otherwise>
				<xsl:variable name="type">
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
							<xsl:if test="position() = last()"><xsl:value-of select="concat(parent::s:ConceptScheme/@version, ':SDMX:', @version)"/></xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="useSchemeVersion" select="substring-before($conceptVersion, ':SDMX:')"/>
					<xsl:variable name="useConceptVersion" select="substring-after($conceptVersion, ':SDMX:')"/>
					<xsl:variable name="finalConcept" select="$concept[(parent::s:ConceptScheme/@version = $useSchemeVersion or not(boolean(parent::s:ConceptScheme)) or not(boolean(parent::s:ConceptScheme/@version))) and (@version = $useConceptVersion or not(boolean(@version)))][1]"/>
					<xsl:apply-templates select="$finalConcept" mode="GetDefaultType"/>				
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$type='TextType'">
						<xsl:value-of select="concat(@conceptRef, 'Type')"/>
					</xsl:when>
					<xsl:when test="$type='None'">
						<xsl:choose>
							<xsl:when test="self::s:TimeDimension">
								<xsl:value-of select="'common:TimePeriodType'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'xs:string'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>	
					<xsl:otherwise>
						<xsl:value-of select="$type"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 
	This template will check whether a give Key Family component is a time span.
	-->
	<xsl:template name="IsTimespan">
		<xsl:choose>
			<xsl:when test="@codelist">
				<xsl:value-of select="'false'"/>
			</xsl:when>
			<xsl:when test="s:TextFormat">
				<xsl:choose>
					<xsl:when test="s:TextFormat/@textType='Timespan'"><xsl:value-of select="'true'"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
				</xsl:choose>
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
				<xsl:variable name="finalConcept" select="$concept[(parent::conceptScheme/@version = $useSchemeVersion or not(parent::conceptScheme)) and @version = $useConceptVersion][1]"/>
				<xsl:apply-templates select="$finalConcept" mode="IsDefaultTimespan"/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
		
</xsl:stylesheet>
