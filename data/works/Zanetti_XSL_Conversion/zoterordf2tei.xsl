<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:syriaca="http://syriaca.org" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:z="http://www.zotero.org/namespaces/export#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:bib="http://purl.org/net/biblio#"
    xmlns:prism="http://prismstandard.org/namespaces/1.2/basic/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:vcard="http://nwalsh.com/rdf/vCard#"
    xmlns:link="http://purl.org/rss/1.0/modules/link/">

    <!-- FORMAT OF COMMENTS -->
    <!-- ??? Indicates an issue that needs resolving. -->
    <!-- ALL CAPS is a section header. -->
    <!-- !!! Shows items that may need to be changed/customized when running this template on a new spreadsheet. -->
    <!-- lower case comments explain the code -->

    <!-- FILE OUTPUT PROCESSING -->
    <!-- specifies how the output file will look -->
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>

    <!-- ??? Not sure what these variables do. They're from Winona's saints XSL. -->
    <xsl:variable name="n">
        <xsl:text/>
    </xsl:variable>
    <xsl:variable name="s">
        <xsl:text> </xsl:text>
    </xsl:variable>

    <!-- DIRECTORY -->
    <!-- specifies where the output TEI files should go -->
    <!-- !!! Change this to where you want the output files to be placed relative to this stylesheet. 
        This should end with a trailing slash (/).-->
    <xsl:variable name="directory">bibls-from-zotero/</xsl:variable>

    <!-- date processing by Winona Salesky -->
    <!-- creates the dates to be used for @syriaca-computed-start and @syriaca-computed-end. 
        Called by the column-mapping template -->
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
            <xsl:when test="string-length($trim-date) eq 3">
                <xsl:value-of select="concat('0',$trim-date,'-01-01')"/>
            </xsl:when>
            <xsl:when test="string-length($trim-date) eq 2">
                <xsl:value-of select="concat('00',$trim-date,'-01-01')"/>
            </xsl:when>
            <xsl:when test="string-length($trim-date) eq 1">
                <xsl:value-of select="concat('000',$trim-date,'-01-01')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$trim-date"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- MAIN TEMPLATE -->
    <!-- processes each row of the spreadsheet -->
    <xsl:template match="/rdf:RDF">
        <!-- creates ids for new bibls. -->
        <xsl:for-each select="*">
            <xsl:variable name="record-id">
                <!-- gets a record ID from the New_URI column, or generates one if that column is blank -->
                <xsl:value-of select="position()+1300"/>
            </xsl:variable>

            <!-- creates the URI from the record ID -->
            <xsl:variable name="record-uri" select="concat('http://syriaca.org/bibl/',$record-id)"/>

            <!-- creates a variable containing the path of the file to be created for this record, in the location defined by $directory -->
            <xsl:variable name="filename">
                <xsl:choose>
                    <!-- tests whether there is sufficient data to create a complete record. If not, puts it in an 'incomplete' folder inside the $directory -->
                    <xsl:when test="not(//dc:title)">
                        <xsl:value-of select="concat($directory,'/incomplete/',$record-id,'.xml')"/>
                    </xsl:when>
                    <!-- if record is complete and has a URI, puts it in the $directory folder -->
                    <xsl:otherwise>
                        <xsl:value-of select="concat($directory,$record-id,'.xml')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <!-- creates the XML file, if the filename has been sucessfully created. -->
            <xsl:if test="$filename != ''">
                <xsl:result-document href="{$filename}" format="xml">
                    <!-- adds the xml-model instruction with the link to the Syriaca.org validator -->
                    <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="http://syriaca.org/documentation/syriaca-tei-main.rnc" type="application/relax-ng-compact-syntax"</xsl:text>
                </xsl:processing-instruction>
                    <xsl:value-of select="$n"/>

                    <!-- RECORD CONTENT BEGINS -->
                    <TEI xml:lang="en" xmlns="http://www.tei-c.org/ns/1.0">
                        <!-- Adds header from the header template -->
                        <xsl:call-template name="header">
                            <xsl:with-param name="record-id" select="$record-id"/>
                        </xsl:call-template>
                        <text>
                            <body>
                                <biblStruct>
                                    <xsl:if test="z:itemType='journalArticle'">
                                        <analytic>
                                            <xsl:for-each select="bib:authors/rdf:Seq">
                                                <author>
                                                    <persName>
                                                        <xsl:choose>
                                                            <xsl:when test="rdf:li/foaf:Person/foaf:givenname and rdf:li/foaf:Person/foaf:surname">
                                                                <forename><xsl:value-of select="rdf:li/foaf:Person/foaf:givenname"/></forename>
                                                                <surname><xsl:value-of select="rdf:li/foaf:Person/foaf:surname"/></surname>
                                                            </xsl:when>
                                                            <xsl:otherwise><xsl:value-of select="rdf:li/foaf:Person/foaf:givenname|rdf:li/foaf:Person/foaf:surname"/></xsl:otherwise>
                                                        </xsl:choose>
                                                    </persName>
                                                </author>
                                            </xsl:for-each>
                                            <xsl:if test="dc:title">
                                                <title level="a"><xsl:value-of select="dc:title"/></title>
                                            </xsl:if>
                                            <xsl:if test="dc:subject[not(dcterms:LCC)]">
                                                <idno type="zotero"><xsl:value-of select="dc:subject[not(dcterms:LCC)]"/></idno>
                                            </xsl:if>
                                            <xsl:if test="z:libraryCatalog='Open WorldCat' and dc:subject/dcterms:LCC">
                                                <xsl:variable name="oclc-id" select="dc:subject/dcterms:LCC/rdf:value"/>
                                                <xsl:variable name="oclc-uri" select="concat('http://www.worldcat.org/oclc/',$oclc-id)"/>
                                                <idno type="OCLC"><xsl:value-of select="$oclc-id"/></idno>
                                                <idno type="URI"><xsl:value-of select="$oclc-uri"/></idno>
                                                <ptr target="{$oclc-uri}"/>
                                            </xsl:if>
                                            <xsl:if test="dc:identifier and starts-with(dc:identifier,'ISBN')">
                                                <xsl:variable name="isbns"><xsl:value-of select="tokenize(replace(dc:identifier,'ISBN\s*',''),'\s+')"/></xsl:variable>
                                                <xsl:for-each select="$isbns">
                                                    <idno type="ISBN"><xsl:value-of select="."/></idno>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="z:language">
                                                <textLang><xsl:value-of select="z:language"/></textLang>
                                            </xsl:if>
                                        </analytic>
                                        <xsl:variable name="rdf-resource" select="dcterms:isPartOf/@rdf:resource"/>
                                        <xsl:if test="dcterms:isPartOf/bib:Journal or //bib:Journal[@rdf:about=$rdf-resource]">
                                            <xsl:variable name="journal"><xsl:value-of select="dcterms:isPartOf/bib:Journal|//bib:Journal[@rdf:about=$rdf-resource]"/></xsl:variable>
                                            <monogr>
                                                <title level="j"><xsl:value-of select="$journal/dc:title"/></title>
                                                <xsl:if test="$journal/dc:identifier and starts-with($journal/dc:identifier,'ISSN')">
                                                    <xsl:variable name="issns"><xsl:value-of select="tokenize(replace($journal/dc:identifier,'ISSN\s*',''),'\s+')"/></xsl:variable>
                                                    <xsl:for-each select="issns">
                                                        <idno type="ISSN"><xsl:value-of select="."/></idno>
                                                    </xsl:for-each>
                                                </xsl:if>
                                                <imprint>
                                                    <date><xsl:value-of select="dc:date"/></date>
                                                </imprint>
                                                <biblScope unit="vol"><xsl:value-of select="$journal/prism:volume"/></biblScope>
                                                <biblScope unit="pp"><xsl:value-of select="bib:pages"/></biblScope>
                                            </monogr>
                                        </xsl:if>
                                        <!--<dcterms:isPartOf>
                                            <bib:Journal>
                                                <prism:volume>28</prism:volume>
                                                <dc:title>Analecta Bollandiana</dc:title>
                                            </bib:Journal>
                                        </dcterms:isPartOf>-->
                                    </xsl:if>
                                </biblStruct>
                            </body>
                        </text>
                    </TEI>
                </xsl:result-document>

            </xsl:if>

        </xsl:for-each>

    </xsl:template>

    <!-- TEI HEADER TEMPLATE -->
    <!-- ??? Update the following! -->
    <!-- !!! This will need to be updated for each new spreadsheet that has different contributors -->
    <xsl:template name="header" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="record-id"/>
        <!--<xsl:variable name="english-headword">
            <!-\- checks whether there is an English Syriaca headword. If not, just uses the record-id as the page title. -\->
            <xsl:choose>
                <xsl:when
                    test="$converted-columns/*[@syriaca-tags='#syriaca-headword' and starts-with(@xml:lang, 'en')]">
                    <xsl:value-of
                        select="$converted-columns/*[@syriaca-tags='#syriaca-headword' and starts-with(@xml:lang, 'en')]"
                    />
                </xsl:when>
                <xsl:otherwise>Person <xsl:value-of select="$record-id"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>-->
        <!--<xsl:variable name="syriac-headword">
            <!-\- grabs the Syriac headword, if there is one. -\->
            <xsl:choose>
                <xsl:when
                    test="$converted-columns/*[@syriaca-tags='#syriaca-headword' and starts-with(@xml:lang,'syr')]">
                    <xsl:value-of
                        select="$converted-columns/*[@syriaca-tags='#syriaca-headword' and starts-with(@xml:lang,'syr')]"
                    />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>-->
        <!-- combines the English and Syriac headwords to make the record title -->
        <!--<xsl:variable name="record-title">
            <xsl:value-of select="$english-headword"/>
            <xsl:if test="string-length($syriac-headword)"> — <foreign xml:lang="syr"><xsl:value-of
                        select="$syriac-headword"/></foreign></xsl:if>
        </xsl:variable>-->
        <!-- checks whether the person has been categorized as a saint or author (neither is required) -->
        <xsl:variable name="is-saint" select="contains(person_ana,'#syriaca-saint')"/>
        <xsl:variable name="is-author" select="contains(person_ana,'#syriaca-author')"/>
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title level="a" xml:lang="en">
                        <!--<xsl:copy-of select="$record-title"/>-->
                    </title>
                    <!-- adds the saints series title if the person is a saint -->
                    <xsl:if test="$is-saint">
                        <title level="m">Qadishe: A Guide to the Syriac Saints</title>
                        <title level="s">Gateway to the Syriac Saints</title>
                    </xsl:if>
                    <!-- adds the authors series title if the person is an author -->
                    <xsl:if test="$is-author">
                        <title level="m">A Guide to Syriac Authors</title>
                    </xsl:if>
                    <title level="s">The Syriac Biographical Dictionary</title>
                    <sponsor>Syriaca.org: The Syriac Reference Portal</sponsor>
                    <funder>The National Endowment for the Humanities</funder>
                    <principal>David A. Michelson</principal>

                    <!-- EDITORS -->
                    <editor role="general"
                        ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                        Michelson</editor>
                    <editor role="associate"
                        ref="http://syriaca.org/documentation/editors.xml#tcarlson">Thomas A.
                        Carlson</editor>
                    <editor role="associate"
                        ref="http://syriaca.org/documentation/editors.xml#ngibson">Nathan P.
                        Gibson</editor>
                    <editor role="associate"
                        ref="http://syriaca.org/documentation/editors.xml#jnmsaintlaurent"
                        >Jeanne-Nicole Mellon Saint-Laurent</editor>

                    <!-- CREATOR -->
                    <!-- designates the editor responsible for creating this person record (may be different from the file creator) -->
                    <editor role="creator"
                        ref="http://syriaca.org/documentation/editors.xml#dschwartz">Daniel L.
                        Schwartz</editor>

                    <!-- CONTRIBUTORS -->
                    <respStmt>
                        <resp>Editing, proofreading, data entry and revision by</resp>
                        <name type="person"
                            ref="http://syriaca.org/documentation/editors.xml#dschwartz">Daniel L.
                            Schwartz</name>
                    </respStmt>
                    <respStmt>
                        <resp>Data architecture and encoding by</resp>
                        <name type="person"
                            ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                            Michelson</name>
                    </respStmt>
                    <respStmt>
                        <resp>Syriac data conversion and reconciling by</resp>
                        <name ref="http://syriaca.org/documentation/editors.xml#ngibson">Nathan P. Gibson</name>
                    </respStmt>
                </titleStmt>
                <editionStmt>
                    <edition n="1.0"/>
                </editionStmt>
                <publicationStmt>
                    <authority>Syriaca.org: The Syriac Reference Portal</authority>
                    <idno type="URI">http://syriaca.org/person/<xsl:value-of select="$record-id"
                        />/tei</idno>
                    <availability>
                        <licence target="http://creativecommons.org/licenses/by/3.0/">
                            <p>Distributed under a Creative Commons Attribution 3.0 Unported
                                License.</p>
                            <!-- !!! If copyright material is included, the following should be adapted and used. -->
                            <!--<p>This entry incorporates copyrighted material from the following work(s):
                                    <listBibl>
                                            <bibl>
                                                <ptr>
                                                    <xsl:attribute name="target" select="'foo1'"/>
                                                </ptr>
                                            </bibl>
                                            <bibl>
                                                <ptr>
                                                    <xsl:attribute name="target" select="'foo2'"/>
                                                </ptr>
                                            </bibl>
                                    </listBibl>
                                    <note>used under a Creative Commons Attribution license <ref target="http://creativecommons.org/licenses/by/3.0/"/></note>
                                </p>-->
                        </licence>
                    </availability>
                    <date>
                        <xsl:value-of select="current-date()"/>
                    </date>
                </publicationStmt>

                <!-- SERIES STATEMENTS -->
                <!-- adds a series statement for saints dataset if the person is a saint -->
                <xsl:if test="$is-saint">
                    <seriesStmt>
                        <title level="s">Gateway to the Syriac Saints</title>
                        <editor role="general"
                            ref="http://syriaca.org/documentation/editors.xml#jnmsaintlaurent"
                            >Jeanne-Nicole Mellon Saint-Laurent</editor>
                        <editor role="general"
                            ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                            Michelson</editor>
                        <respStmt>
                            <resp>Edited by</resp>
                            <name type="person"
                                ref="http://syriaca.org/documentation/editors.xml#jnmsaintlaurent"
                                >Jeanne-Nicole Mellon Saint-Laurent</name>
                        </respStmt>
                        <respStmt>
                            <resp>Edited by</resp>
                            <name type="person"
                                ref="http://syriaca.org/documentation/editors.xml#dmichelson">David
                                A. Michelson</name>
                        </respStmt>
                        <biblScope unit="vol">1</biblScope>
                        <idno type="URI">http://syriaca.org/q</idno>
                    </seriesStmt>
                </xsl:if>
                <seriesStmt>
                    <title level="s">The Syriac Biographical Dictionary</title>
                    <editor role="general"
                        ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                        Michelson</editor>
                    <editor role="associate"
                        ref="http://syriaca.org/documentation/editors.xml#tcarlson">Thomas A.
                        Carlson</editor>
                    <editor role="associate"
                        ref="http://syriaca.org/documentation/editors.xml#ngibson">Nathan P.
                        Gibson</editor>
                    <editor role="associate"
                        ref="http://syriaca.org/documentation/editors.xml#jnmsaintlaurent"
                        >Jeanne-Nicole Mellon Saint-Laurent</editor>
                    <respStmt>
                        <resp>Edited by</resp>
                        <name type="person"
                            ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A.
                            Michelson</name>
                    </respStmt>
                    <respStmt>
                        <resp>Edited by</resp>
                        <name type="person"
                            ref="http://syriaca.org/documentation/editors.xml#tcarlson">Thomas A.
                            Carlson</name>
                    </respStmt>
                    <respStmt>
                        <resp>Edited by</resp>
                        <name type="person"
                            ref="http://syriaca.org/documentation/editors.xml#ngibson">Nathan P.
                            Gibson</name>
                    </respStmt>
                    <respStmt>
                        <resp>Edited by</resp>
                        <name type="person"
                            ref="http://syriaca.org/documentation/editors.xml#jnmsaintlaurent"
                            >Jeanne-Nicole Mellon Saint-Laurent</name>
                    </respStmt>
                    <!-- selects which vol. of SBD this record is contained in, depending on whether the person is a saint and/or author. 
                        Vol. 1 for saints, vol. 2 for authors, vol. 3 for neither. -->
                    <xsl:choose>
                        <xsl:when test="$is-saint and $is-author">
                            <biblScope unit="vol">1, 2</biblScope>
                        </xsl:when>
                        <xsl:when test="$is-saint">
                            <biblScope unit="vol">1</biblScope>
                        </xsl:when>
                        <xsl:when test="$is-author">
                            <biblScope unit="vol">2</biblScope>
                        </xsl:when>
                        <xsl:otherwise>
                            <biblScope unit="vol">3</biblScope>
                        </xsl:otherwise>
                    </xsl:choose>
                    <idno type="URI">http://syriaca.org/persons</idno>
                </seriesStmt>
                <sourceDesc>
                    <p>Born digital.</p>
                </sourceDesc>
            </fileDesc>

            <!-- SYRIACA.ORG TEI DOCUMENTATION -->
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
                    <taxonomy>
                        <category xml:id="syriaca-author">
                            <catDesc>A person who is relevant to the Guide to Syriac
                                Authors</catDesc>
                        </category>
                        <category xml:id="syriaca-saint">
                            <catDesc>A person who is relevant to the Bibliotheca Hagiographica
                                Syriaca.</catDesc>
                        </category>
                    </taxonomy>
                </classDecl>
            </encodingDesc>
            <profileDesc>
                <langUsage>
                    <!-- !!! Additional languages, if used, should be added here. -->
                    <language ident="syr">Unvocalized Syriac of any variety or period</language>
                    <language ident="syr-Syrj">Vocalized West Syriac</language>
                    <language ident="syr-Syrn">Vocalized East Syriac</language>
                    <language ident="en">English</language>
                    <language ident="en-x-gedsh">Names or terms Romanized into English according to
                        the standards adopted by the Gorgias Encyclopedic Dictionary of the Syriac
                        Heritage</language>
                    <language ident="ar">Arabic</language>
                    <language ident="fr">French</language>
                    <language ident="de">German</language>
                    <language ident="la">Latin</language>
                </langUsage>
            </profileDesc>
            <revisionDesc>

                <!-- FILE CREATOR -->
                <change who="http://syriaca.org/documentation/editors.xml#ngibson" n="1.0">
                    <xsl:attribute name="when" select="current-date()"/>CREATED: person</change>

                <!-- PLANNED CHANGES -->
                <!-- ??? Are there any change @type='planned' ? -->
            </revisionDesc>
        </teiHeader>
    </xsl:template>

    
</xsl:stylesheet>
