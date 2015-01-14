<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" 
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
	<xsl:param name="isSingleDoc">false</xsl:param>

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
				
				<xsl:call-template name="MainDocument">
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
					<xsl:with-param name="KFID" select="$KFID"/>
				</xsl:call-template>
	
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
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="MainDocument">
		<xsl:param name="KeyFamName"/>
		<xsl:param name="KFID"/>
		<head>
			<title lang="{$KeyFamName/@xml:lang}"><xsl:value-of select="$KeyFamName"/></title>
		</head>
		<frameset rows="22%, 78%">
			<frame src="{$KFID}/Header.html"/>
			<frameset cols="20%, 80%">
				<frame src="{$KFID}/Menu.html"/>
				<frame src="{$KFID}/Instructions.html" name="Main"/>
			</frameset>
		</frameset>
	</xsl:template>

	<xsl:template name="Header">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/Header.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body><h1><img src="../SDMXLogo.gif" alt="Statistical Data and Metadata Exchange"/><br/><xsl:value-of select="$KeyFamName"/></h1></body>
		</xsl:document>
	</xsl:template>
	
	<xsl:template name="Menu">
		<xsl:param name="KeyFamName"/>
		<xsl:param name="KFID"/>
		<xsl:document href="{$KFID}/Menu.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<a href="Instructions.html" target="Main" class="menuitem">Instructions</a><br/>
				<a href="Basic.html" target="Main" class="menuitem">Basic Information</a><br/>
				<a href="Dimensions.html" target="Main" class="menuitem">Dimensions</a><br/>
				<a href="Attributes.html" target="Main" class="menuitem">Attributes</a><br/>
				<xsl:if test="s:Components/s:Group">
					<a href="Groups.html" target="Main" class="menuitem">Groups</a><br/>
				</xsl:if>
				<xsl:if test="s:Components/s:CrossSectionalMeasure or s:Components/*/@*[contains(name(), 'crossSectionalAttach')]['true']">
					<a href="CrossSectional.html" target="Main" class="menuitem">Cross Sectional Information</a><br/>
				</xsl:if>
			</body>
		</xsl:document>
	</xsl:template>

	<xsl:template name="Instructions">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/Instructions.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<p>
				This reference provides a view of the details of the <xsl:value-of select="$KeyFamName"/> key family.  Use the links at the left to view 				the details of the key family.  The content of these sections are described below.  To return to any previous window, use your browsers 				Back button.
				</p>
				<xsl:call-template name="InstructionsContent"/>
			</body>
		</xsl:document>
	</xsl:template>

	<xsl:template name="Basic">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/Basic.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<xsl:call-template name="BasicsContent">
					<xsl:with-param name="KFID" select="$KFID"/>
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
				</xsl:call-template>		
			</body>
		</xsl:document>
	</xsl:template>
	
	<xsl:template name="Dimensions">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/Dimensions.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<xsl:call-template name="DimensionsContent">
					<xsl:with-param name="KFID" select="$KFID"/>
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
				</xsl:call-template>		
			</body>
		</xsl:document>
	</xsl:template>

	<xsl:template name="Attributes">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/Attributes.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<xsl:call-template name="AttributesContent">
					<xsl:with-param name="KFID" select="$KFID"/>
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
				</xsl:call-template>		
			</body>
		</xsl:document>
	</xsl:template>

	<xsl:template name="Groups">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/Groups.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<xsl:call-template name="GroupsContent">
					<xsl:with-param name="KFID" select="$KFID"/>
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
				</xsl:call-template>		
			</body>
		</xsl:document>
	</xsl:template>

	<xsl:template name="Cross">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/CrossSectional.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<xsl:call-template name="CrossContent">
					<xsl:with-param name="KFID" select="$KFID"/>
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
				</xsl:call-template>		
			</body>
		</xsl:document>
	</xsl:template>

	<xsl:template match="s:Dimension | s:TimeDimension" mode="Page">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/Dim{@conceptRef}.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<xsl:call-template name="DimOrAttPageContent">
					<xsl:with-param name="KFID" select="$KFID"/>
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
				</xsl:call-template>		
			</body>
		</xsl:document>
	</xsl:template>

	<xsl:template match="s:Attribute | s:PrimaryMeasure" mode="Page">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/Att{@conceptRef}.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<xsl:call-template name="DimOrAttPageContent">
					<xsl:with-param name="KFID" select="$KFID"/>
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
				</xsl:call-template>		
			</body>
		</xsl:document>
	</xsl:template>

	<xsl:template match="s:Dimension | s:TimeDimension | s:Attribute | s:PrimaryMeasure | s:CrossSectionalMeasure" mode="Codes">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:variable name="Type">
			<xsl:apply-templates select="." mode="GetType"/>
		</xsl:variable>
		<xsl:if test="$Type!='common:TimePeriodType' and $Type!='xs:string'">
			<xsl:document href="{$KFID}/{$Type}.html" method="html" version="4.0" indent="yes">
				<xsl:call-template name="Head">
					<xsl:with-param name="KFID" select="$KFID"/>
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
				</xsl:call-template>
				<body>
					<xsl:apply-templates select="." mode="CreateTypeHTMLPage">
						<xsl:with-param name="KFID" select="$KFID"/>
					</xsl:apply-templates>
				</body>
			</xsl:document>
		</xsl:if>
	</xsl:template>

	<xsl:template match="s:Dimension | s:TimeDimension | s:Attribute | s:PrimaryMeasure | s:CrossSectionalMeasure" mode="Concepts">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/{@conceptRef}.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<xsl:apply-templates select="." mode="CreateConceptHTMLPage">
					<xsl:with-param name="KFID" select="$KFID"/>
				</xsl:apply-templates>
			</body>
		</xsl:document>
	</xsl:template>

	<xsl:template match="s:Group" mode="Page">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/Grp{@id}.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<xsl:call-template name="GroupPageContent">
					<xsl:with-param name="KFID" select="$KFID"/>
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
				</xsl:call-template>		
			</body>
		</xsl:document>
	</xsl:template>

	<xsl:template match="s:CrossSectionalMeasure" mode="Page">
		<xsl:param name="KFID"/>
		<xsl:param name="KeyFamName"/>
		<xsl:document href="{$KFID}/CSM{@conceptRef}.html" method="html" version="4.0" indent="yes">
			<xsl:call-template name="Head">
				<xsl:with-param name="KFID" select="$KFID"/>
				<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
			</xsl:call-template>
			<body>
				<xsl:call-template name="CrossPageContent">
					<xsl:with-param name="KFID" select="$KFID"/>
					<xsl:with-param name="KeyFamName" select="$KeyFamName"/>
				</xsl:call-template>		
			</body>
		</xsl:document>
	</xsl:template>

</xsl:stylesheet>
