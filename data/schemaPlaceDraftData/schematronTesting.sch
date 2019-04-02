<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern>
        
        
        
        
        <sch:rule context="//tei:seriesStmt/tei:respStmt">
            <sch:report test="preceding-sibling::tei:title[@level='s']">
                A &lt;respStmt&gt; element may not appear in a &lt;seriesStmt&gt; that also has a &lt;title&gt; of @type="s". 
            </sch:report>
        </sch:rule>
        <sch:rule context="//tei:seriesStmt//tei:title[@level='s']">
            <!-- Add additional values with an "or" operator if there are multiple series levels associated with a document. -->
            <sch:assert test="matches(., 'The Syriac Gazetteer')">
                The text node of this &lt;title&gt; element must be "The Syriac Gazetteer". 
            </sch:assert>
        </sch:rule>
        <sch:rule context="//tei:seriesStmt//tei:title[node() = 'The Syriac Gazetteer']">
            <!-- Add additional rules with appropriate contexts when adding additional monograph values above. -->
            <sch:assert test="./following-sibling::tei:idno/node() = 'http://syriaca.org/geo'">
                A &lt;title&gt; containing "The Syriac Gazetteer" requires a following sibling &lt;idno&gt; element containing "http://syriaca.org/geo'. 
            </sch:assert>
        </sch:rule>
        <sch:rule context="//tei:seriesStmt/tei:title[@level='m']">
            <sch:assert test="matches(., 'Beth Qaṭraye Gazetteer')">
                <!-- Add additional monograph values with an "or" operator as needed. -->
                The text node of this &lt;title&gt; element must be "Beth Qaṭraye Gazetteer". 
            </sch:assert>
            <sch:assert test="./following-sibling::tei:biblScope">
                A &lt;seriesStmt&gt; containing a &lt;title&gt; element @level="m" must have a &lt;biblScope&gt; element.
                This &lt;biblScope&gt; element is used to indicate the series (&lt;title&gt; element @level="s") of which this 
                'monograph' (&lt;title&gt; element @level="m") is a part.
            </sch:assert>
        </sch:rule>
        <sch:rule context="//tei:seriesStmt[tei:title='Beth Qaṭraye Gazetteer']/tei:idno">
            <!-- Add additional rules with appropriate contexts when adding additional monograph values above. -->
            <sch:assert test="matches(., 'http://syriaca.org/bethqatraye')">
                The text node of this &lt;idno&gt; element must be "http://syriaca.org/bethqatraye'. 
            </sch:assert>
        </sch:rule>
        <sch:rule context="//tei:seriesStmt/tei:biblScope">
            <sch:report test="preceding-sibling::tei:title[@level='s']">
                A &lt;biblScope&gt; element may not appear in a &lt;seriesStmt&gt; that also has a &lt;title&gt; of @type="s". 
            </sch:report>
            <sch:assert test="./tei:title/@level='s'">
                This &lt;biblScope&gt; element must contain a &lt;title&gt; element @level="s". It is used 
                to indicate the series (&lt;title&gt; element @level="s") of which the 'monograph' (&lt;title&gt; element @level="m") 
                in this &lt;seriesStmt&gt; is a part. 
            </sch:assert>
        </sch:rule>
        <sch:rule context="//tei:seriesStmt[tei:title='Beth Qaṭraye Gazetteer']/tei:biblScope/@n">
            <!-- Add an additional rule with appropriate context/assert if there are multiple monographs. -->
            <sch:assert test=". = '1'">
                The @n attribute must be "1" since the Beth Qaṭraye Gazetteer is volume 1 of The Syriac Gazetteer.
            </sch:assert>
        </sch:rule>
        
        
        
        
        
        
        <!--<sch:rule context="//tei:seriesStmt[tei:title/@level='m']/tei:biblScope/tei:title/@level">
            <sch:let name="seriesTitles" value="//tei:seriesStmt/tei:title[@type='s']"/>
            <sch:let name="seriesIdnos" value="//tei:seriesStmt[tei:title/@type='s']/tei:idno"/>
            <sch:assert test="matches(., 's')">
                This &lt;biblScope&gt; must
            </sch:assert>
            <sch:assert
                test="
                every $i in ./tei:title
                satisfies $i = $seriesTitles"
                >
                An @source attribute must point to an @xml:id attribute on a &lt;bibl&gt; element. 
                Multiple values are allow and must be separated by a blank space. Acceptable values include: 
                <sch:value-of select="string-join($seriesTitles, ';  ')"/>.
            </sch:assert>
        </sch:rule>-->
        
        
        
        <!--This is incorporated into the ODD.
        
        <sch:rule context="//tei:text//tei:desc[@xml:id]">
            <sch:assert test="./@type='abstract' ">
                An @xml:id attribute is only allowed on a &lt;desc&gt; element @type="abstract".
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:text//tei:desc[@xml:id]">
            <sch:assert test="./@type">
                A &lt;desc&gt; element with an @xml:id attribute must also contain a @type attribute.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:relation[@active]">
            <sch:let name="docURI" value="//tei:publicationStmt/tei:idno/substring-before(., '/tei')"/>
            <sch:assert test="contains(@active, $docURI) or contains(@passive, $docURI)">
                With @active and @passive attributes on a &lt;relation&gt; element, one of them must contain the URI for this document's place: <sch:value-of select="$docURI"/>. 
            </sch:assert>
            <sch:report test="contains(@active, $docURI) and contains(@passive, $docURI)">
                The @active and @passive attributes on a &lt;relation&gt; element may not both contain the URI for this document's place: <sch:value-of select="$docURI"/>. 
            </sch:report>
        </sch:rule>
        
        <sch:rule context="//tei:relation/@mutual">
            <sch:let name="docURI" value="//tei:publicationStmt/tei:idno/substring-before(., '/tei')"/>
            <sch:assert
                test="
                every $i in (tokenize(., ' '))
                satisfies matches($i, concat('http://syriaca.org/place/', '\d+'))"
                >
                The @mutual attribute on a &lt;relation&gt; element should contain two or more properly formatted 
                Syriaca.org place URIs ('http://syriaca.org/place/{\d+}').
            </sch:assert>
            <sch:report
                test="
                every $i in (tokenize(., ' '))
                satisfies matches(substring-after($i, 'http://syriaca.org/place/'), '\D')"
                >
                The @mutual attribute on a &lt;relation&gt; element should contain two or more properly formatted 
                Syriaca.org place URIs ('http://syriaca.org/place/{\d+}').
            </sch:report>
            <sch:assert test="contains(., $docURI)">
                One on the values of the @mutual attribute must be the URI for this document's place: <sch:value-of select="$docURI"/>.
            </sch:assert>
        </sch:rule>
        
                
        <sch:rule context="//tei:body//@source">
            <sch:let name="biblIDs" value="//tei:body//tei:bibl/@xml:id"/>
            <sch:let name="sourceValues" value="for $i in $biblIDs return concat('#', $i)"/>
            <sch:assert
                test="
                every $i in (tokenize(., ' '))
                satisfies $i = $sourceValues"
                >
                A @source attribute must point to an @xml:id attribute on a &lt;bibl&gt; element. 
                Multiple values are allow and must be separated by a blank space. Acceptable values include: 
                <sch:value-of select="string-join($sourceValues, ';  ')"/>.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:link/@target">
            <sch:let name="allIDs" value="//@xml:id"/>
            <sch:let name="targetVals" value="for $i in $allIDs return concat('#', $i)"/>
            <sch:assert
                test="
                every $i in (tokenize(., ' '))
                satisfies $i = $targetVals"
                >A &lt;link&gt; element takes a @target attribute with two or more of the following values: 
                <sch:value-of select="string-join($targetVals, ';  ')"/>.
            </sch:assert>
            <sch:assert test="contains(., ' ')">
                The @target attribute must contain two or more values separated by a space.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:note[@type='deprecation']">
            <sch:assert test="./@xml:id">
                A &lt;note&gt; element of @type="deprecation" must have an @xml:id attribute.
            </sch:assert>
        </sch:rule>
        <sch:rule context="//tei:note[@type='deprecation']/@xml:id">
            <sch:let name="availableIDs" value="//@xml:id[not(note)]"/>
            <sch:let name="IDvalues" value="for $i in $availableIDs return concat($i, '-deprecation')"/>
            <sch:assert test="
                every $i in .
                satisfies $i = $IDvalues">
                Acceptable values for the @xml:id attribute on a &lt;note&gt; element of @type="deprecation" include: 
                <sch:value-of select="$IDvalues"/>.
            </sch:assert>
        </sch:rule>
        
        
        <sch:rule context="//tei:body//@source">
            <sch:let name="biblIDs" value="//tei:body//tei:bibl/@xml:id"/>
            <sch:let name="sourceValues" value="for $i in $biblIDs return concat('#', $i)"/>
            <sch:assert
                test="
                every $i in (tokenize(., ' '))
                satisfies $i = $sourceValues"
                >
                A @source attribute must point to an @xml:id attribute on a &lt;bibl&gt; element. 
                Multiple values are allow and must be separated by a blank space. Acceptable values include: 
                <sch:value-of select="string-join($sourceValues, ';  ')"/>.
            </sch:assert>
        </sch:rule> 
        
        
        <sch:rule context="//tei:text//tei:desc[@type='abstract']">
            <sch:let name="countAbs" value="count(//tei:text//tei:desc[@type='abstract'])"/>
            <sch:let name="countLangs" value="count(distinct-values(//tei:text//tei:desc[@type='abstract']/@xml:lang))"/>
            <sch:assert test="$countAbs = $countLangs">
                There can only be one abstract is a given language. 
                Each abstract (&lt;desc&gt; element of @type="abstract") must have a unique @xml:lang attribute.
            </sch:assert>
        </sch:rule>
        
        
        <sch:rule context="//tei:text//tei:state[@type='confession']">
            <sch:let name="countElement" value="count(//tei:text//tei:state[@type='confession'])"/>
            <sch:let name="countIDs" value="count(distinct-values(//tei:text//tei:state[@type='confession']/@xml:id))"></sch:let>
            <sch:assert test="$countElement = $countIDs">
                Each @xml:id on a &lt;state&gt; element of @type="confession" must have a unique value.
            </sch:assert>
        </sch:rule>
        
        
        <sch:rule context="//tei:teiHeader//tei:editor/@ref">
            <sch:let name="edsDoc"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-eXist-app/master/documentation/editors.xml')"/>
            <sch:let name="eds" value="$edsDoc//tei:text/tei:body/tei:listPerson/tei:person/@xml:id"/>
            <sch:let name="refValues" value="for $i in $eds return concat('http://syriaca.org/documentation/editors.xml#', $i)"/>
            <sch:assert test="
                every $i in .
                satisfies $i = $refValues">
                Acceptable values for the @ref attribute on an &lt;editor&gt; element inside the &lt;teiHeader&gt; include: 
                <sch:value-of select="$refValues"/>.
            </sch:assert>
        </sch:rule>
        
        
        <sch:rule context="//tei:location[@type='gps']">
            <sch:report test="./tei:placeName or ./tei:measure or ./tei:offset or ./tei:district or ./tei:settlement or ./tei:region or ./tei:country">
                A &lt;location&gt; element of @type="gps" may only contain a child &lt;geo&gt; element.
            </sch:report>
            <sch:assert test="./tei:geo">
                A &lt;location&gt; element of @type="gps" must contain a child &lt;geo&gt; element.
            </sch:assert>
        </sch:rule>
        <sch:rule context="//tei:location[@type='nested']">
            <sch:report test="./tei:placeName or ./tei:measure or ./tei:offset or ./tei:geo">
                A &lt;location&gt; element of @type="nested" may only contain a child elements &lt;country&gt;, &lt;district&gt;, &lt;region&gt;, or &lt;settlement&gt;.
            </sch:report>
        </sch:rule>
        <sch:rule context="//tei:location[@type='relative']">
            <sch:report test="./tei:district or ./tei:settlement or ./tei:region or ./tei:country or ./tei:geo">
                A &lt;location&gt; element of @type="relative" may only contain a child elements &lt;placeName&gt;, &lt;measure&gt;, or &lt;offset&gt;.
            </sch:report>
        </sch:rule>
        
        
        <sch:rule context="//tei:text//tei:bibl/tei:title">
            <sch:assert test="./@xml:lang">A &lt;title&gt; element in a &lt;bibl&gt; element within the text body must have an @xml:lang attribute.</sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:text//tei:place/tei:placeName[parent::tei:place]">
            <sch:assert test="./@xml:id">A &lt;placeName&gt; element that is the direct child of the &lt;place&gt; element must have an @xml:id.</sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:body//tei:place">
            <sch:report test="count(//tei:note/@subtype) lt 1">
                Every &lt;place&gt; element must have at least one &lt;note&gt; element with @subtype="abstract".
            </sch:report>
        </sch:rule>
        
        <sch:rule context="//tei:teiHeader//tei:editor">
            <sch:assert test="./@ref">The &lt;editor&gt; element inside the &lt;teiHeader&gt; must have a @ref attribute.</sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:teiHeader//tei:editor">
            <sch:assert test="./@role">The &lt;editor&gt; element inside the &lt;teiHeader&gt; must have a @role attribute.</sch:assert>
        </sch:rule>
        <sch:rule context="//tei:teiHeader//tei:editor/@role">
            <sch:assert test=". = 'associate' or . = 'creator' or . = 'general' or . = 'code-author' or . = 'content-author' or . = 'contributor'">
                The acceptable attribute values for @role on the &lt;editor&gt; element inside the &lt;teiHeader&gt; are: 
                associate, creator, general, code-author, content-author, or contributor.
            </sch:assert>
        </sch:rule>
        <sch:rule context="//tei:body//tei:editor/@role">
            <sch:assert test=". = 'editor' or . = 'general' or . = 'translator'">
                The acceptable attribute values for @role on the &lt;editor&gt; element inside the &lt;body&gt; are: 
                editor, general, or translator.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:place/tei:placeName/@xml:id">
            <sch:let name="docURIno" value="//tei:publicationStmt/tei:idno/substring-before(substring-after(substring-after(., 'http://syriaca.org/'), '/'), '/tei')"/>
            <sch:assert test="matches (., concat('name', $docURIno, '-', '\d+'))">
                The @xml:id must be 'name<sch:value-of select="$docURIno"/>-{/d+}'.
            </sch:assert>
            <sch:report test="matches(substring-after(., '-'), '\D')">
                The @xml:id must end with a number.
            </sch:report>
        </sch:rule>   
        
        <sch:rule context="//tei:note[@subtype='abstract']">
            <sch:assert test="@xml:lang">Notes of @subtype="abstract" must have an @xml:lang attribute.</sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:note[@subtype='abstract']">
            <sch:assert test="./@type='description'">
                An abstract (&lt;note&gt; of @subtype="abstract") can only appear in &lt;note&gt; of @type="description".
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:teiHeader//tei:profileDesc/tei:langUsage/tei:p">
            <sch:assert test="normalize-space(.) eq 'Language codes used in this record follow the Syriaca.org guidelines. Documentation available at: http://syriaca.org/documentation/langusage.xml.'">
                Text node of &lt;p&gt; must be: Language codes used in this record follow the Syriaca.org guidelines. 
                Documentation available at: http://syriaca.org/documentation/langusage.xml.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:body//tei:listPerson/tei:person/tei:note[(1)]">
            <sch:assert test="@type = 'abstract'">The first note must contain the abstract for the person and take a @type="abstract".</sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:publicationStmt/tei:idno[@type='URI']">
            <sch:let name="fileNo" value="substring-before(tokenize(document-uri(/), '/')[last()], '.')"/>
            <sch:let name="docURIno" value="//tei:publicationStmt/tei:idno/substring-before(substring-after(substring-after(., 'http://syriaca.org/'), '/'), '/tei')"></sch:let>
            <sch:assert test="$fileNo eq $docURIno">The number portion of the &lt;idno&gt; element must be the same as the URI number in the file name: <sch:value-of select="$fileNo"/></sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:publicationStmt/tei:authority">
            <sch:assert test="matches(., 'Syriaca.org: The Syriac Reference Portal')">
                The &lt;authority&gt; element should contain the text: "Syriaca.org: The Syriac Reference Portal."
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:titleStmt/tei:title">
            <sch:assert test="matches(@level, 'a') or matches(@level, 'm')">
                Acceptable values for the @level attribute on the &lt;title&gt; element in &lt;titleStmt&gt; are "a" or "m".
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:place/tei:placeName">
            <sch:assert test="attribute::source or attribute::resp">
                The &lt;placeName&gt; element must have either a @source attribute (preferred) or a @resp attribute.
            </sch:assert>
            <sch:report test="attribute::source and attribute::resp">
                The &lt;placeName&gt; element may not have both a @source attribute (the preferred attribute in this instance) and a @resp attribute.
            </sch:report>
        </sch:rule> 
        
        <sch:rule context="//@source">
            <sch:let name="biblURIs" value="//tei:bibl[parent::tei:person or parent::tei:place or parent::tei:bibl]/@xml:id"/>
            <sch:assert test="starts-with(., '#')">The @source attribute value must begin with a '#'.</sch:assert>
            <sch:assert test="every $i in (tokenize(replace(., '#', ''), ' ')) satisfies $i = $biblURIs">
                Every @source attribute value must correspond to an @xml:id attribute value on a &lt;bibl&gt; element.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:text//tei:bibl[parent::tei:person or parent::tei:place or parent::tei:bibl]/@xml:id">
            <sch:let name="URIno" value="//tei:publicationStmt/tei:idno/replace(., '[\D]+', '')"/>
            <sch:assert test="matches(., concat('bib', $URIno, '-', '\d'))">
                The @xml:id must begin with 'bib', followed by the same number as the URI number of the entity, followed by '-': bib<sch:value-of select="$URIno"/>
            </sch:assert>
            <sch:report test="matches(substring-after(., '-'), '\D')">
                The @xml:id must end with a number.
            </sch:report>
        </sch:rule>
        
        <sch:rule context="//tei:text/tei:body/tei:listPlace/tei:place/@xml:id">
            <sch:let name="URIno" value="//tei:publicationStmt/tei:idno/replace(., '[\D]+', '')"/>
            <sch:assert test="starts-with(., concat('place', '-', $URIno))">
                The @xml:id must begin with 'place', followed by '-', followed by the same number as the URI number of the entity: place-<sch:value-of select="$URIno"/>.
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:text//tei:bibl[parent::tei:person or parent::tei:place or parent::tei:bibl]/@xml:id">
            <sch:let name="URIno" value="//tei:publicationStmt/tei:idno/replace(., '[\D]+', '')"/>
            <sch:assert test="starts-with(., concat('bib', $URIno, '-'))">
                The @xml:id must begin with 'bib', followed by the same number as the URI number of the entity, followed by '-': bib<sch:value-of select="$URIno"/>
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:place/tei:bibl/tei:ptr/@target">
            <sch:assert test="matches(., concat('http://syriaca.org/bibl/', '\d+'))">
                The @target attribute on a &lt;ptr&gt; element must be a properly formatted URI, 'http://syriaca.org/bibl/' followed by a number.
            </sch:assert>
            <sch:report test="matches(substring-after(., 'http://syriaca.org/bibl/'), '\D')">The @target attribute on a &lt;ptr&gt; element must end with a number.</sch:report>
        </sch:rule>
        
        <sch:rule context="//tei:place/@xml:id">
            <sch:let name="URIno" value="//tei:publicationStmt/tei:idno[@type='URI']/substring-after(substring-before(., '/tei'), 'place/')"/>
            <sch:assert test="contains (., concat('place-', $URIno))">
                The number portion of the @xml:id on the &lt;place&gt; element must match the number 
                portion of the &lt;idno&gt; in the &lt;publicationStmt&gt;
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:publicationStmt/tei:idno">
            <sch:assert test="matches(., concat('http://syriaca.org/work/', '\d+', '/tei'))">The idno for a work record must
                contain 'http://syriaca.org/work/', followed by the number of the work, followed by '/tei'.</sch:assert>
        </sch:rule>

        <sch:rule context="//tei:body[ancestor::tei:TEI/tei:teiHeader//tei:publicationStmt/tei:idno/contains(., 'syriaca.org/work')]">
            <sch:assert test="tei:bibl">The &lt;body&gt; element of a Syriaca.org work record must contain a &lt;bibl&gt; element.</sch:assert>
        </sch:rule>
    -->
    </sch:pattern>
</sch:schema>
