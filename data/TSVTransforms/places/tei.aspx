<?xml-model href="http://syriaca.org/documentation/syriaca-tei-main.rnc" type="application/relax-ng-compact-syntax"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:svg="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:syriaca="http://syriaca.org" xml:lang="en">
   <teiHeader>
        <fileDesc>
            <titleStmt>
                <title level="a" xml:lang="en">Balikh
                                        — <foreign xml:lang="syr">ܢܗܪ ܒܐܠܚ</foreign>
                </title>
                <title level="m" xml:lang="en">The Syriac Gazetteer</title>
                <sponsor>Syriaca.org: The Syriac Reference Portal</sponsor>
                <funder>The National Endowment for the Humanities</funder>
                <funder>The International Balzan Prize Foundation</funder>
                <funder>Qatar National Research Foundation</funder>
            <principal>David A. Michelson</principal>
                <editor role="general" ref="http://syriaca.org/documentation/editors.xml#tcarlson">Thomas A. Carlson</editor>
                <editor role="general" ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A. Michelson</editor>
                <editor role="creator" ref="http://syriaca.org/documentation/editors.xml#tcarlson">Thomas A. Carlson</editor>
                <editor role="creator" ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A. Michelson</editor>
                <respStmt>
                    <resp>Initial Barsoum entry creation by</resp>
                    <name ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A. Michelson</name>
                </respStmt>
                <respStmt>
                    <resp>Data merging, Pleiades and Wikipedia linking, and XML by</resp>
                    <name ref="http://syriaca.org/documentation/editors.xml#tcarlson">Thomas A. Carlson</name>
                </respStmt>
            <respStmt>
               <resp>Ibn Rustah data collection by</resp>
               <name ref="http://syriaca.org/editors.xml#achamseddine">Abdul Rahman Chamseddine</name>
            </respStmt>
            <respStmt>
               <resp>Ibn Rustah data correction and integration by</resp>
               <name ref="http://syriaca.org/editors.xml#tcarlson">Thomas A. Carlson</name>
            </respStmt>
         </titleStmt>
            <editionStmt>
                <edition n="1.0"/>
            </editionStmt>
            <publicationStmt>
                <authority>Syriaca.org: The Syriac Reference Portal</authority>
                <idno type="URI">http://syriaca.org/place/43/tei</idno>
                <availability>
                    <licence target="http://creativecommons.org/licenses/by/3.0/">
                        <p>Distributed under a Creative Commons Attribution 3.0 Unported License.</p>
                        <p>This entry incorporates copyrighted material from the following work(s):
                                                <listBibl>
                                <bibl>
                                    <ptr target="#bib43-2"/>
                                </bibl>
                                <bibl>
                                    <ptr target="#bib43-3"/>
                                </bibl>
                                <bibl>
                                    <ptr target="#bib43-4"/>
                                </bibl>
                            </listBibl>
                            <note>used under a Creative Commons Attribution license <ref target="http://creativecommons.org/licenses/by/3.0/"/>
                            </note>
                        </p>
                    </licence>
                </availability>
                <date>2017-08-09-05:00</date>
            </publicationStmt>
         <seriesStmt>
            <title level="s">Beth Qaṭraye Gazetteer</title>
            <editor role="general" ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A. Michelson</editor>
            <editor role="general" ref="http://syriaca.org/editors.xml#tcarlson">Thomas A. Carlson</editor>
            <editor role="associate" ref="http://syriaca.org/editors.xml#mkozah">Mario Kozah</editor>
            <respStmt>
               <resp>Edited by</resp>
               <name type="person" ref="http://syriaca.org/documentation/editors.xml#dmichelson">David A. Michelson</name>
            </respStmt>
            <respStmt>
               <resp>Edited by</resp>
               <name type="person" ref="http://syriaca.org/documentation/editors.xml#tcarlson">Thomas A. Carlson</name>
            </respStmt>
            <respStmt>
               <resp>Edited by</resp>
               <name type="person" ref="http://syriaca.org/documentation/editors.xml#mkozah">Mario Kozah</name>
            </respStmt>
            <idno type="URI">http://syriaca.org/bethqatraye</idno>
         </seriesStmt>
            <sourceDesc>
                <p>Born digital.</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
            <editorialDecl>
                <p>This record created following the Syriaca.org guidelines. Documentation available at: <ref target="http://syriaca.org/documentation">http://syriaca.org/documentation</ref>.</p>
                <p>The capitalization of names from GEDSH (<idno type="URI">http://syriaca.org/bibl/1</idno>) was normalized (i.e. names in ALL-CAPS were replaced by Proper-noun capitalization).</p>
                <p>The unchanging parts of alternate names from Barsoum (<idno type="URI">http://syriaca.org/bibl/2</idno>, <idno type="URI">http://syriaca.org/bibl/3</idno>, or <idno type="URI">http://syriaca.org/bibl/4</idno>) have been supplied to each alternate.</p>
                <p>Names from the English translation of Barsoum (<idno type="URI">http://syriaca.org/bibl/4</idno>) were put in sentence word order rather than fronting a dictionary headword.  Any commas in the Barsoum name in English were removed.</p>
                <p>The <gi>state</gi> element of @type="existence" indicates the period for which this place was in use as a place of its indicated type (e.g. an inhabited settlement, a functioning monastery or church, an administrative province).  Natural features always in existence have no <gi>state</gi> element of @type="existence".</p>
            </editorialDecl>
            <classDecl>
                <taxonomy>
                    <category xml:id="syriaca-headword">
                        <catDesc>The name used by Syriaca.org for document titles, citation, and disambiguation. These names have been created according to the Syriac.org guidelines for headwords: <ref target="http://syriaca.org/documentation/headwords.html">http://syriaca.org/documentation/headwords.html</ref>.</catDesc>
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
                <language ident="ar">Arabic</language>
            </langUsage>
        </profileDesc>
        <revisionDesc status="draft">
         <change who="http://syriaca.org/editors.xml#tcarlson" when="2017-08-09-05:00">ADDED: Ibn Rustah citation and attestation</change>
         <change who="http://syriaca.org/editors.xml#tcarlson" when="2017-08-09-05:00">ADDED: Arabic headword</change>
            <change who=" http://syriaca.org/documentation/editors.xml#wsalesky" when="2014-06-30-04:00">CHANGED tei:author element to tei:persName under tei:event element.</change>
            <change who=" http://syriaca.org/documentation/editors.xml#tcarlson" when="2014-06-12-05:00">ADDED: Yaqut citation and attestation</change>
            <change who=" http://syriaca.org/documentation/editors.xml#wsalesky" when="2014-01-14">ADDED: syriaca-computed-start and syriaca-computed-end attributes for searching</change>
            <change who=" http://syriaca.org/documentation/editors.xml#tcarlson" when="2013-12-18-05:00">CREATED: place</change>
        </revisionDesc>
    </teiHeader>
   <text>
      <body>
         <listPlace>
            <place xml:id="place-43" type="river">
               <placeName xml:id="name43-1" xml:lang="en" syriaca-tags="#syriaca-headword" source="#bib43-1">Balikh</placeName>
               <placeName xml:id="name43-2" xml:lang="syr" syriaca-tags="#syriaca-headword">ܢܗܪ ܒܐܠܚ</placeName>
               <placeName xml:id="name43-3" xml:lang="syr-Syrj" source="#bib43-2">ܢܗܰܪ ܒܰܐܠܚ</placeName>
               <placeName xml:id="name43-4" xml:lang="ar" source="#bib43-3">نهر البليخ</placeName>
               <placeName xml:id="name43-5" xml:lang="en" source="#bib43-4">Balikh river</placeName>
               <placeName xml:id="name43-6" xml:lang="ar" syriaca-tags="#syriaca-headword" source="#bib43-5 #bib43-6">البليخ</placeName>
               <desc xml:id="abstract-en-43" xml:lang="en">A tributary of the Euphrates that enters it at al-Raqqa.</desc>
               <event type="attestation" xml:id="attestation43-1" notBefore="1224" notAfter="1228" source="#bib43-5" syriaca-computed-start="1224-01-01" syriaca-computed-end="1228-01-01">
                        <p xml:lang="en">Attestation of name <foreign xml:lang="ar">البليخ</foreign> in the <title xml:lang="en" level="m">Muʿjam al-buldān</title> of <persName>Yāqūt al-Ḥamawī</persName>.</p>
                        <link target="#name43-6 #attestation43-1"/>
                    </event>
               <event type="attestation" xml:id="attestation43-2" notBefore="0902" notAfter="0914" source="#bib43-6">
                  <p xml:lang="en">Attestation of name <foreign xml:lang="ar">البليخ</foreign> in the 
                        <title xml:lang="en" level="m">Kitāb al-aʿlāq al-nafīsa</title> of <persName>Aḥmad ibn ʿUmar Ibn Rustah</persName>.</p>
                  <link target="#name43-6 #attestation43-2"/>
               </event>
               <state type="existence"/>
               <note type="incerta">GEDSH article "Edessa" identifies with <placeName ref="http://syriaca.org/place/191">Daysan</placeName>, but the identification is contested.</note>
               <idno type="URI">http://syriaca.org/place/43</idno>
               <idno type="URI">http://en.wikipedia.org/wiki/Balikh_River</idno>
               <idno type="URI">http://dbpedia.org/resource/Balikh_River</idno>
               <bibl xml:id="bib43-1">
                        <title xml:lang="en">The Gorgias Encyclopedic Dictionary of the Syriac Heritage</title>
                        <ptr target="http://syriaca.org/bibl/1"/>
                        <citedRange unit="pp">138</citedRange>
                        <citedRange unit="maps">Map III</citedRange>
                    </bibl>
               <bibl xml:id="bib43-2">
                        <title xml:lang="syr">ܒܪ̈ܘܠܐ ܒܕܝܪ̈ܐ ܕܥܠ ܡܪܕܘܬ ܝܘܠܦܢ̈ܐ ܣܘܪ̈ܝܝܐ ܗܕܝܪ̈ܐ</title>
                        <ptr target="http://syriaca.org/bibl/3"/>
                        <citedRange unit="pp">546</citedRange>
                    </bibl>
               <bibl xml:id="bib43-3">
                        <title xml:lang="ar">كتاب اللؤلؤ المنثور في تاريخ العلوم والأداب السريانية</title>
                        <ptr target="http://syriaca.org/bibl/2"/>
                        <citedRange unit="pp">510</citedRange>
                    </bibl>
               <bibl xml:id="bib43-4">
                        <title xml:lang="en">The Scattered Pearls: A History of Syriac Literature and Sciences</title>
                        <ptr target="http://syriaca.org/bibl/4"/>
                        <citedRange unit="pp">570</citedRange>
                    </bibl>
               <bibl xml:id="bib43-5">
                        <title xml:lang="en" level="m">Muʿjam al-buldān</title>
                        <author>Yāqūt al-Ḥamawī</author>
                        <ptr target="http://syriaca.org/bibl/636"/>
                        <citedRange unit="pp">I:584</citedRange>
                    </bibl>
               <bibl xml:id="bib43-6">
                  <title xml:lang="en" level="m">Kitāb al-aʿlāq al-nafīsa</title>
                  <author>Aḥmad ibn ʿUmar Ibn Rustah</author>
                  <ptr target="http://syriaca.org/bibl/2503"/>
                  <citedRange unit="pp">90</citedRange>
               </bibl>
                <bibl xml:id="bib43-7">
                    <title xml:lang="en" level="m">Kitāb al-aʿlāq al-nafīsa</title>
                    <author>Aḥmad ibn ʿUmar Ibn Rustah</author>
                    <ptr target="http://syriaca.org/bibl/2503"/>
                    <citedRange unit="pp">90</citedRange>
                </bibl>
            </place>
         </listPlace>
      </body>
   </text>
</TEI>