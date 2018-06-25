<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern>
        <sch:let name="docURIno"
            value="//tei:publicationStmt/tei:idno[@type]/substring-after(substring-before(., '/tei'), 'spear/')"/>
        <sch:let name="divURInos" value="//tei:div/@uri/substring-after(., 'spear/')"/>
        <sch:let name="divURIbaseNos"
            value="//tei:div/@uri/substring-after(substring-before(., '-'), 'spear/')"/>
        <sch:let name="uniquePartDivURIs" value="//tei:div/@uri/substring-after(., '-')"/>

        <sch:rule context="tei:persName/@ref">
            <sch:assert test="starts-with(., 'http://syriaca.org/person/')">@ref attributes must
                contain a properly formatted Syriaca.org person URI that starts with
                http://syriaca.org/person/.</sch:assert>
            <sch:report test="matches(substring-after(., 'person/'), '\D')">A properly formatted
                person URI ends with a number.</sch:report>
            <sch:assert test="matches(substring-after(., 'person/'), '\d')">A properly formatted
                person URI ends with a number.</sch:assert>
        </sch:rule>

        <sch:rule context="tei:placeName/@ref">
            <sch:assert test="starts-with(., 'http://syriaca.org/place/')">@ref attributes must
                contain a properly formatted Syriaca.org place URI that starts with
                http://syriaca.org/place/.</sch:assert>
            <sch:report test="matches(substring-after(., 'place/'), '\D')">A properly formatted
                place URI ends with a number.</sch:report>
            <sch:assert test="matches(substring-after(., 'place/'), '\d')">A properly formatted
                person URI ends with a number.</sch:assert>
        </sch:rule>

        <sch:rule context="tei:div/@uri">
            <sch:assert test="starts-with(., 'http://syriaca.org/spear/')">@uri attributes must
                contain a properly formatted SPEAR factoid div URI that starts with
                http://syriaca.org/spear/.</sch:assert>
            <sch:report test="matches(substring-after(., '-'), '\D')">A properly formatted SPEAR
                factoid URI ends with a hyphen followed by a number.</sch:report>
            <sch:assert test="matches(substring-after(., '-'), '\d')">A properly formatted SPEAR
                factoid URI ends with a number.</sch:assert>
            <sch:assert test="contains(., $docURIno)">SPEAR factoid divs must employ the same number
                as the TEI document URI.</sch:assert><!-- This doesn't quite work properly. If the encoder applies a uri to the div that contains the 
                TEI document uri but adds to it at the beginning or end, this satisfies the test. I don't want this to be possible.-->
            <!--This works as intended but I've commented it out while I work on the test that ensures the spear factoid div uses the same number as the TEI doc URI.
                <sch:assert test="distinct-values($divURIbaseNos) => count() eq 1">The base of the
                numeric portion of the URI for SPEAR factoid divs (i.e., the number between 'spear/'
                and '-') must be the same throughout the document.</sch:assert>-->
            <!--I cannot for the life of me figure out why this doesn't work. I might need to ask.
                <sch:assert test="count(distinct-values(.)) eq count(//tei:div)">The value of every @uri attribute value must be unique.</sch:assert>-->
            

            
        </sch:rule>

        <!--<sch:rule context="//tei:publicationStmt/tei:idno[@type]">
            <sch:assert test="contains(., substring-before($divURInos, '-'))">TEI document URI must employ the same number as the SPEAR factoid divs.</sch:assert>
        </sch:rule>-->


        <!--I am marking this out because it was a mistake. Despite that, I want to save this bit of code for later use.
        <sch:rule context="tei:div/@uri">
            <sch:let name="target" value="concat('http://syriaca.org/spear/', //tei:sourceDesc//tei:relation/substring-after(@active,'work/'), '-')"/>
            <sch:assert test="starts-with(., $target)"><sch:value-of select="."/></sch:assert>            
        </sch:rule>
        -->

    </sch:pattern>
</sch:schema>
