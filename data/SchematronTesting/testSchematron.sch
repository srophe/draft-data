<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern>






        
        
        <!--In ODD already
            <sch:rule context="//tei:sourceDesc/tei:listBibl">
            <sch:assert test="tei:head">A listBibl element inside sourceDesc must contain a head element.</sch:assert>
        </sch:rule>
        
        <sch:rule context="//tei:sourceDesc//tei:head">
            <sch:assert test="normalize-space(.) = 'Sources for the Data in this Born Digital Prosopography'">
                A head element in the sourceDesc must read: "Sources for the Data in this Born Digital Prosopography".
            </sch:assert>
        </sch:rule>-->
        
        <!--In ODD already
        <sch:rule context="//tei:body/tei:div/tei:bibl[@type = 'urn']/tei:ptr/@target">
            <sch:let name="urnBase"
                value="//tei:sourceDesc//tei:bibl[@type = 'urn']/tei:ptr/@target"/>
            <sch:assert test="starts-with(., concat($urnBase, ':'))">URN in factoid bibl must begin with URN in
                the sourceDesc element of the teiHeader: "<sch:value-of select="$urnBase"/>:".</sch:assert>
        </sch:rule>-->



        <!--In ODD already
        <sch:rule context="//tei:body//tei:bibl[@type = 'primary']/tei:ptr/@target">
            <sch:assert test=". = //tei:sourceDesc//tei:bibl[@type = 'primary']/tei:ptr/@target">
                Ptr @target "<sch:value-of select="."/>" is not among the valid options contained in
                the sourceDesc element of the teiHeader: (<sch:value-of
                    select="string-join(//tei:sourceDesc//tei:bibl[@type = 'primary']/tei:ptr/@target, '; ')"
                />) </sch:assert>
        </sch:rule>-->




        <!--In ODD already
            <sch:rule context="tei:back//tei:bibl">
            <sch:assert test="@xml:id">A bibl element in the back matter must contain an @xml:id
                attribute.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:back//tei:bibl/@xml:id">
            <sch:let name="docURIno"
                value="//tei:publicationStmt/tei:idno[@type]/substring-after(substring-before(., '/tei'), 'spear/')"/>
            <sch:assert test="contains(., concat('bibl', $docURIno, '-'))">The @xml:id on the bibl
                element in the back matter must take the following form: 'bibl' + '<sch:value-of
                    select="$docURIno"/>' + '-' + a unique number.</sch:assert>
            <sch:assert test="count(distinct-values(//tei:back//tei:bibl/@xml:id)) eq count(//tei:back//tei:bibl/@xml:id)">Each
                bibl @xml:id attribute must have a unique value.</sch:assert>
            <sch:report test="matches(substring-after(., '-'), '\D')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:report>
            <sch:assert test="matches(substring-after(., '-'), '\d')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:assert>
        </sch:rule>-->


        <!--<sch:rule context="tei:bibl[@type='primary']/tei:ptr/@target">
            <sch:assert
                test="starts-with(., 'http://syriaca.org/bibl/') or starts-with(., 'http://syriaca.org/work/')"
                >"http://syriaca.org/work/" or "http://syriaca.org/bibl/" in bibl @type 'primary'.</sch:assert>
            <sch:report test="contains(., ' ')">The @target attribute on the ptr element can
                only contain one value.</sch:report>
        </sch:rule>
        <sch:rule context="tei:ptr[parent::tei:bibl]/@target">
            <sch:assert
                test="starts-with(., 'http://syriaca.org/bibl/') or starts-with(., 'http://syriaca.org/work/')"
                >Inside of a bibl element, a ptr @target must contain a properly formatted
                Syriaca.org URI that starts with either "http://syriaca.org/work/" or
                "http://syriaca.org/bibl/".</sch:assert>
            <sch:report test="contains(., ' ')">The @target attribute on the ptr element can only
                contain one value.</sch:report>
        </sch:rule>-->


        <!-- In ODD already
            <sch:rule context="tei:persName/@ref">
            <sch:assert test="starts-with(., 'http://syriaca.org/person/')">@ref attributes on a
                persName element must contain a properly formatted Syriaca.org person URI that
                starts with http://syriaca.org/person/.</sch:assert>
            <sch:report test="matches(substring-after(., 'person/'), '\D')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:report>
            <sch:assert test="matches(substring-after(., 'person/'), '\d')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:placeName/@ref">
            <sch:assert test="starts-with(., 'http://syriaca.org/place/')">@ref attributes on
                placeName elements must contain a properly formatted Syriaca.org place URI that
                starts with http://syriaca.org/place/.</sch:assert>
            <sch:report test="matches(substring-after(., 'place/'), '\D')">A properly formatted
                Syriaca.org place URI ends with a number.</sch:report>
            <sch:assert test="matches(substring-after(., 'place/'), '\d')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:div/tei:note/@type">
            <sch:report test=". = 'desc'">Only notes of @type "incerta", "dubia", or
                "errata" may appear as children of a div element.</sch:report>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:div[ancestor::tei:body]">
            <sch:assert test="@uri">Div elements within the body element require a @uri
                attribute.</sch:assert>
            <sch:assert test="@resp">Div elements within the body element require a @resp
                attribute.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:div[ancestor::tei:body]/@uri">
            <sch:let name="docURIno"
                value="//tei:publicationStmt/tei:idno[@type]/substring-after(substring-before(., '/tei'), 'spear/')"/>
            <sch:let name="divURInos" value="//tei:div/@uri/substring-after(., 'spear/')"/>
            <sch:let name="divURIbaseNos"
                value="//tei:div/@uri/substring-after(substring-before(., '-'), 'spear/')"/>
            <sch:let name="uniquePartDivURIs" value="//tei:div/@uri/substring-after(., '-')"/>

            <sch:assert test="starts-with(., 'http://syriaca.org/spear/')">@uri attributes must
                contain a properly formatted SPEAR factoid div URI that starts with
                'http://syriaca.org/spear/'.</sch:assert>
            <sch:report test="matches(substring-after(., '-'), '\D')">A properly formatted SPEAR
                factoid URI ends with a hyphen followed by a number.</sch:report>
            <sch:assert test="matches(substring-after(., '-'), '\d')">A properly formatted SPEAR
                factoid URI ends with a number.</sch:assert>
            <sch:assert test="contains(., concat('/', $docURIno, '-'))">SPEAR factoid divs contain
                @uri attributes that must contain the number of the TEI document URI, in this
                document: <sch:value-of select="$docURIno"/>.</sch:assert>

            <sch:assert test="count(distinct-values(//tei:div/@uri)) eq count(//tei:div/@uri)">Each
                div @uri attribute must have a unique value.</sch:assert>
            
                I tried all of these but none worked. They validate whether or not the count of uri attribute values is the same or 
                greater than the number of unique uri attribute values. I couldn't figure out how this might be a namespace issue but 
                tried the sch:assert above and it worked. I'm not sure why it worked where the others failed.
                <sch:assert test="count(distinct-values(.)) = count(.)">Each div @uri attribute must have a unique value.</sch:assert>
                <sch:assert test="count(distinct-values(.)) eq count(.)">Each div @uri attribute must have a unique value.</sch:assert>
                <sch:report test="count(.) gt count(distinct-values(.))">Each div @uri attribute must have a unique value.</sch:report>
                <sch:report test="count(distinct-values(.)) lt count(.)">Each div @uri attribute must have a unique value.</sch:report>
            </sch:rule>
        -->



        <!--In ODD already
            <sch:rule context="tei:note[parent::tei:birth and preceding-sibling::tei:placeName]">
            <sch:assert test="tei:persName">The note in a birth place factoid must contain a
                persName element.</sch:assert>
            <sch:assert test="tei:placeName">The note in a birth place factoid must contain a
                placeName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:birth and preceding-sibling::tei:date]">
            <sch:assert test="tei:persName">The note in a birth date factoid must contain a persName
                element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:nationality and preceding-sibling::tei:placeName]">
            <sch:assert test="tei:persName">The note in a citizenship factoid must contain a
                persName element.</sch:assert>
            <sch:assert test="tei:placeName">The note in a citizenship factoid must contain a
                placeName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:death and preceding-sibling::tei:placeName]">
            <sch:assert test="tei:persName">The note in a death place factoid must contain a
                persName element.</sch:assert>
            <sch:assert test="tei:placeName">The note in a birth place factoid must contain a
                placeName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:education]">
            <sch:assert test="tei:persName">The note in an education factoid must contain a persName
                element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:death and preceding-sibling::tei:date]">
            <sch:assert test="tei:persName">The note in a death date factoid must contain a persName
                element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:occupation]">
            <sch:assert test="tei:persName">The note in an occupation factoid must contain a
                persName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:residence and preceding-sibling::tei:placeName]">
            <sch:assert test="tei:persName">The note in a residence factoid must contain a persName
                element.</sch:assert>
            <sch:assert test="tei:placeName">The note in a residence factoid must contain a
                placeName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:sex]">
            <sch:assert test="tei:persName">The note in a biological sex factoid must contain a
                persName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:socecStatus]">
            <sch:assert test="tei:persName">The note in a socioeconomic status factoid must contain
                a persName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:langKnowledge and preceding-sibling::tei:langKnown]">
            <sch:assert test="tei:persName">The note in a language-known factoid must contain a
                persName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:trait]">
            <sch:assert test="tei:persName">The note inside the trait element must contain a
                persName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:state]">
            <sch:assert test="tei:persName">The note inside the state element must contain a
                persName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:reg and preceding-sibling::tei:date]">
            <sch:assert test="@ana">This note requires an @ana attribute.</sch:assert>
        </sch:rule>-->


        <!--In ODD already
            <sch:rule context="tei:note[parent::tei:birth]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the birth element. Other types of notes ("incerta", "dubia", and
                "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:nationality]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the nationality element. Other types of notes ("incerta", "dubia",
                and "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:death]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the death element. Other types of notes ("incerta", "dubia", and
                "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:education]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the education element. Other types of notes ("incerta", "dubia", and
                "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:occupation]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the occupation element. Other types of notes ("incerta", "dubia", and
                "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:residence]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the residence element. Other types of notes ("incerta", "dubia", and
                "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:sex]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the sex element. Other types of notes ("incerta", "dubia", and
                "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:socecStatus]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the socecStatus element. Other types of notes ("incerta", "dubia",
                and "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:langKnowledge]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the langKnowledge element. Other types of notes ("incerta", "dubia",
                and "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:trait]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the trait element. Other types of notes ("incerta", "dubia", and
                "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:state]/@type">
            <sch:assert test="contains(., 'desc')">Note elements of @type "desc" are the only notes
                allowed inside the state element. Other types of notes ("incerta", "dubia", and
                "errata") may appear as children of the div element as needed.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:ptr[parent::tei:event]/@target">
            <sch:let name="targetValues" value="tokenize(., ' ')"/>
            <sch:assert test="starts-with(., 'http://syriaca.org/keyword/')">@target attributes on
                the ptr element in an event factoid must point to a Syriaca.org keyword
                (http://syriaca.org/keyword/___).</sch:assert>
        </sch:rule>
        <sch:rule context="tei:ptr[parent::tei:bibl]/@target">
            <sch:assert
                test="starts-with(., 'http://syriaca.org/bibl/') or starts-with(., 'http://syriaca.org/work/')"
                >Inside of a bibl element, a ptr @target must contain a properly formatted
                Syriaca.org URI that starts with either "http://syriaca.org/work/" or
                "http://syriaca.org/bibl/".</sch:assert>
            <sch:report test="contains(., ' ')">The @target attribute on the ptr element can only
                contain one value.</sch:report>
        </sch:rule>-->


        <!--In ODD already
            <sch:rule context="tei:trait/@ref">
            <sch:assert test="starts-with(., 'http://syriaca.org/keyword/')">@ref attributes on the
                trait element must point to a Syriaca.org keyword
                (http://syriaca.org/keyword/___).</sch:assert>
        </sch:rule>
        <sch:rule context="tei:state/@ref">
            <sch:assert test="starts-with(., 'http://syriaca.org/keyword/')">@ref attributes on the
                state element must point to a Syriaca.org keyword
                (http://syriaca.org/keyword/___).</sch:assert>
        </sch:rule>-->


        <!--In ODD already
            <sch:rule context="tei:date[parent::tei:reg]/@calendar">
            <sch:assert test=". = 'Gregorian'">A date element inside a reg element must
                have a @calendar attribute with a value of "Gregorian".</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:reg and preceding-sibling::tei:date]">
            <sch:assert test="normalize-space(.) = 'This regularized date was calculated by the SPEAR editor from a non-calendrical dating system such as regnal years, etc.'">
                The only note allowed in this context must contain the following text: "This regularized date was calculated by the SPEAR editor from a non-calendrical dating system such as regnal years, etc."
            </sch:assert>
        </sch:rule>-->

        <!--NOT WORKING! NOT SURE WHY!!
            <sch:rule context="tei:bibl/tei:ptr/@target">
            <sch:report test="matches(substring-after(., 'work/'), '/D')">A properly formatted
                Syriaca.org work URI ends with a number.</sch:report>
            <sch:assert test="matches(substring-after(., 'work/'), '/d')">A properly formatted
                Syriaca.org work URI ends with a number.</sch:assert>
        </sch:rule>-->



        <!--
        This isn't a rule I can use right now, but I'm saving this to build on later. I will eventually want to link this up to specific sections of the taxonomy.
        
        <sch:rule context="tei:trait[@type['ethnicLabel']]">
            <sch:let name="ethnicLabelTaxonomy" value="doc('https://raw.github....')"/>
            <sch:assert test="@ref[$ethnicLabelTaxonomy//div[@type[ethnicity]]//idno[@type[URI]]]">
                @ref attributes here must be URIs from the Ethnicity section of Syriaca.org taxonomy: <sch:value-of select="$ethnicLabelTaxonomy"/>.
            </sch:assert>
        </sch:rule>
        
        Once I get a chance to revisit the taxonomy, I need to write an xslt that will produce a document stored on GitHub
        That will allow me to produce a 'sch:let' like the one above. Then I should be able to point to that doc and drill down into it. 
        This should allow me to create a subset of taxonomy URI values allowed in different contexts.
        -->





    </sch:pattern>
</sch:schema>
