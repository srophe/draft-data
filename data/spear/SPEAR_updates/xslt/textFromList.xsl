<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="2.0">

	<xsl:output omit-xml-declaration="yes" method="text" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:variable name="return">
		<xsl:text>	
		</xsl:text>
	</xsl:variable>


	<xsl:template match="list">
		<xsl:for-each select="item">
			<xsl:apply-templates select="document(@code)/tei:TEI">
				<xsl:with-param name="xpathFilename" select="@code"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="tei:TEI">
		<xsl:param name="xpathFilename"/>
		<xsl:variable name="Filename">
			<xsl:value-of select="substring-before($xpathFilename, '.xml')"/>
		</xsl:variable>
		<xsl:result-document href="{$Filename}.txt">
			<xsl:apply-templates select="tei:text/tei:body/tei:div"/>
		</xsl:result-document>
	</xsl:template>

	<!-- second part -->

	<xsl:template match="tei:head">
		<xsl:value-of select="$return"/>
		<xsl:apply-templates/>
		<xsl:value-of select="$return"/>
	</xsl:template>

	<xsl:template match="tei:byline">
		<xsl:value-of select="$return"/>
		<xsl:apply-templates/>
		<xsl:value-of select="$return"/>
	</xsl:template>

	<xsl:template match="tei:lg">
		<xsl:value-of select="$return"/>
		<xsl:value-of select="$return"/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:value-of select="$return"/>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="tei:p">
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>
