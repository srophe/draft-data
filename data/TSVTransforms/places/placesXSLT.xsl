<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="3.0" xmlns:syriaca="http://syriaca.org">
    <xsl:output method="xml" indent="yes"/>

    
    <!-- NEEDS WORK!
        I can create all of the data needed for a record but I cannot yet link up the correct elements with the correct bibls.
        I will do this manually for now and come back to this when I have more time.
    -->
    
    <!-- syriaca:index-of-starts-with()
        $headings as xs:string+ (sequence of heading values in row 1)
        $substring as xs:string (offsets of headings that start with $substring are returned)
    -->
    <xsl:function name="syriaca:index-of-starts-with" as="xs:integer*">
        <xsl:param name="headings" as="xs:string+"/>
        <xsl:param name="substring" as="xs:string"/>
        <xsl:sequence
            select="
                for $pos in 1 to count($headings)
                return
                    if (starts-with($headings[$pos], $substring)) then
                        $pos
                    else
                        ()"
        />
    </xsl:function>

    <!-- parse tsv into individual lines-->
    <xsl:variable name="tsv" as="xs:string+" select="unparsed-text-lines('PlacesToTransform.tsv')"/>

    <!-- $headings is row 1
        $subheadings, from row 3, is relevant only for idno, to distinguish URIs from non-URIs 
        Column reference variables
                all are of type xs:integer, with varying cardinality
                shape of documentation: $variableName as type ('header text' followed by optional notes)
            $uriNo as xs:integer ('uri')
            $filename as xs:integer ('uri')
            $term as xs:integer* ('term syriaca-headword.xx', where 'xx' specifies a language)
            $gloss as xs:integer* ('gloss.xx', where 'xx' specifies a language)
            $relation as xs:integer* ('relation skos broadMatch')
                'skos' and "broadMatch' are separated in the header by three consecutive hyphens
                we ignore subcategory information in rows 2 and 3
            $idno as xs:integer* ('idno URI', may or may not be real URI, depending on subheading)
            $realURI as xs:integer* (index values of 'idno URI' subheadings, from row 3, that are really URIs)
            $note as xs:integer ('note abstract')
            $category as xs:integer ('Categories')
    -->
    <xsl:variable name="headings" as="xs:string+" select="tokenize($tsv[1], '\t')"/>
    <!-- TODO: the following should be moved to a function that accepts a list of needles -->

    <xsl:variable name="uriNo" as="xs:integer+" select="index-of($headings, 'uri')"/>
    <xsl:variable name="english" as="xs:integer+" select="index-of($headings, 'nameHeadword.en')"/>
    <!-- Just used in the teiHeader -->
    <xsl:variable name="syriac" as="xs:integer*" select="index-of($headings, 'nameHeadword.syr')"/>
    <!-- Just used in the teiHeader -->
    <xsl:variable name="placeType" as="xs:integer+" select="index-of($headings, 'placeType')"/>
    <xsl:variable name="name" as="xs:integer*"
        select="syriaca:index-of-starts-with($headings, 'name')"/>
    <xsl:variable name="headword" as="xs:integer*"
        select="syriaca:index-of-starts-with($headings, 'nameHeadword')"/>
    <xsl:variable name="name1" as="xs:integer*" select="syriaca:index-of-starts-with($headings, 'name1')"/>
    <xsl:variable name="name2" as="xs:integer*" select="syriaca:index-of-starts-with($headings, 'name2')"/>
    <xsl:variable name="name3" as="xs:integer*" select="syriaca:index-of-starts-with($headings, 'name3')"/>
    <xsl:variable name="name4" as="xs:integer*" select="syriaca:index-of-starts-with($headings, 'name4')"/>
    <xsl:variable name="name5" as="xs:integer*" select="syriaca:index-of-starts-with($headings, 'name5')"/>
    <xsl:variable name="name6" as="xs:integer*" select="syriaca:index-of-starts-with($headings, 'name6')"/>
    <xsl:variable name="name7" as="xs:integer*" select="syriaca:index-of-starts-with($headings, 'name7')"/>
    <xsl:variable name="name8" as="xs:integer*" select="syriaca:index-of-starts-with($headings, 'name8')"/>
    <xsl:variable name="source1" as="xs:integer*" select="index-of($headings, 'sourceURI.name1')"/>
    <xsl:variable name="source2" as="xs:integer*" select="index-of($headings, 'sourceURI.name2')"/>
    <xsl:variable name="source3" as="xs:integer*" select="index-of($headings, 'sourceURI.name3')"/>
    <xsl:variable name="source4" as="xs:integer*" select="index-of($headings, 'sourceURI.name4')"/>
    <xsl:variable name="source5" as="xs:integer*" select="index-of($headings, 'sourceURI.name5')"/>
    <xsl:variable name="source6" as="xs:integer*" select="index-of($headings, 'sourceURI.name6')"/>
    <xsl:variable name="source7" as="xs:integer*" select="index-of($headings, 'sourceURI.name7')"/>
    <xsl:variable name="source8" as="xs:integer*" select="index-of($headings, 'sourceURI.name8')"/>
    <xsl:variable name="pages1" as="xs:integer*" select="index-of($headings, 'pages.name1')"/>
    <xsl:variable name="pages2" as="xs:integer*" select="index-of($headings, 'pages.name2')"/>
    <xsl:variable name="pages3" as="xs:integer*" select="index-of($headings, 'pages.name3')"/>
    <xsl:variable name="pages4" as="xs:integer*" select="index-of($headings, 'pages.name4')"/>
    <xsl:variable name="pages5" as="xs:integer*" select="index-of($headings, 'pages.name5')"/>
    <xsl:variable name="pages6" as="xs:integer*" select="index-of($headings, 'pages.name6')"/>
    <xsl:variable name="pages7" as="xs:integer*" select="index-of($headings, 'pages.name7')"/>
    <xsl:variable name="pages8" as="xs:integer*" select="index-of($headings, 'pages.name8')"/>
    <xsl:variable name="abstract" as="xs:integer"
        select="syriaca:index-of-starts-with($headings, 'abstract')"/>
    <xsl:variable name="abstractEn" as="xs:integer" select="index-of($headings, 'abstract.en')"/><!-- Additional variables would be needed if spreadsheet included abstracts in different languages. -->
    <xsl:variable name="sourceAbsEn" as="xs:integer*"
        select="index-of($headings, 'sourceURI.abstract.en')"/>
    <xsl:variable name="PagesAbsEn" as="xs:integer*"
        select="index-of($headings, 'pages.abstract.en')"/>
    <xsl:variable name="contained" as="xs:integer*"
        select="index-of($headings, 'relation.contained')"/>
    <xsl:variable name="idno" as="xs:integer*" select="index-of($headings, 'idno')"/>
    <xsl:variable name="incerta" as="xs:integer*" select="index-of($headings, 'note.incerta')"/>
    <xsl:variable name="incertaSource" as="xs:integer*"
        select="index-of($headings, 'sourceURI.note.incerta')"/>
    <xsl:variable name="incertaPages" as="xs:integer*"
        select="index-of($headings, 'pages.note.incerta')"/>






    <xsl:template match="/" name="xsl:initial-template">
        <!-- There is no '/' because we are not transforming an xml documnet, but oXygen needs this. 
        This is what tells oXygen where to start processing. The @name is added here so that you can process this from the command line. 
        oXygen needs the / to make the xslt fire. The command line needs this name attribute to fire. "Parsing unprocessed text", i.e. non xml.-->

        <!-- data begin at row 2; set upper limit for testing  with something like $tsv[position() ge 2 and position() lt 12]-->
        <xsl:for-each select="$tsv[position() ge 2]">
            <xsl:variable name="values" as="xs:string+" select="tokenize(current(), '\t')"/>
            <xsl:message select="concat('Processing ', $values[$uriNo])"/>
            <xsl:variable name="URI" select="concat('http://syriaca.org/place/', $values[$uriNo])"/>
            <xsl:variable name="xmlID" select="concat('place-', $values[$uriNo])"/>
            <xsl:variable name="biblAbsEn" as="xs:string"
                select="concat(normalize-space($values[$sourceAbsEn]), '$', normalize-space($values[$PagesAbsEn]))"/>
            <xsl:variable name="biblName1" as="xs:string"
                select="concat(normalize-space($values[$source1]), '$', normalize-space($values[$pages1]))"/>
            <xsl:variable name="biblName2" as="xs:string"
                select="concat(normalize-space($values[$source2]), '$', normalize-space($values[$pages2]))"/>
            <xsl:variable name="biblName3" as="xs:string"
                select="concat(normalize-space($values[$source3]), '$', normalize-space($values[$pages3]))"/>
            <xsl:variable name="biblName4" as="xs:string"
                select="concat(normalize-space($values[$source4]), '$', normalize-space($values[$pages4]))"/>
            <xsl:variable name="biblName5" as="xs:string"
                select="concat(normalize-space($values[$source5]), '$', normalize-space($values[$pages5]))"/>
            <xsl:variable name="biblName6" as="xs:string"
                select="concat(normalize-space($values[$source6]), '$', normalize-space($values[$pages6]))"/>
            <xsl:variable name="biblName7" as="xs:string"
                select="concat(normalize-space($values[$source7]), '$', normalize-space($values[$pages7]))"/>
            <xsl:variable name="biblName8" as="xs:string"
                select="concat(normalize-space($values[$source8]), '$', normalize-space($values[$pages8]))"/>
            <xsl:variable name="allBibls" as="xs:string*"
                select="$biblAbsEn, $biblName1, $biblName2, $biblName3, $biblName4, $biblName5, $biblName6, $biblName7, $biblName8"/>
            <xsl:variable name="distinctBibls" as="xs:string*" select="distinct-values($allBibls)"/>
            

            <xsl:result-document method="xml" indent="yes" href="tei/{$values[$uriNo]}.xml">
                <!-- link to the custom Syriaca schema -->
                <xsl:processing-instruction name="xml-model">href="http://syriaca.org/documentation/syriaca-tei-main.rnc" type="application/relax-ng-compact-syntax"</xsl:processing-instruction>

                <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
                    xmlns:svg="http://www.w3.org/2000/svg"
                    xmlns:math="http://www.w3.org/1998/Math/MathML"
                    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:syriaca="http://syriaca.org"
                    xml:lang="en">
                    <!-- header information is all boilerplate except for titleStmt/title -->
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title level="a" xml:lang="en">
                                    <xsl:value-of select="$values[$english]"/> — <foreign
                                        xml:lang="syr"><xsl:value-of select="$values[$syriac]"
                                        /></foreign>
                                </title>
                                <sponsor>Syriaca.org: The Syriac Reference Portal</sponsor>
                                <funder>The National Endowment for the Humanities</funder>
                                <funder>The International Balzan Prize Foundation</funder>
                                <principal>David A. Michelson</principal>
                                <editor role="general"
                                    ref="http://syriaca.org/documentation/editors.xml#tcarlson"
                                    >Thomas A. Carlson</editor>
                                <editor role="general"
                                    ref="http://syriaca.org/documentation/editors.xml#dmichelson"
                                    >David A. Michelson</editor>
                                <editor role="creator"
                                    ref="http://syriaca.org/documentation/editors.xml#dschwartz"
                                    >Daniel L. Schwartz</editor>
                                <respStmt>
                                    <resp>URI minted and initial data collected by</resp>
                                    <name
                                        ref="http://syriaca.org/documentation/editors.xml#dschwartz"
                                        >Daniel L. Schwartz</name>
                                </respStmt>
                            </titleStmt>
                            <editionStmt>
                                <edition n="1.0"/>
                            </editionStmt>
                            <publicationStmt>
                                <authority>Syriaca.org: The Syriac Reference Portal</authority>
                                <idno type="URI"><xsl:value-of select="$URI"/>/tei</idno>
                                <availability>
                                    <licence target="http://creativecommons.org/licenses/by/3.0/">
                                        <p>Distributed under a Creative Commons Attribution 3.0
                                            Unported License.</p>
                                        <p>This entry incorporates copyrighted material from the
                                            following work(s): <listBibl>
                                                <xsl:for-each select="$distinctBibls">
                                                    <xsl:variable name="id"
                                                        select="concat('#bib', $values[$uriNo], '-')"/>
                                                    <xsl:variable name="target" as="xs:string"
                                                        select="substring-before(., '$')"/>
                                                    <xsl:variable name="range" as="xs:string"
                                                        select="substring-after(., '$')"/>
                                                    <xsl:if test="starts-with(., 'http://syriaca.org/')">
                                                        <bibl>
                                                            <ptr target="{$id}"/>
                                                        </bibl>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </listBibl>
                                            <note>used under a Creative Commons Attribution license
                                                  <ref
                                                  target="http://creativecommons.org/licenses/by/3.0/"
                                                />
                                            </note>
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
                                <p>This record created following the Syriaca.org guidelines.
                                    Documentation available at: <ref
                                        target="http://syriaca.org/documentation"
                                        >http://syriaca.org/documentation</ref>.</p>
                                <interpretation>
                                    <p>Approximate dates described in terms of centuries or partial
                                        centuries have been interpreted as documented in <ref
                                            target="http://syriaca.org/documentation/dates.html"
                                            >Syriaca.org Dates</ref>.</p>
                                </interpretation>
                            </editorialDecl>
                            <classDecl>
                                <taxonomy>
                                    <category xml:id="syriaca-headword">
                                        <catDesc>The name used by Syriaca.org for document titles,
                                            citation, and disambiguation. These names have been
                                            created according to the Syriaca.org guidelines for
                                            headwords: <ref
                                                target="http://syriaca.org/documentation/headwords.html"
                                                >http://syriaca.org/documentation/headwords.html</ref>.</catDesc>
                                    </category>
                                    <category xml:id="syriaca-anglicized">
                                        <catDesc>An anglicized version of a name, included to
                                            facilitate searching.</catDesc>
                                    </category>
                                </taxonomy>
                            </classDecl>
                        </encodingDesc>
                        <profileDesc>
                            <langUsage>
                                <language ident="syr">Unvocalized Syriac of any variety or
                                    period</language>
                                <language ident="syr-Syrj">Vocalized West Syriac</language>
                                <language ident="syr-Syrn">Vocalized East Syriac</language>
                                <language ident="en">English</language>
                                <language ident="en-x-gedsh">Names or terms Romanized into English
                                    according to the standards adopted by the Gorgias Encyclopedic
                                    Dictionary of the Syriac Heritage</language>
                                <language ident="ar">Arabic</language>
                                <language ident="fr">French</language>
                                <language ident="de">German</language>
                                <language ident="gr">Greek</language>
                                <language ident="la">Latin</language>
                                <language ident="ru">Russian</language>
                            </langUsage>
                        </profileDesc>
                        <revisionDesc status="draft">
                            <change who="http://syriaca.org/documentation/editors.xml#dschwartz"
                                n="1.0" when="2018-08">CREATED: place</change>
                        </revisionDesc>
                        <!-- Fix this for future transformations. -->
                    </teiHeader>
                    <text>
                        <body>
                            <listPlace>
                                <place xml:id="{$xmlID}" type="{$values[$placeType]}">
                                    <xsl:for-each select="$name">
                                        <xsl:variable name="lg" as="xs:string"
                                            select="substring-after($headings[current()], '.')"/>
                                        <xsl:variable name="id" as="xs:string"
                                            select="concat('name', $values[$uriNo], '-')"/>
                                        <xsl:if
                                            test="string-length(normalize-space($values[current()])) gt 0">
                                            <placeName xml:id="{$id}" xml:lang="{$lg}">
                                                <xsl:if test="current() = $headword">
                                                  <xsl:attribute name="syriaca-tags"
                                                  select="'#syriaca-headword'"/>
                                                </xsl:if>
                                                <xsl:if test="current() = $name1">
                                                    <xsl:attribute name="source" select="$biblName1"></xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="current() = $name2">
                                                    <xsl:attribute name="source" select="$biblName2"></xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="current() = $name3">
                                                    <xsl:attribute name="source" select="$biblName3"></xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="current() = $name4">
                                                    <xsl:attribute name="source" select="$biblName4"></xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="current() = $name5">
                                                    <xsl:attribute name="source" select="$biblName5"></xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="current() = $name6">
                                                    <xsl:attribute name="source" select="$biblName6"></xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="current() = $name6">
                                                    <xsl:attribute name="source" select="$biblName7"></xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="current() = $name8">
                                                    <xsl:attribute name="source" select="$biblName8"></xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="$values[current()]"/>
                                            </placeName>
                                        </xsl:if>
                                    </xsl:for-each>

                                    <!-- in theory there may be multiple abstracts in different languages-->
                                    <xsl:for-each select="$abstract">
                                        <xsl:variable name="lg" as="xs:string"
                                            select="substring-after($headings[current()], '.')"/>
                                        <xsl:variable name="id" as="xs:string"
                                            select="concat('abstract-', $lg, '-', $values[$uriNo])"/>
                                        <xsl:if
                                            test="string-length(normalize-space($values[current()])) gt 0">
                                            <desc xml:id="{$id}" xml:lang="{$lg}">
                                                <xsl:if test="current() = $abstractEn">
                                                    <xsl:if test="starts-with($biblAbsEn, 'http')">
                                                        <xsl:attribute name="source" select="$biblAbsEn"/>
                                                    </xsl:if>
                                                </xsl:if>
                                                <xsl:value-of select="$values[current()]"/>
                                            </desc>
                                        </xsl:if>
                                        
                                    </xsl:for-each>

                                    <state type="existence"/>

                                    <!-- create <note type="incerta"> only if there is one -->
                                    <xsl:if
                                        test="string-length(normalize-space($values[$incerta])) gt 0">
                                        <note type="incerta">
                                            <xsl:value-of select="$values[$incerta]"/>
                                        </note>
                                    </xsl:if>

                                    <!-- create new URI based on $filename -->
                                    <idno type="URI">
                                        <xsl:value-of select="$URI"/>
                                    </idno>

                                    <!-- create <idno type="URI"> only if there is one -->
                                    <xsl:for-each select="$idno">
                                        <xsl:if
                                            test="string-length(normalize-space($values[current()])) ne 0">
                                            <idno type="URI">
                                                <xsl:value-of select="$values[current()]"/>
                                            </idno>
                                        </xsl:if>
                                    </xsl:for-each>


                                    <!-- This creates a bibl element for each distinct bibl. -->
                                    <xsl:for-each select="$distinctBibls">
                                        <xsl:variable name="id"
                                            select="concat('bib', $values[$uriNo], '-')"/>
                                        <xsl:variable name="target" as="xs:string"
                                            select="substring-before(., '$')"/>
                                        <xsl:variable name="range" as="xs:string"
                                            select="substring-after(., '$')"/>
                                        <xsl:variable name="ana" as="xs:string" select="concat($target, '$', $range)"/>
                                        <xsl:if test="starts-with(., 'http')">
                                            <bibl xml:id="{$id}" ana="{$ana}">
                                                <ptr target="{$target}"/>
                                                <citedRange unit="pp">
                                                  <xsl:value-of select="$range"/>
                                                </citedRange>
                                            </bibl>
                                        </xsl:if>
                                    </xsl:for-each>
                                    
                                </place>
                            </listPlace>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <!--Putting this here and hoping it would work was a longshot. But at least I've got some useable code.
        <xsl:template match="place/placeName">
        <xsl:variable name="position">
            <xsl:number format="1" level="any"/>
        </xsl:variable>
        <xsl:variable name="nameNo" select="concat(@xml:id, $position)"></xsl:variable>
        <placeName>
            <xsl:attribute name="xml:id" select="$nameNo"/>
        </placeName>
    </xsl:template>-->
</xsl:stylesheet>
