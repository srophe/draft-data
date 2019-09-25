<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="list">
        <xsl:for-each select="item">
            <xsl:apply-templates select="document(@code)/TEI">
                <xsl:with-param name="xpathFilename" select="@code"/>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="TEI">
        <xsl:param name="xpathFilename"/>
        <xsl:variable name="Filename">
            <xsl:value-of select="concat('XML/', $xpathFilename)"/>
        </xsl:variable>
        <xsl:result-document href="{$Filename}">
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
        </xsl:result-document>
    </xsl:template>

   <xsl:template match="div">
       <div xmlns="http://www.tei-c.org/ns/1.0">
           <xsl:attribute name="type">
               <xsl:value-of select="@type"/>
           </xsl:attribute>
           <xsl:attribute name="xml:id">
               <xsl:value-of select="concat('factoid-', substring-after(@uri, '-'))"/>
           </xsl:attribute>
           <xsl:attribute name="resp">
               <xsl:value-of select="@resp"/>
           </xsl:attribute>
           <idno type="URI">
               <xsl:value-of select="@uri"/>
           </idno>
           <xsl:choose>
               <xsl:when test="listEvent">
                   
                       <xsl:apply-templates select="listEvent"/>
                   
               </xsl:when>
               <xsl:when test="listPerson">
                   
                       <xsl:apply-templates select="listPerson"/>
                   
               </xsl:when>
               <xsl:when test="listRelation">
                   
                       <xsl:apply-templates select="listRelation"/>
                   
               </xsl:when>
           </xsl:choose>
           
           <xsl:apply-templates select="bibl"/>
           
           <xsl:if test="note">
               <xsl:apply-templates select="note"/>
           </xsl:if>
       </div>
   </xsl:template>
    
    <!--    education | occupation | langKnown | state | trait | socecStatus-->
    
   <xsl:template match="education">
       <education xmlns="http://www.tei-c.org/ns/1.0">
           <xsl:attribute name="ana">
               <xsl:value-of select="@ref"/>
           </xsl:attribute>
           <xsl:apply-templates select="note"/>
       </education>
   </xsl:template>
    
    <xsl:template match="occupation">
        <occupation xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="ana">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates select="note"/>
        </occupation>
    </xsl:template>
    
    <xsl:template match="langKnown">
        <langKnown xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="ana">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates select="note"/>
        </langKnown>
    </xsl:template>
    
    <xsl:template match="state">
        <state xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
            <xsl:attribute name="ana">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates select="note"/>
        </state>
    </xsl:template>
    
    <xsl:template match="socecStatus">
        <socecStatus xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="ana">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates select="note"/>
        </socecStatus>
    </xsl:template>
    
    <xsl:template match="trait">
       <trait xmlns="http://www.tei-c.org/ns/1.0">
           <xsl:attribute name="type">
               <xsl:value-of select="@type"/>
           </xsl:attribute>
           <xsl:attribute name="ana">
               <xsl:value-of select="@ref"/>
           </xsl:attribute>
           <xsl:apply-templates select="note"/>
       </trait>
   </xsl:template>
    
   <xsl:template match="event">
       <event xmlns="http://www.tei-c.org/ns/1.0">
           <xsl:attribute name="ana">
               <xsl:value-of select="ptr/@target"/>
           </xsl:attribute>
               <xsl:apply-templates select="desc"/>
       </event>
   </xsl:template>
    
    <xsl:template match="desc">
        <desc xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </desc>
    </xsl:template>
    
    <xsl:template match="bibl">
        <bibl xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@type"/>
            <xsl:choose>
                <xsl:when test="@xml:id">
                    <xsl:apply-templates select="@xml:id"/>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </bibl>
    </xsl:template>
        
</xsl:stylesheet>