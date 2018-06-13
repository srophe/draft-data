<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- skos:index-of-starts-with()
        $headings as xs:string+ (sequence of heading values in row 1)
        $substring as xs:string (offsets of headings that start with $substring are returned)
    -->
    <xsl:function name="skos:index-of-starts-with" as="xs:integer*">
        <xsl:param name="headings" as="xs:string+"/>
        <xsl:param name="substring" as="xs:string"/>
        <xsl:sequence
            select="
                for $heading in $headings
                return
                    if (starts-with($heading, $substring)) then
                        index-of($headings, $heading)
                    else
                        ()"
        />
    </xsl:function>

    <!-- parse tsv into individual lines-->
    <xsl:variable name="tsv" as="xs:string+" select="unparsed-text-lines('Taxonomy.tsv')"/>

    <!-- $headings is row 1
        $subheadings, from row 3, is relevant only for idno, to distinguish URIs from non-URIs 
        Column reference variables
                all are of type xs:integer, with varying cardinality
                shape of documentation: $variableName as type ('header text' followed by optional notes)
            $title as xs:integer ('term syriaca-headword.en')
            $filename as xs:integer ('New URI')
            $term as xs:integer* ('term syriaca-headword.xx', where 'xx' specifies a language)
            $gloss as xs:integer* ('gloss.xx', where 'xx' specifies a language)
            $relation as xs:integer* ('relation skos broadMatch')
                'skos' and "broadMatch' are separated in the header by three consecutive hyphens
                we ignore subcategory information in rows 2 and 3
            $idno-uri as xs:integer* ('idno URI' and subheading of either 'LOC' or 'DNB')
            $idno-non-uri as xs:integer ('idno URI' and subheading of 'ISO Code')
            $note as xs:integer? ('note abstract')
    -->
    <xsl:variable name="headings" as="xs:string+" select="tokenize($tsv[1], '\t')"/>
    <xsl:variable name="subheadings" as="xs:string+" select="tokenize($tsv[3], '\t')"/>


    <xsl:variable name="title" as="xs:integer"
        select="index-of($headings, 'term syriaca-headword.en')"/>
    <xsl:variable name="filename" as="xs:integer" select="index-of($headings, 'New URI')"/>
    <xsl:variable name="term" as="xs:integer*" select="skos:index-of-starts-with($headings, 'term')"/>
    <xsl:variable name="gloss" as="xs:integer*"
        select="skos:index-of-starts-with($headings, 'gloss')"/>
    <xsl:variable name="relation" as="xs:integer*"
        select="skos:index-of-starts-with($headings, 'relation')"/>
    <xsl:template match="/">
        <!-- data begin at row 4; set upper limit only for testing -->
        <xsl:for-each select="$tsv[position() gt 3 and position() lt 9]">
            <xsl:variable name="values" as="xs:string+" select="tokenize(current(), '\t')"/>
            <!-- $URI is used:
                in the value of the @active attribute in <relation> attributes 
                in the newly constructed <idno type="URI">
            -->
            <xsl:variable name="URI"
                select="concat('http://syriaca.org/keyword/', $values[$filename])"/>

            <xsl:result-document method="xml" indent="yes" href="taxonomy/{$values[$filename]}.xml">
                <!-- link to the custom Syriaca schema -->
                <xsl:processing-instruction name="xml-model">href="http://syriaca.org/documentation/syriaca-tei-main.rnc" type="application/relax-ng-compact-syntax"</xsl:processing-instruction>

                <TEI xmlns="http://www.tei-c.org/ns/1.0"
                    xmlns:skos="http://www.w3.org/2004/02/skos/core#">
                    <!-- header information is all boilerplate except for titleStmt/title -->
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title level="a" xml:lang="en">
                                    <xsl:value-of select="$values[$title]"/>
                                </title>
                                <sponsor>Syriaca.org: The Syriac Reference Portal</sponsor>
                                <funder>The International Balzan Prize Foundation</funder>
                                <funder>The National Endowment for the Humanities</funder>
                                <principal>David A. Michelson</principal>
                                <editor role="general"
                                    ref="http://syriaca.org/documentation/editors.xml#sminov">Sergey
                                    Minov</editor>
                                <editor role="general"
                                    ref="http://syriaca.org/documentation/editors.xml#dschwartz"
                                    >Daniel L. Schwartz</editor>
                                <editor role="creator"
                                    ref="http://syriaca.org/documentation/editors.xml#sminov">Sergey
                                    Minov</editor>
                                <editor role="creator"
                                    ref="http://syriaca.org/documentation/editors.xml#dschwartz"
                                    >Daniel L. Schwartz</editor>
                                <respStmt>
                                    <resp>This keyword list adapts and expands one developed for the
                                        Comprehensive Bibliography of Syriac Christianity by</resp>
                                    <name ref="http://syriaca.org/documentation/editors.xml#sminov"
                                        >Sergey Minov</name>
                                </respStmt>
                                <respStmt>
                                    <resp>Adaptation, expansion, and organization of the
                                        Comprehensive Bibliography of Syriac Christianity keyword
                                        list by</resp>
                                    <name type="person"
                                        ref="http://syriaca.org/documentation/editors.xml#dschwartz"
                                        >Daniel L. Schwartz</name>
                                </respStmt>
                                <respStmt>
                                    <resp>XSLT transform of spreadsheet data into TEI by</resp>
                                    <name type="person"
                                        ref="http://syriaca.org/documentation/editors.xml#ngibson"
                                        >Nathan Gibson</name>
                                </respStmt>
                            </titleStmt>
                            <editionStmt>
                                <edition n="1.0"/>
                            </editionStmt>
                            <publicationStmt>
                                <authority>Syriaca.org: The Syriac Reference Portal</authority>
                                <idno type="URI"
                                    >http://syriaca.org/keyword/ephrem-influence/tei</idno>
                                <availability>
                                    <licence target="http://creativecommons.org/licenses/by/3.0/">
                                        <p>Distributed under a Creative Commons Attribution 3.0
                                            Unported License.</p>
                                    </licence>
                                </availability>
                                <date>
                                    <xsl:value-of select="current-date()"/>
                                </date>
                            </publicationStmt>
                            <seriesStmt>
                                <title level="s">A Taxonomy of Syriac Studies</title>
                                <editor role="general"
                                    ref="http://syriaca.org/documentation/editors.xml#sminov">Sergey
                                    Minov</editor>
                                <editor role="general"
                                    ref="http://syriaca.org/documentation/editors.xml#dschwartz"
                                    >Daniel L. Schwartz</editor>
                                <respStmt>
                                    <resp>Edited by</resp>
                                    <name type="person"
                                        ref="http://syriaca.org/documentation/editors.xml#sminov"
                                        >Sergey Minov</name>
                                </respStmt>
                                <respStmt>
                                    <resp>Edited by</resp>
                                    <name type="person"
                                        ref="http://syriaca.org/documentation/editors.xml#dschwartz"
                                        >Daniel L. Schwartz</name>
                                </respStmt>
                                <idno type="URI">http://syriaca.org/taxonomy</idno>
                            </seriesStmt>
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
                                            created according to the Syriac.org guidelines for
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
                            <change who="http://syriaca.org/documentation/editors.xml#ngibson"
                                n="1.0" when="2017-05-05-05:00">CREATED: keyword</change>
                        </revisionDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <entryFree>
                                <xsl:for-each select="$term">
                                    <xsl:variable name="lg" as="xs:string"
                                        select="substring-after($headings[current()], '.')"/>
                                    <xsl:if
                                        test="string-length(normalize-space($values[current()])) gt 0">
                                        <term xml:lang="{$lg}" syriaca-tags="#syriaca-headword">
                                            <xsl:value-of select="$values[current()]"/>
                                        </term>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="$headings">
                                    <xsl:variable name="pos" as="xs:integer" select="position()"/>
                                    <xsl:if
                                        test="starts-with(current(), 'gloss') and string-length(normalize-space($values[$pos])) ne 0">
                                        <xsl:variable name="lg" as="xs:string"
                                            select="substring-after(current(), '.')"/>
                                        <gloss xml:lang="{$lg}">
                                            <term>
                                                <xsl:value-of select="$values[$pos]"/>
                                            </term>
                                        </gloss>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:variable name="relationColumns"
                                    select="
                                        for $i in 1 to count($headings)
                                        return
                                            if (starts-with($headings[$i], 'relation')) then
                                                $i
                                            else
                                                ()"/>
                                <xsl:if
                                    test="string-length(normalize-space(string-join($values[position() = $relationColumns]))) gt 0">
                                    <listRelation>
                                        <xsl:for-each select="$headings">
                                            <xsl:variable name="pos" as="xs:integer"
                                                select="position()"/>
                                            <xsl:if
                                                test="starts-with(current(), 'relation') and string-length(normalize-space($values[$pos])) ne 0">
                                                <relation ref="skos:broadMatch" active="{$URI}"
                                                  passive="{$values[$pos]}"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </listRelation>
                                </xsl:if>
                                <idno type="URI">
                                    <xsl:value-of select="$URI"/>
                                </idno>
                                <xsl:for-each select="6 to 7">
                                    <xsl:if
                                        test="string-length(normalize-space($values[current()])) ne 0">
                                        <idno type="URI">
                                            <xsl:value-of select="$values[current()]"/>
                                        </idno>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="string-length(normalize-space($values[8])) ne 0">
                                    <idno>
                                        <xsl:value-of select="$values[8]"/>
                                    </idno>
                                </xsl:if>
                            </entryFree>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
