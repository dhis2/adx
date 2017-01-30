<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>

	<xsl:template name="break-free-text">
		<xsl:param name="free-text"/>
		<xsl:choose>
			<xsl:when test="string-length($free-text)>350">
				<xsl:call-template name="break-free-text">
					<xsl:with-param name="free-text" select="substring($free-text,1,350)"/>
				</xsl:call-template>
FTX+ACM+++<xsl:call-template name="break-free-text"><xsl:with-param name="free-text" select="substring($free-text, 351)"/></xsl:call-template>
			</xsl:when>
			<xsl:when test="string-length($free-text)>70">
				<xsl:value-of select="concat(substring($free-text,1,70),':')"/>
				<xsl:call-template name="break-free-text">
					<xsl:with-param name="free-text" select="substring($free-text,71)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$free-text"/>'</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="escape-chars">
		<xsl:param name="string"/>
		<xsl:variable name="apos" select='"&apos;"'/>
		<xsl:variable name="colon" select="':'"/>
		<xsl:variable name="plus" select="'+'"/>
		<xsl:variable name="ques" select="'?'"/>
		<xsl:choose>
			<xsl:when test="contains($string, $apos) or contains($string, $colon) or contains($string, $plus) or contains($string, $ques)">
				<xsl:variable name="apos_sub">
					<xsl:choose>
						<xsl:when test="contains($string, $apos)">
							<xsl:value-of select="substring-before($string, $apos)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$string"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="colon_sub">
					<xsl:choose>
						<xsl:when test="contains($string, $colon)">
							<xsl:value-of select="substring-before($string, $colon)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$string"/>
						</xsl:otherwise>
					</xsl:choose>				
				</xsl:variable>
				<xsl:variable name="plus_sub">
					<xsl:choose>
						<xsl:when test="contains($string, $plus)">
							<xsl:value-of select="substring-before($string, $plus)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$string"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="ques_sub">
					<xsl:choose>
						<xsl:when test="contains($string, $ques)">
							<xsl:value-of select="substring-before($string, $ques)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$string"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="string-length($apos_sub) &lt; string-length($colon_sub) and string-length($apos_sub) &lt; string-length($plus_sub) and string-length($apos_sub) &lt; string-length($ques_sub)">
						<xsl:value-of select="substring-before($string, $apos)"/>
						<xsl:text>?'</xsl:text>
						<xsl:call-template name="escape-chars">
							<xsl:with-param name="string" select="substring-after($string, $apos)"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="string-length($colon_sub) &lt; string-length($apos_sub) and string-length($colon_sub) &lt; string-length($plus_sub) and string-length($colon_sub) &lt; string-length($ques_sub)">
						<xsl:value-of select="substring-before($string, $colon)"/>
						<xsl:text>?:</xsl:text>
						<xsl:call-template name="escape-chars">
							<xsl:with-param name="string" select="substring-after($string, $colon)"/>
						</xsl:call-template>					
					</xsl:when>
					<xsl:when test="string-length($plus_sub) &lt; string-length($apos_sub) and string-length($plus_sub) &lt; string-length($colon_sub) and string-length($plus_sub) &lt; string-length($ques_sub)">
						<xsl:value-of select="substring-before($string, $plus)"/>
						<xsl:text>?+</xsl:text>
						<xsl:call-template name="escape-chars">
							<xsl:with-param name="string" select="substring-after($string, $plus)"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="string-length($ques_sub) &lt; string-length($apos_sub) and string-length($ques_sub) &lt; string-length($colon_sub) and string-length($ques_sub) &lt; string-length($plus_sub)">
						<xsl:value-of select="substring-before($string, $ques)"/>
						<xsl:text>??</xsl:text>
						<xsl:call-template name="escape-chars">
							<xsl:with-param name="string" select="substring-after($string, $ques)"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
</xsl:stylesheet>
