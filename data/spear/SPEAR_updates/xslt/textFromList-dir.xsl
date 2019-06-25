<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="2.0">

	<xsl:output omit-xml-declaration="yes" method="text" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:variable name="return">
		<xsl:text>	
		</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="outputDir">
		<xsl:text>[type here '../HTML/', '../text/', or '../XML/', depending on what you are transforming]</xsl:text>
	</xsl:variable>

<!--  Laura's code from Class 2
	  =========================
	<xsl:template match="list">
		<xsl:for-each select="item">
			<xsl:apply-templates select="document(@code)/tei:TEI"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="tei:TEI">
		<xsl:result-document>
			<xsl:apply-templates select="tei:text"/>
		</xsl:result-document>
	</xsl:template>
-->
	
<!-- for recursing through a directory -->
	<xsl:template match="list">
		<xsl:for-each select="item">
			<xsl:for-each select="collection(iri-to-uri(concat(@dir, '?select=*.xml')))">
				<xsl:variable name="outpath"
					select="concat($outputDir, substring-before(tokenize(document-uri(.), '/')[last()], '.xml'))"/>
				<xsl:result-document href="{concat($outpath, '.txt')}"> <!-- here you can change the '.txt' to '.xml' or '.html' depending
					upon which kinds of files you are producing -->
					<xsl:apply-templates select="tei:TEI/tei:text"/>
				</xsl:result-document>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>


	<!-- second part -->

	<xsl:template match="tei:head">
		<xsl:value-of select="$return"/>
		<xsl:apply-templates/>
		<xsl:value-of select="$return"/>
	</xsl:template>

	<xsl:template match="tei:title">
		<xsl:apply-templates/>
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

</xsl:stylesheet>
