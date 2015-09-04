<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:syriaca="http://syriaca.org" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:functx="http://www.functx.com">

    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    <xsl:variable name="n">
        <xsl:text/>
    </xsl:variable>
    <xsl:variable name="s">
        <xsl:text> </xsl:text>
    </xsl:variable>

    <xsl:function name="syriaca:ancientlangs" as="xs:string*">
        <!-- The spreadsheet presents ancient langs as prose, this converts the prose language names to IDO codes-->
        <xsl:param name="AncientLang" as="xs:string*"/>
        <xsl:choose>
            <xsl:when test="normalize-space($AncientLang) ='Latin'">
                <xsl:text>la</xsl:text>
            </xsl:when>
            <xsl:when test="normalize-space($AncientLang)='Greek'">
                <xsl:text>grc</xsl:text>
            </xsl:when>
            <xsl:when test="normalize-space($AncientLang)='Arabic'">
                <xsl:text>ar</xsl:text>
            </xsl:when>
            <xsl:when test="normalize-space($AncientLang)='Armenian'">
                <xsl:text>hy</xsl:text>
            </xsl:when>
            <xsl:when test="normalize-space($AncientLang)='Georgian'">
                <xsl:text>ka</xsl:text>
            </xsl:when>
            <xsl:when test="normalize-space($AncientLang)='Soghdian'">
                <xsl:text>sog</xsl:text>
            </xsl:when>
            <xsl:when test="normalize-space($AncientLang)='Slavic'">
                <xsl:text>cu</xsl:text>
            </xsl:when>
            <xsl:when test="normalize-space($AncientLang)='Coptic'">
                <xsl:text>cop</xsl:text>
            </xsl:when>
            <xsl:when test="normalize-space($AncientLang)='Ethiopic'">
                <xsl:text>gez</xsl:text>
            </xsl:when>
            <xsl:when test="normalize-space($AncientLang)='Syro-Palestinian'">
                <xsl:text>syr-pal</xsl:text>
            </xsl:when>
            <xsl:when test="normalize-space($AncientLang)='Karshuni'">
                <xsl:text>ar-syr</xsl:text>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="syriaca:normalizeYear" as="xs:string">
        <!-- The spreadsheet presents years normally, but datable attributes need 4-digit years -->
        <xsl:param name="year" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="starts-with($year,'-')">
                <xsl:value-of select="concat('-',syriaca:normalizeYear(substring($year,2)))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="string-length($year) &gt; 3">
                        <xsl:value-of select="$year"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="syriaca:normalizeYear(concat('0',$year))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="syriaca:custom-dates" as="xs:date">
        <xsl:param name="date" as="xs:string"/>
        <xsl:variable name="trim-date" select="normalize-space($date)"/>
        <xsl:choose>
            <xsl:when test="starts-with($trim-date,'0000') and string-length($trim-date) eq 4">
                <xsl:text>0001-01-01</xsl:text>
            </xsl:when>
            <xsl:when test="string-length($trim-date) eq 4">
                <xsl:value-of select="concat($trim-date,'-01-01')"/>
            </xsl:when>
            <xsl:when test="string-length($trim-date) eq 5">
                <xsl:value-of select="concat($trim-date,'-01-01')"/>
            </xsl:when>
            <xsl:when test="string-length($trim-date) eq 5">
                <xsl:value-of select="concat($trim-date,'-01-01')"/>
            </xsl:when>
            <xsl:when test="string-length($trim-date) eq 7">
                <xsl:value-of select="concat($trim-date,'-01')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$trim-date"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/root">
        <!-- [not(starts-with(SRP_ID,'F'))] -->
        <xsl:for-each select="row">
            <xsl:variable name="record-id" select="position() + 220"/>

            <!-- Creates a variable containing the path of the file that should be created for this record. -->
            <xsl:variable name="filename" select="concat('tei/',$record-id,'.xml')"/>

            <xsl:result-document href="{$filename}" format="xml">
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="http://syriaca.org/documentation/syriaca-tei-main.rnc" type="application/relax-ng-compact-syntax"</xsl:text>
                </xsl:processing-instruction>
                <TEI xml:lang="en" xmlns="http://www.tei-c.org/ns/1.0">
                    <!-- Adds header -->
                    <xsl:call-template name="header">
                        <xsl:with-param name="record-id" select="$record-id"/>
                    </xsl:call-template>
                    <text>
                        <body>
                            <bibl>
                                <xsl:attribute name="xml:id" select="concat('work-', $record-id)"/>
                                <xsl:attribute name="ana" select="'#syriaca-saint'"/>
                                <xsl:for-each
                                    select="Saint_English | Syriac_Name | Saint_French | Transcr.">
                                    <xsl:if test="normalize-space(.) !=''">
                                        <title xml:id="{concat('name', $record-id, '-',position())}"
                                            xml:lang="{
                                                if(self::Saint_English) then 'en' 
                                                else if(self::Syriac_Name) then 'syr'
                                                else if(self::Transcr.) then 'fr-x-bhsyre'
                                                else if(self::Saint_French) then 'fr'
                                                else ()}"
                                            source="#bib{$record-id}-1">
                                            <xsl:choose>
                                                <xsl:when
                                                  test="self::Saint_English or self::Syriac_Name">
                                                  <xsl:attribute name="syriaca-tags" namespace=""
                                                  >#syriaca-headword</xsl:attribute>
                                                </xsl:when>
                                            </xsl:choose>
                                            <xsl:if test="self::Saint_French">De </xsl:if>
                                            <xsl:if test="self::Saint_English">On </xsl:if>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </title>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="Auct_FR | A_ET_">
                                    <xsl:if test="normalize-space(.) !=''">
                                        <author
                                            xml:lang="{
                                            if(self::A_ET_) then 'en' 
                                            else if(self::Auct_FR) then 'fr'
                                            else ()}"
                                            source="#bib{$record-id}-1">
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </author>
                                    </xsl:if>
                                </xsl:for-each>
                                <!-- Adds Incipit etc. -->
                                <xsl:for-each
                                    select="Prol._inc. | Prol._FT_ | Prol._ET | Text_inc. | Text_inc._FT | Text_inc._ET | Text._des. | Text._Des._FT | Text._Des._ET">
                                    <xsl:if test="normalize-space(.) !=''">
                                        <note
                                            xml:lang="{
                                            if(self::Prol._inc. or self::Text_inc. or self::Text._des.) then 'syr'
                                            else if(self::Prol._FT_ or self::Text_inc._FT or self::Text._Des._FT) then 'fr'
                                            else if(self::Prol._ET or self::Text_inc._ET or self::Text._Des._ET) then 'en'
                                            else ()}"
                                            type="{
                                            if(self::Prol._inc. or self::Prol._FT_ or self::Prol._ET) then 'prologue'
                                            else if(self::Text_inc. or self::Text_inc._FT or self::Text_inc._ET) then 'incipit'
                                            else if(self::Text._Des._FT or self::Text._des. or self::Text._Des._ET) then 'explicit'
                                            else ()}"
                                            source="#bib{$record-id}-1">
                                            <quote>
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </quote>
                                        </note>
                                    </xsl:if>
                                </xsl:for-each>
                                <!-- Adds Edition Information -->
                                <xsl:if test="normalize-space(EdAuthor1) !=''">
                                    <note type="editions">
                                        <bibl source="#bib{$record-id}-1">
                                            <author>
                                                <xsl:value-of select="normalize-space(EdAuthor1)"/>
                                            </author>
                                            <title>
                                                <xsl:value-of select="normalize-space(EdTitle1)"/>
                                            </title>
                                            <citedRange><xsl:value-of
                                                  select="normalize-space(EdRef1)"/></citedRange>
                                        </bibl>
                                    </note>
                                </xsl:if>
                                <xsl:if test="normalize-space(EdAuthor2) !=''">
                                    <note type="editions">
                                        <bibl source="#bib{$record-id}-1">
                                            <author>
                                                <xsl:value-of select="normalize-space(EdAuthor2)"/>
                                            </author>
                                            <title>
                                                <xsl:value-of select="normalize-space(EdTitle2)"/>
                                            </title>
                                            <citedRange>
                                                <xsl:value-of select="normalize-space(EdRef2)"/>
                                            </citedRange>
                                        </bibl>
                                    </note>
                                </xsl:if>
                                <xsl:if test="normalize-space(EdAuthor3) !=''">
                                    <note type="editions">
                                        <bibl source="#bib{$record-id}-1">
                                            <author>
                                                <xsl:value-of select="normalize-space(EdAuthor3)"/>
                                            </author>
                                            <title>
                                                <xsl:value-of select="normalize-space(EdTitle3)"/>
                                            </title>
                                            <citedRange>
                                                <xsl:value-of select="normalize-space(EdRef3)"/>
                                            </citedRange>
                                        </bibl>
                                    </note>
                                </xsl:if>
                                <xsl:if test="normalize-space(EdAuthor4) !=''">
                                    <note type="editions">
                                        <bibl source="#bib{$record-id}-1">
                                            <author>
                                                <xsl:value-of select="normalize-space(EdAuthor4)"/>
                                            </author>
                                            <title>
                                                <xsl:value-of select="normalize-space(EdTitle4)"/>
                                            </title>
                                            <citedRange>
                                                <xsl:value-of select="normalize-space(EdRef4)"/>
                                            </citedRange>
                                        </bibl>
                                    </note>
                                </xsl:if>
                                <xsl:if test="normalize-space(EdAuthor5) !=''">
                                    <note type="editions">
                                        <bibl source="#bib{$record-id}-1">
                                            <author>
                                                <xsl:value-of select="normalize-space(EdAuthor5)"/>
                                            </author>
                                            <title>
                                                <xsl:value-of select="normalize-space(EdTitle5)"/>
                                            </title>
                                            <citedRange>
                                                <xsl:value-of select="normalize-space(EdRef5)"/>
                                            </citedRange>
                                        </bibl>
                                    </note>
                                </xsl:if>
                                <xsl:if test="normalize-space(EdAuthor6) !=''">
                                    <note type="editions">
                                        <bibl source="#bib{$record-id}-1">
                                            <author>
                                                <xsl:value-of select="normalize-space(EdAuthor6)"/>
                                            </author>
                                            <title>
                                                <xsl:value-of select="normalize-space(EdTitle6)"/>
                                            </title>
                                            <citedRange>
                                                <xsl:value-of select="normalize-space(EdRef6)"/>
                                            </citedRange>
                                        </bibl>
                                    </note>
                                </xsl:if>
                                <xsl:if test="normalize-space(EdAuthor7) !=''">
                                    <note type="editions">
                                        <bibl source="#bib{$record-id}-1">
                                            <author>
                                                <xsl:value-of select="normalize-space(EdAuthor7)"/>
                                            </author>
                                            <title>
                                                <xsl:value-of select="normalize-space(EdTitle7)"/>
                                            </title>
                                            <citedRange>
                                                <xsl:value-of select="normalize-space(EdRef7)"/>
                                            </citedRange>
                                        </bibl>
                                    </note>
                                </xsl:if>
                                <xsl:if test="normalize-space(EdAuthor8) !=''">
                                    <note type="editions">
                                        <bibl source="#bib{$record-id}-1">
                                            <author>
                                                <xsl:value-of select="normalize-space(EdAuthor8)"/>
                                            </author>
                                            <title>
                                                <xsl:value-of select="normalize-space(EdTitle8)"/>
                                            </title>
                                            <citedRange>
                                                <xsl:value-of select="normalize-space(EdRef8)"/>
                                            </citedRange>
                                        </bibl>
                                    </note>
                                </xsl:if>
                                <xsl:if test="normalize-space(EdAuthor9) !=''">
                                    <note type="editions">
                                        <bibl source="#bib{$record-id}-1">
                                            <author>
                                                <xsl:value-of select="normalize-space(EdAuthor9)"/>
                                            </author>
                                            <title>
                                                <xsl:value-of select="normalize-space(EdTitle9)"/>
                                            </title>
                                            <citedRange>
                                                <xsl:value-of select="normalize-space(EdRef9)"/>
                                            </citedRange>
                                        </bibl>
                                    </note>
                                </xsl:if>
                                <!-- Adds MSS information -->
                                <xsl:for-each
                                    select="MSS">
                                    <xsl:if test="normalize-space(.) !=''">
                                        <note
                                            xml:lang="en"
                                            type="MSS"
                                            source="#bib{$record-id}-1">
                                            <bibl>
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </bibl>
                                        </note>
                                    </xsl:if>
                                </xsl:for-each>
                                <!-- Add Ancient Versions -->
                                <xsl:for-each select="Lang[. != '']">
                                    <xsl:for-each-group select="following-sibling::Ref." group-adjacent="boolean(self::Ref.)">
                                        <xsl:if test=". != ''">
                                            <xsl:choose>
                                                <xsl:when test="contains(.,'; ')">
                                                    <xsl:variable name="Lang" select="preceding-sibling::Lang[1]"/>
                                                    <xsl:for-each select="tokenize(.,'; ')">
                                                        <note xml:lang="{syriaca:ancientlangs($Lang)}" type="ancientVersion" source="#bib221-1">
                                                            <bibl><xsl:value-of select="normalize-space(.)"/></bibl>
                                                        </note>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <note xml:lang="{syriaca:ancientlangs(preceding-sibling::Lang[1])}" type="ancientVersion" source="#bib221-1">
                                                        <bibl><xsl:value-of select="normalize-space(.)"/></bibl>
                                                    </note>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:if>
                                    </xsl:for-each-group>
                                </xsl:for-each>
                                <!-- Add Modern Translations -->
                                <xsl:for-each select="Mlang">
                                    <xsl:for-each-group select="following-sibling::Ref." group-adjacent="boolean(self::Ref.)">
                                        <xsl:if test=". != ''">
                                            <xsl:choose>
                                                <xsl:when test="contains(.,'; ')">
                                                    <xsl:variable name="Mlang" select="preceding-sibling::Mlang[1]"/>
                                                    <xsl:for-each select="tokenize(.,'; ')">
                                                        <note xml:lang="{$Mlang}" type="modernTranslation" source="#bib221-1">
                                                            <bibl><xsl:value-of select="normalize-space(.)"/></bibl>
                                                        </note>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <note xml:lang="{preceding-sibling::Mlang[1]}" type="modernTranslation" source="#bib221-1">
                                                        <bibl><xsl:value-of select="normalize-space(.)"/></bibl>
                                                    </note>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:if>
                                    </xsl:for-each-group>
                                </xsl:for-each>
                                <!-- ID numbers -->
                                <!-- Syriaca.org id -->
                                <idno type="URI">http://syriaca.org/work/<xsl:value-of
                                        select="$record-id"/></idno>
                                <!-- Zanetti Fiche Number -->

                                <idno type="BHSYRE">
                                    <xsl:value-of select="normalize-space(File)"/>
                                </idno>
                                <!-- BHO Number -->
                                
                                <xsl:if test="normalize-space(BHO) !=''"><idno type="BHO">
                                    <xsl:value-of select="normalize-space(BHO)"/>
                                </idno></xsl:if>
                                <!-- CPG Number -->
                                
                                <xsl:if test="normalize-space(CPG) !=''"><idno type="CPG">
                                    <xsl:value-of select="normalize-space(CPG)"/>
                                </idno></xsl:if>
                                
                                <!-- ADD BIBLIOGRAPHY -->
                                <bibl>
                                    <xsl:attribute name="xml:id"
                                        select="concat('bibl', $record-id,'-1')"/>
                                    <title level="m" xml:lang="la">Biblioteca Hagiographica Syriaca
                                        electronica</title>
                                    <ptr target="http://syriaca.org/bibl/649"/>
                                    <citedRange unit="entry">
                                        <xsl:value-of select="normalize-space(File)"/>
                                    </citedRange>
                                </bibl>
                                <xsl:for-each select="De_qua">
                                    <xsl:if test="normalize-space(.) !=''">
                                        <bibl>
                                        <xsl:attribute name="xml:id"
                                            select="concat('bibl', $record-id, '-', position() + 1)"/>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </bibl>
                                    </xsl:if>
                                </xsl:for-each>
                            </bibl>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>

        </xsl:for-each>
    </xsl:template>

    <xsl:template name="header" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="record-id"/>
        <xsl:param name="bib-ids"/>

        <xsl:variable name="english-headword">
            <xsl:value-of select="concat('On ',normalize-space(Saint_English))"/>
        </xsl:variable>
        <xsl:variable name="syriac-headword">
            <xsl:choose>
                <xsl:when test="string-length(normalize-space(Syriac_Name)) != 0">
                    <xsl:value-of select="Syriac_Name"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="record-title">
            <xsl:value-of select="$english-headword"/>
            <xsl:if test="string-length($syriac-headword)"> — <foreign xml:lang="syr"><xsl:value-of
                        select="$syriac-headword"/></foreign></xsl:if>
        </xsl:variable>
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title level="a" xml:lang="en">
                        <xsl:copy-of select="$record-title"/>
                    </title>
                    <title level="m">Qadishe: A Guide to the Lives of the Syriac Saints</title>
                    <sponsor>Syriaca.org: The Syriac Reference Portal</sponsor>
                    <funder>The International Balzan Prize Foundation</funder>
                    <funder>The National Endowment for the Humanities</funder>
                    <principal>David A. Michelson</principal>
                    <editor role="general"
                        ref="http://syriaca.org/documentation/editors.xml#jnmsaintlaurent"
                        >Jeanne-Nicole Mellon Saint-Laurent</editor>
                    <editor role="general"
                        ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                        Michelson</editor>
                    <editor role="creator"
                        ref="http://syriaca.org/documentation/editors.xml#jnmsaintlaurent"
                        >Jeanne-Nicole Mellon Saint-Laurent</editor>
                    <editor role="creator"
                        ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                        Michelson</editor>
                    <editor role="creator" ref="http://syriaca.org/editors.xml#uzanetti">Ugo
                        Zanetti</editor>
                    <editor role="creator" ref="http://syriaca.org/editors.xml#cdetienne">Claude
                        Detienne</editor>
                    <respStmt>
                        <resp>Editing, proofreading, data entry and revision by</resp>
                        <name type="person"
                            ref="http://syriaca.org/documentation/editors.xml#jnmsaintlaurent"
                            >Jeanne-Nicole Mellon Saint-Laurent</name>
                    </respStmt>
                    <respStmt>
                        <resp>Data architecture and encoding by</resp>
                        <name type="person"
                            ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                            Michelson</name>
                    </respStmt>
                    <respStmt>
                        <resp>Editing, Syriac data conversion, data entry, and reconciling by</resp>
                        <name ref="http://syriaca.org/editors.xml#akane">Adam P. Kane</name>
                    </respStmt>
                    <respStmt>
                        <resp>Editing and Syriac data proofreading by</resp>
                        <name ref="http://syriaca.org/editors.xml#abarschabo">Aram Bar Schabo</name>
                    </respStmt>
                    <respStmt>
                        <resp>Entries adapted from the work of</resp>
                        <name type="person" ref="http://syriaca.org/editors.xml#uzanetti">Ugo
                            Zanetti</name>
                    </respStmt>
                    <respStmt>
                        <resp>Entries adapted from the work of</resp>
                        <name type="person" ref="http://syriaca.org/editors.xml#cdetienne">Claude
                            Detienne</name>
                    </respStmt>
                </titleStmt>
                <editionStmt>
                    <edition n="1.0"/>
                </editionStmt>
                <publicationStmt>
                    <authority>Syriaca.org: The Syriac Reference Portal</authority>
                    <idno type="URI">http://syriaca.org/work/<xsl:value-of select="$record-id"
                        />/tei</idno>
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
                                <note>used under a Creative Commons Attribution license <ref
                                        target="http://creativecommons.org/licenses/by/3.0/"
                                    /></note>
                            </p>
                        </licence>
                    </availability>
                    <date>
                        <xsl:value-of select="current-date()"/>
                    </date>
                </publicationStmt>
                <sourceDesc>
                    <p>Born digital.</p>
                </sourceDesc>
            </fileDesc>
            <encodingDesc>
                <editorialDecl>
                    <p>This record created following the Syriaca.org guidelines. Documentation
                        available at: <ref target="http://syriaca.org/documentation"
                            >http://syriaca.org/documentation</ref>.</p>
                    <interpretation>
                        <p>Approximate dates described in terms of centuries or partial centuries
                            have been interpreted as documented in <ref
                                target="http://syriaca.org/documentation/dates.html">Syriaca.org
                                Dates</ref>.</p>
                    </interpretation>
                    <!-- Are there other editorial decisions we need to record here? -->
                </editorialDecl>
                <classDecl>
                    <taxonomy>
                        <category xml:id="syriaca-headword">
                            <catDesc>The name used by Syriaca.org for document titles, citation, and
                                disambiguation. These names have been created according to the
                                Syriac.org guidelines for headwords: <ref
                                    target="http://syriaca.org/documentation/headwords.html"
                                    >http://syriaca.org/documentation/headwords.html</ref>.</catDesc>
                        </category>
                        <category xml:id="syriaca-anglicized">
                            <catDesc>An anglicized version of a name, included to facilitate
                                searching.</catDesc>
                        </category>
                    </taxonomy>
                </classDecl>
            </encodingDesc>
            <profileDesc>
                <langUsage>
                    <language ident="syr">Unvocalized Syriac of any variety or period</language>
                    <language ident="syr-Syrj">Vocalized West Syriac</language>
                    <language ident="syr-Syrn">Vocalized East Syriac</language>
                    <language ident="en">English</language>
                    <language ident="en-x-gedsh">Names or terms Romanized into English according to
                        the standards adopted by the Gorgias Encyclopedic Dictionary of the Syriac
                        Heritage</language>
                    <language ident="ar">Arabic</language>
                    <language ident="fr">French</language>
                    <language ident="fr-x-bhsyre">Names or terms Romanized into French according to
                        the standards adopted by the Biblioteca Hagiographica Syriaca
                        electronica</language>
                    <language ident="de">German</language>
                    <language ident="la">Latin</language>
                </langUsage>
            </profileDesc>
            <revisionDesc>
                <change who="http://syriaca.org/documentation/editors.xml#dmichelson" n="1.0">
                    <xsl:attribute name="when" select="current-date()"/>CREATED: work</change>
            </revisionDesc>
        </teiHeader>
    </xsl:template>
</xsl:stylesheet>
