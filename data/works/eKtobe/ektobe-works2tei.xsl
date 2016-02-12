<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:syriaca="http://syriaca.org">
    
    <!-- FORMAT OF COMMENTS -->
    <!-- ??? Indicates an issue that needs resolving. -->
    <!-- ALL CAPS is a section header. -->
    <!-- !!! Shows items that may need to be changed/customized when running this template on a new spreadsheet. -->
    <!-- lower case comments explain the code -->
    
    <!-- FILE OUTPUT PROCESSING -->
    <!-- specifies how the output file will look -->
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    
    
    <xsl:template match="/root">
        <xsl:for-each select="row">
            <xsl:variable name="id" select="4000+position()"/>
        <!-- creates a variable containing the path of the file to be created for this record, in the location defined by $directory -->
        <xsl:variable name="filename" select="concat('tei/',$id,'.xml')"/>
        
        
        <!-- creates the XML file, if the filename has been sucessfully created. -->
        <xsl:if test="$filename != ''">
            <xsl:result-document href="{$filename}" format="xml">
                <!-- adds the xml-model instruction with the link to the Syriaca.org validator -->
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="http://syriaca.org/documentation/syriaca-tei-main.rnc" type="application/relax-ng-compact-syntax"</xsl:text>
                </xsl:processing-instruction>
                
            <xsl:variable name="default-bib-id" select="concat('bib',$id,'-1')"></xsl:variable>
        
            <TEI xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:call-template name="header">
                    <xsl:with-param name="id" select="$id"/>
                    <xsl:with-param name="fr-title" select="Titre_français_normalisé"/>
                    <xsl:with-param name="syr-title" select="Titre_syriaque_normalisé"/>
                </xsl:call-template>
                <text>
                    <body>
                        <bibl>
                            <xsl:if test="Auteur!=''">
                                <author source="#{$default-bib-id}"><xsl:value-of select="normalize-space(Auteur)"/></author>
                            </xsl:if>
                            <xsl:if test="Titre_français_normalisé!=''">
                                <title xml:lang="fr" syriaca-tags="#eKtobe-headword" source="#{$default-bib-id}"><xsl:value-of select="normalize-space(Titre_français_normalisé)"/></title>
                            </xsl:if>
                            <xsl:if test="Autres_titres_français!=''">
                                <title xml:lang="fr" source="#{$default-bib-id}"><xsl:value-of select="normalize-space(Autres_titres_français)"/></title>
                            </xsl:if>
                            <xsl:if test="Titre_latin!=''">
                                <title xml:lang="la" source="#{$default-bib-id}"><xsl:value-of select="normalize-space(Titre_latin)"/></title>
                            </xsl:if>
                            <xsl:if test="Titre_syriaque_normalisé!=''">
                                <title xml:lang="syr" source="#{$default-bib-id}"><xsl:value-of select="normalize-space(Titre_syriaque_normalisé)"/></title>
                            </xsl:if>
                            <xsl:if test="Incipit_syriaque!=''">
                                <note type="incipit" xml:lang="syr" source="#{$default-bib-id}"><xsl:value-of select="normalize-space(Incipit_syriaque)"/></note>
                            </xsl:if>
                            <xsl:if test="Catégorie!=''">
                                <!-- not for publication, just internal processing -->
                                <note type="eKtobe-content-type" source="#{$default-bib-id}"><xsl:value-of select="normalize-space(Catégorie)"/></note>
                            </xsl:if>
                            <xsl:if test="Identifiant_dans_une_clavis!=''">
                                <note type="editions">
                                    <bibl source="#{$default-bib-id}"><xsl:value-of select="normalize-space(Identifiant_dans_une_clavis)"/></bibl>
                                </note>
                            </xsl:if>
                            <xsl:if test="cote_catalogue_et_notes_personnelles!=''">
                                <note type="MSS">
                                    <bibl source="#{$default-bib-id}"><xsl:value-of select="normalize-space(cote_catalogue_et_notes_personnelles)"/></bibl>
                                </note>
                            </xsl:if>
                            <bibl xml:id="{$default-bib-id}">
                                <title level="m" xml:lang="fr">E-ktobe: Manuscrits Syriaques</title>
                                <editor>
                                    <forename>André</forename>
                                    <surname>Binggeli</surname>
                                </editor>
                                <editor>
                                    <forename>Muriel</forename>
                                    <surname>Debié</surname>
                                </editor>
                                <editor>
                                    <forename>Françoise</forename>
                                    <surname>Briquel-Chatonnet</surname>
                                </editor>
                                <editor>
                                    <forename>Alain</forename>
                                    <surname>Desreumaux</surname>
                                </editor>
                                <ptr target="http://syriaca.org/foo"/>
                                <ptr target="http://www.mss-syriaques.org/"/>
                                <!-- citedRange target below should be link to query eKtobe on this work ID -->
                                <citedRange unit="URI" target="http://www.mss-syriaques.org/">http://syriaca.org/work/<xsl:value-of select="$id"/></citedRange>
                            </bibl>
                        </bibl>
                    </body>
                </text>
            
            </TEI>
        </xsl:result-document>
        </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="header">
        <xsl:param name="id"/>
        <xsl:param name="fr-title"/>
        <xsl:param name="syr-title"/>
        <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
            <fileDesc>
                <titleStmt>
                    <title level="a" xml:lang="fr"><xsl:value-of select="$fr-title"/> (text) — <foreign xml:lang="syr"><xsl:value-of select="$syr-title"/></foreign>
                    </title>
                    <title level="s">New Handbook of Syriac Literature</title>
                    <sponsor>Syriaca.org: The Syriac Reference Portal</sponsor>
                    <funder>The International Balzan Prize Foundation</funder>
                    <funder>The National Endowment for the Humanities</funder>
                    <principal>David A. Michelson</principal>
                    <editor role="general" ref="http://syriaca.org/documentation/editors.xml#ngibson">Nathan P. Gibson</editor>
                    <editor role="general" ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                        Michelson</editor>
                    <editor role="creator" ref="http://syriaca.org/documentation/editors.xml#ngibson">Nathan P. Gibson</editor>
                    <editor role="creator" ref="http://syriaca.org/documentation/editors.xml#abinggeli">André Binggeli</editor>
                    <editor role="creator" ref="http://syriaca.org/documentation/editors.xml#mdebie">Muriel Debié</editor>
                    <respStmt>
                        <resp>Editing, proofreading, data entry and revision by</resp>
                        <name type="person" ref="http://syriaca.org/documentation/editors.xml#ngibson">Nathan P. Gibson</name>
                    </respStmt>
                    <respStmt>
                        <resp>Data architecture and encoding by</resp>
                        <name type="person" ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                            Michelson</name>
                    </respStmt>
                    <respStmt>
                        <resp>Entries adapted from the work of</resp>
                        <name type="person" ref="http://syriaca.org/documentation/editors.xml#abinggeli">André Binggeli</name>
                    </respStmt>
                    <respStmt>
                        <resp>Entries adapted from the work of</resp>
                        <name type="person" ref="http://syriaca.org/documentation/editors.xml#mdebie">Muriel Debié</name>
                    </respStmt>
                </titleStmt>
                <editionStmt>
                    <edition n="1.0"/>
                </editionStmt>
                <publicationStmt>
                    <authority>Syriaca.org: The Syriac Reference Portal</authority>
                    <idno type="URI">http://syriaca.org/work/<xsl:value-of select="$id"/>/tei</idno>
                    <availability>
                        <licence target="http://creativecommons.org/licenses/by/3.0/">
                            <p>Distributed under a Creative Commons Attribution 3.0 Unported
                                License.</p>
                            <p>This entry incorporates copyrighted material from the following
                                work(s): <listBibl>
                                    <bibl>
                                        <ptr target="http://syriaca.org/bibl/649"/>
                                    </bibl>
                                </listBibl>
                                <note>used under a Creative Commons Attribution license <ref target="http://creativecommons.org/licenses/by/3.0/"/>
                                </note>
                            </p>
                        </licence>
                    </availability>
                    <date><xsl:value-of select="current-dateTime()"/></date>
                </publicationStmt>
                <seriesStmt>
                    <title level="s">New Handbook of Syriac Literature</title>
                    <editor role="general" ref="http://syriaca.org/documentation/editors.xml#ngibson">Nathan P.
                        Gibson</editor>
                    <editor role="general" ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                        Michelson</editor>
                    <respStmt>
                        <resp>Edited by</resp>
                        <name type="person" ref="http://syriaca.org/documentation/editors.xml#ngibson">Nathan P.
                            Gibson</name>
                    </respStmt>
                    <respStmt>
                        <resp>Edited by</resp>
                        <name type="person" ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                            Michelson</name>
                    </respStmt>
                    <biblScope unit="vol">2</biblScope>
                    <idno type="URI">http://syriaca.org/works</idno>
                </seriesStmt>
                <sourceDesc>
                    <p>Born digital.</p>
                </sourceDesc>
            </fileDesc>
            <encodingDesc>
                <editorialDecl>
                    <p>This record created following the Syriaca.org guidelines. Documentation
                        available at: <ref target="http://syriaca.org/documentation">http://syriaca.org/documentation</ref>.</p>
                    <interpretation>
                        <p>Approximate dates described in terms of centuries or partial centuries
                            have been interpreted as documented in the Syriaca.org guidelines for
                            date encoding <ref target="http://syriaca.org/documentation/dates.html">http://syriaca.org/documentation/dates.html</ref>.</p>
                    </interpretation>
                </editorialDecl>
                <classDecl>
                    <taxonomy>
                        <category xml:id="syriaca-headword">
                            <catDesc>The name used by Syriaca.org for document titles, citation, and
                                disambiguation. These names have been created according to the
                                Syriaca.org guidelines for headwords: <ref target="http://syriaca.org/documentation/headwords.html">http://syriaca.org/documentation/headwords.html</ref>.</catDesc>
                        </category>
                        <category xml:id="syriaca-anglicized">
                            <catDesc>An anglicized version of a name created by Syriaca.org used to
                                facilitate searching in English.</catDesc>
                        </category>
                    </taxonomy>
                </classDecl>
            </encodingDesc>
            <profileDesc>
                <langUsage>
                    <language ident="ar-syr">Arabic Karshuni in Syriac Characters</language>
                    <language ident="ar">Arabic</language>
                    <language ident="cop">Coptic</language>
                    <language ident="cu">Old Church Slavonic</language>
                    <language ident="de">German</language>
                    <language ident="en-x-gedsh">Names or terms Romanized into English according to
                        the standards adopted by the Gorgias Encyclopedic Dictionary of the Syriac
                        Heritage</language>
                    <language ident="en">English</language>
                    <language ident="es">Spanish</language>
                    <language ident="fr-x-bhs">Names or terms Romanized into French according to the
                        standards adopted by the Bibliotheca Hagiographica Syriaca</language>
                    <language ident="fr">French</language>
                    <language ident="gez">Ge'ez</language>
                    <language ident="gr">German</language>
                    <language ident="grc">Ancient or Medieval Greek</language>
                    <language ident="hy">Classical or Modern Armenian</language>
                    <language ident="it">Italian</language>
                    <language ident="ka">Classical or Modern Georgian</language>
                    <language ident="la">Latin</language>
                    <language ident="nl">Dutch</language>
                    <language ident="pt">Portugese</language>
                    <language ident="ru">Russian</language>
                    <language ident="sog">Soghdian</language>
                    <language ident="syr-pal">Syro-Palestinian</language>
                    <language ident="syr-Syrj">Vocalized West Syriac</language>
                    <language ident="syr-Syrn">Vocalized East Syriac</language>
                    <language ident="syr">Unvocalized Syriac of any variety or period</language>
                </langUsage>
            </profileDesc>
            <revisionDesc status="draft">
                <change who="http://syriaca.org/documentation/editors.xml#wsalesky" when="2015-11-05-06:00">
                    Added xml:id attributes to note/bibl elements and updated note/bib/corresp attributes to match new xml:ids.  
                </change>
                <change who="http://syriaca.org/documentation/editors.xml#wsalesky" when="2015-11-02-06:00">
                    Added xml:id attributes to manuscript notes for all MSS notes without xml:ids.  
                </change>
                <change who="http://syriaca.org/documentation/editors.xml#wsalesky" when="2015-10-20-05:00">Added relation element with related persons URIs</change>
                <change who="http://syriaca.org/documentation/editors.xml#wsalesky" when="2015-10-19-05:00">
                    Added xml:id attributes to manuscript notes and corresp attributes to the corresponding editions notes for all BHSE records.  
                </change>
                <change who="http://syriaca.org/documentation/editors.xml#dmichelson" n="1.0" when="2015-10-13-04:00">CREATED: work</change>
            </revisionDesc>
        </teiHeader>
    </xsl:template>
    
    
</xsl:stylesheet>