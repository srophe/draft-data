<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern>




        <!--In ODD already
            <sch:rule context="tei:event/tei:ptr/@target">
            <sch:assert test="count(distinct-values(tokenize(., ' '))) = count(tokenize(., ' '))">
                The same keyword URI may not appear twice as the value of the @type attribute. </sch:assert>
            <sch:assert
                test="
                    every $i in (tokenize(., ' '))
                        satisfies starts-with($i, 'http://syriaca.org/keyword/')"
                >@target attributes on the &lt;ptr&gt; element must contain a properly formatted
                Syriaca.org keyword URI that starts with 'http://syriaca.org/keyword/'.</sch:assert>
        </sch:rule>-->


        <!--In ODD already
            <sch:rule context="tei:event/tei:ptr/@target" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="taxonomyAllURIs" value="$ti//listURI[@type = 'taxonomyAllURIs']/uri"/>
            <sch:let name="distintURIs" value="tokenize(., ' ')"/>
            <sch:assert
                test="
                    every $i in $distintURIs
                        satisfies $i = $taxonomyAllURIs"
                >SPEAR has a strong preference for using established URIs when possible but
                appropriate URIs are not always available in the Syriaca.org taxonomy. For the
                @target attribute on a &lt;ptr&gt; element within an event factoid, please look for
                the appropriate keyword(s) in the Syriaca.org Taxonomy. If you cannot find an
                appropriate term, apply a preferred term of your choosing.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule
            context="tei:note[parent::tei:birth or parent::tei:death or parent::tei:education or parent::tei:langKnowledge or parent::tei:nationality or parent::occupation or parent::tei:residence or parent::tei:socecStatus or parent::tei:state or parent::tei:trait]">
            <sch:assert test="@type = 'desc'">Elements of type &lt;note&gt; must contain the
                attribute @type="desc" and other &lt;note&gt; types are not allowed in this context.
                Other types of notes ("incerta", "dubia", and "errata") may appear as children of
                the &lt;div&gt; element as needed.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:state[@type = 'sanctity']/@ref" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="sanctity"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/sanctity']/uri"/>
            <sch:assert
                test="
                every $i in (tokenize(., ' '))
                satisfies $i = $sanctity"
                >SPEAR has a strong preference for using established URIs when possible but
                appropriate URIs are not always available in the Syriaca.org taxonomy. Please
                consider the following options from the taxonomy before using your own preferred
                descriptive term: <sch:value-of select="string-join($sanctity, ';  ')"
                />.</sch:assert>
        </sch:rule>
        
        <sch:rule context="tei:state[@type = 'mental']/@ref" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="mentalStates"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/mental-states']/uri"/>
            <sch:assert
                test="
                every $i in (tokenize(., ' '))
                satisfies $i = $mentalStates"
                >SPEAR has a strong preference for using established URIs when possible but
                appropriate URIs are not always available in the Syriaca.org taxonomy. Please
                consider the following options from the taxonomy before using your own preferred
                descriptive term: <sch:value-of select="string-join($mentalStates, ';  ')"
                />.</sch:assert>
        </sch:rule>
        
        <sch:rule context="tei:trait[@type = 'gender']/@ref" role="warning">
            <sch:assert
                test="
                    every $i in (tokenize(., ' '))
                        satisfies $i = 'http://syriaca.org/keyword/eunuch' or $i = 'http://syriaca.org/keyword/female' or $i = 'http://syriaca.org/keyword/male' or $i = 'http://syriaca.org/keyword/nun-as-monk'"
                >Preferred values for the @ref attribute on a &lt;trait&gt; element
                with a @type attribute with the value "gender" are:
                "http://syriaca.org/keyword/eunuch"; "http://syriaca.org/keyword/female";
                "http://syriaca.org/keyword/male"; and "http://syriaca.org/keyword/nun-as-monk". Use
                these if applicable. If one of these does not apply, please use a descriptive term
                of your choosing.</sch:assert>
            <!-\- I need to update the taxonomy before I can use it to validate the corresponding @ref values. -\->
        </sch:rule>

        <sch:rule context="tei:trait[@type = 'ethnicLabel']/@ref" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="ethnicLabels"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/ethnicity']/uri"/>
            <sch:assert
                test="
                    every $i in (tokenize(., ' '))
                        satisfies $i = $ethnicLabels"
                >SPEAR has a strong preference for using established URIs when possible but
                appropriate URIs are not always available in the Syriaca.org taxonomy. Please
                consider the following options from the taxonomy before using your own preferred
                descriptive term: <sch:value-of select="string-join($ethnicLabels, ';  ')"
                />.</sch:assert>
        </sch:rule>

        <sch:rule context="tei:education/@ref" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="fieldsOfStudy"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/fields-of-study']/uri"/>
            <sch:assert
                test="
                    every $i in (tokenize(., ' '))
                        satisfies $i = $fieldsOfStudy"
                >SPEAR has a strong preference for using established URIs when possible but
                appropriate URIs are not always available in the Syriaca.org taxonomy. Please
                consider the following options from the taxonomy before using your own preferred
                descriptive term: <sch:value-of select="string-join($fieldsOfStudy, ';  ')"
                />.</sch:assert>
        </sch:rule>

        <sch:rule context="tei:langKnown/@ref" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="languages"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/languages']/uri"/>
            <sch:assert
                test="
                    every $i in (tokenize(., ' '))
                        satisfies $i = $languages"
                >SPEAR has a strong preference for using established URIs when possible but
                appropriate URIs are not always available in the Syriaca.org taxonomy. Please
                consider the following options from the taxonomy before using your own preferred
                descriptive term: <sch:value-of select="string-join($languages, ';  ')"
                />.</sch:assert>
        </sch:rule>

        <sch:rule context="tei:occupation/@ref" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="occupations"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/occupations']/uri"/>
            <sch:assert
                test="
                    every $i in (tokenize(., ' '))
                        satisfies $i = $occupations"
                >SPEAR has a strong preference for using established URIs when possible but
                appropriate URIs are not always available in the Syriaca.org taxonomy. Please
                consider the following options from the taxonomy before using your own preferred
                descriptive term: <sch:value-of select="string-join($occupations, ';  ')"
                />.</sch:assert>
        </sch:rule>

        <sch:rule context="tei:socecStatus/@ref" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="socioeconomicStatus"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/socioeconomic-status']/uri"/>
            <sch:assert
                test="
                    every $i in (tokenize(., ' '))
                        satisfies $i = $socioeconomicStatus"
                >SPEAR has a strong preference for using established URIs when possible but
                appropriate URIs are not always available in the Syriaca.org taxonomy. Please
                consider the following options from the taxonomy before using your own preferred
                descriptive term: <sch:value-of select="string-join($socioeconomicStatus, ';  ')"
                />.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:div/tei:listRelation/tei:relation/@type">
            <sch:let name="ti" value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="qrURI"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/qualifier-relationships']//uri"/>
            <sch:assert
                test="
                    every $i in (tokenize(., ' '))
                        satisfies $i = $qrURI"
                >The value(s) of this @type attribute must come from the qualifier relationships in the Syriaca.org taxonomy: <sch:value-of
                    select="string-join($qrURI, ';  ')"/>.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:div/tei:listRelation/tei:relation/@mutual">
            <sch:assert test="every $i in (tokenize(., ' ')) satisfies starts-with($i, 'http://syriaca.org/person/')">@mutual attributes on
                &lt;relation&gt; elements of relation factoids must contain a properly formatted
                Syriaca.org person URI that starts with 'http://syriaca.org/person/'.</sch:assert>
            <sch:report test="every $i in (tokenize(., ' ')) satisfies matches(substring-after($i, 'person/'), '\D')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:report>
            <sch:assert test="every $i in (tokenize(., ' ')) satisfies matches(substring-after($i, 'person/'), '\d')">Z properly formatted
                Syriaca.org person URI ends with a number.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:div/tei:listRelation/tei:relation/@active">
            <sch:assert test="every $i in (tokenize(., ' ')) satisfies starts-with($i, 'http://syriaca.org/person/')">@active attributes on
                &lt;relation&gt; elements of relation factoids must contain a properly formatted
                Syriaca.org person URI that starts with 'http://syriaca.org/person/'.</sch:assert>
            <sch:report test="every $i in (tokenize(., ' ')) satisfies matches(substring-after($i, 'person/'), '\D')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:report>
            <sch:assert test="every $i in (tokenize(., ' ')) satisfies matches(substring-after($i, 'person/'), '\d')">Z properly formatted
                Syriaca.org person URI ends with a number.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:div/tei:listRelation/tei:relation/@passive">
            <sch:assert test="every $i in (tokenize(., ' ')) satisfies starts-with($i, 'http://syriaca.org/person/')">@passive attributes on
                &lt;relation&gt; elements of relation factoids must contain a properly formatted
                Syriaca.org person URI that starts with 'http://syriaca.org/person/'.</sch:assert>
            <sch:report test="every $i in (tokenize(., ' ')) satisfies matches(substring-after($i, 'person/'), '\D')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:report>
            <sch:assert test="every $i in (tokenize(., ' ')) satisfies matches(substring-after($i, 'person/'), '\d')">Z properly formatted
                Syriaca.org person URI ends with a number.</sch:assert>
        </sch:rule>-->

        <!--<sch:rule context="tei:div/tei:listRelation/tei:relation/@active">
            <sch:assert test="starts-with(., 'http://syriaca.org/person/')">@active attributes on
                &lt;persName&gt; elements must contain a properly formatted Syriaca.org person URI
                that starts with 'http://syriaca.org/person/'.</sch:assert>
            <sch:report test="matches(substring-after(., 'person/'), '\D')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:report>
            <sch:assert test="matches(substring-after(., 'person/'), '\d')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:assert>
        </sch:rule>
        
        
        <sch:rule context="tei:div/tei:listRelation/tei:relation/@passive">
            <sch:assert test="starts-with(., 'http://syriaca.org/person/')">@passive attributes on
                &lt;persName&gt; elements must contain a properly formatted Syriaca.org person URI
                that starts with 'http://syriaca.org/person/'.</sch:assert>
            <sch:report test="matches(substring-after(., 'person/'), '\D')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:report>
            <sch:assert test="matches(substring-after(., 'person/'), '\d')">A properly formatted
                Syriaca.org person URI ends with a number.</sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule
            context="tei:div/tei:listEvent/tei:listRelation/tei:relation/@mutual">
            <sch:assert test="starts-with(., 'http://syriaca.org/spear/')">@mutual attributes on
                &lt;relation&gt; elements within an event factoid must contain a properly formatted
                SPEAR factoid URI that starts with 'http://syriaca.org/spear/'.</sch:assert>
            
        </sch:rule>-->
        <!--In ODD already
            <sch:rule
            context="tei:div/tei:listEvent/tei:listRelation/tei:relation">
            <sch:assert test="@mutual">A @mutual attribute is required on &lt;relation&gt; elements within an event factoid.</sch:assert>
            <sch:report test="@active">@active attributes are not allowed on &lt;relation&gt; elements within an event factoid.</sch:report>
            <sch:report test="@passive">@passive attributes are not allowed on &lt;relation&gt; elements within an event factoid.</sch:report>
        </sch:rule>-->



        <!--In ODD already
            <sch:rule context="tei:trait[@type = 'gender']">
            <sch:assert
                test="@ref = 'http://syriaca.org/keyword/eunuch' or @ref = 'http://syriaca.org/keyword/female' or @ref = 'http://syriaca.org/keyword/male' or @ref = 'http://syriaca.org/keyword/nun-as-monk'"
                >Preferred values for the @ref attribute on a &lt;trait&gt; element with a @type
                attribute with the value "gender" are: "http://syriaca.org/keyword/eunuch";
                "http://syriaca.org/keyword/female"; "http://syriaca.org/keyword/male"; and
                "http://syriaca.org/keyword/nun-as-monk". Please use one of these if applicable.
                Please use a descriptive term of your choosing if one of these does not
                apply.</sch:assert>
            <!-\- I need to update the taxonomy before I can use it to validate the corresponding @ref values. -\->
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:trait[@type = 'ethnicLabel']" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="ethnicLabels"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/ethnicity']/uri"/>
            <sch:assert test="@ref = $ethnicLabels">SPEAR has a strong preference for using
                established URIs when possible but appropriate URIs are not always available in the
                Syriaca.org taxonomy. Please consider the following options from the taxonomy before
                using your own preferred descriptive: <sch:value-of
                    select="string-join($ethnicLabels, ';  ')"/></sch:assert>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:state[@type = 'mental']" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="mentalStates"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/mental-states']/uri"/>
            <sch:assert test="@ref = $mentalStates">SPEAR has a strong preference for using
                established URIs when possible but appropriate URIs are not always available in the
                Syriaca.org taxonomy. Please consider the following options from the taxonomy before
                using your own preferred descriptive term: <sch:value-of
                    select="string-join($mentalStates, ';  ')"/></sch:assert>
        </sch:rule>
        <sch:rule context="tei:state[@type = 'sanctity']" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="sanctity"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/sanctity']/uri"/>
            <sch:assert test="@ref = $sanctity">SPEAR has a strong preference for using
                established URIs when possible but appropriate URIs are not always available in the
                Syriaca.org taxonomy. Please consider the following options from the taxonomy before
                using your own preferred descriptive term: <sch:value-of
                    select="string-join($sanctity, ';  ')"/></sch:assert>
        </sch:rule>-->


        <!--In ODD already
            <sch:rule context="tei:education" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="fieldsOfStudy"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/fields-of-study']/uri"/>
            <sch:assert test="@ref = $fieldsOfStudy">SPEAR has a strong preference for using
                established URIs when possible but appropriate URIs are not always available in the
                Syriaca.org taxonomy. Please consider the following options from the taxonomy before
                using your own preferred descriptive term: <sch:value-of
                    select="string-join($fieldsOfStudy, ';  ')"/></sch:assert>
        </sch:rule>-->


        <!--In ODD already
            <sch:rule context="tei:langKnown" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="languages"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/languages']/uri"/>
            <sch:assert test="@ref = $languages">SPEAR has a strong preference for using
                established URIs when possible but appropriate URIs are not always available in the
                Syriaca.org taxonomy. Please consider the following options from the taxonomy before
                using your own preferred descriptive term: <sch:value-of
                    select="string-join($languages, ';  ')"/></sch:assert>
        </sch:rule>-->


        <!--In ODD already
            <sch:rule context="tei:occupation" role="warning">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="occupations"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/occupations']/uri"/>
            <sch:assert test="@ref = $occupations">SPEAR has a strong preference for using
                established URIs when possible but appropriate URIs are not always available in the
                Syriaca.org taxonomy. Please consider the following options from the taxonomy before
                using your own preferred descriptive term: <sch:value-of
                    select="string-join($occupations, ';  ')"/></sch:assert>
        </sch:rule>-->


        <!--In ODD already
            <sch:rule context="tei:div/tei:listRelation/tei:relation">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="mutual"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/relationships']//uri[@ana = 'mutual']"/>
            <sch:let name="reciprocal"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/relationships']//uri[@ana = 'reciprocal']"/>
            <sch:assert test=".[@ref = $mutual]/@mutual or .[@ref = $reciprocal]/@active">Elements
                of type &lt;relation&gt; take either a @mutual attribute or both @active and
                @passive attributes depending on the type of relationship described. Mutual
                relationships include: <sch:value-of
                    select="string-join($mutual, '; ')"/>. Reciprocal relationships include: <sch:value-of
                    select="string-join($reciprocal, '; ')"/>.</sch:assert>
            <sch:assert test=".[@ref = $mutual]/@mutual or .[@ref = $reciprocal]/@passive">Elements
                of type &lt;relation&gt; take either a @mutual attribute or both @active and
                @passive attributes depending on the type of relationship described. Mutual
                relationships include: <sch:value-of
                    select="string-join($mutual, '; ')"/>. Reciprocal relationships include: <sch:value-of
                        select="string-join($reciprocal, '; ')"/>.</sch:assert>
            <sch:report test=".[@mutual]/@active">A &lt;relation&gt; element cannot take both
                @active and @mutual attributes.</sch:report>
            <sch:report test=".[@mutual]/@passive">A &lt;relation&gt; element cannot take both
                @passive and @mutual attributes.</sch:report>
        </sch:rule>-->

        <!--Not used
            <sch:rule context="tei:div/tei:listRelation/tei:relation[@active]">
            <sch:assert test="@passive">If @active then also @passive</sch:assert>
        </sch:rule>
        <sch:rule context="tei:div/tei:listRelation/tei:relation[@passive]">
            <sch:assert test="@active">If @passive then also @active</sch:assert>
        </sch:rule>
        <sch:rule context="tei:div/tei:listRelation/tei:relation[@mutual]">
            <sch:report test="@active">If @mutual then, neither @passive nor @active</sch:report>
        </sch:rule>-->


        <!--Not used
            <sch:rule context="tei:div/tei:listRelation/tei:relation[@active]">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="mutual"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/relationships']//uri[@ana = 'mutual']"/>
            <sch:let name="reciprocal"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/relationships']//uri[@ana = 'reciprocal']"/>
            <sch:assert test=".[@ref = $reciprocal]">An @active attribute on
                the &lt;relation&gt; element is required with reciprocal relationships, i.e.
                relationships where the parties occupy different positions. Reciprocal relationships
                include (<sch:value-of select="string-join($reciprocal, '; ')"/>).</sch:assert>
            <sch:report test=".[@ref = $mutual]">An @active attribute on the
                &lt;relation&gt; element is not allowed with mutual relationships, i.e.
                relationships where both parties occupy an equivalent position. Mutual relationships
                include (<sch:value-of select="string-join($mutual, '; ')"/>).</sch:report>
        </sch:rule>
        <sch:rule context="tei:div/tei:listRelation/tei:relation[@passive]">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="mutual"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/relationships']//uri[@ana = 'mutual']"/>
            <sch:let name="reciprocal"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/relationships']//uri[@ana = 'reciprocal']"/>
            <sch:assert test=".[@ref = $reciprocal]">A @passive attribute on
                the &lt;relation&gt; element is required with reciprocal relationships, i.e.
                relationships where the parties occupy different positions. Reciprocal relationships
                include (<sch:value-of select="string-join($reciprocal, '; ')"/>).</sch:assert>
            <sch:report test=".[@ref = $mutual]">A @passive attribute on the
                &lt;relation&gt; element is not allowed with mutual relationships, i.e.
                relationships where both parties occupy an equivalent position. Mutual relationships
                include (<sch:value-of select="string-join($mutual, '; ')"/>).</sch:report>
        </sch:rule>
        <sch:rule context="tei:div/tei:listRelation/tei:relation[@mutual]">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:let name="mutual"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/relationships']//uri[@ana = 'mutual']"/>
            <sch:let name="reciprocal"
                value="$ti//listURI[@ref = 'http://syriaca.org/keyword/relationships']//uri[@ana = 'reciprocal']"/>
            <sch:assert test=".[@ref = $mutual]">A @mutual attribute on the
                &lt;relation&gt; element is required with mutual relationships, i.e. relationships
                where both parties occupy an equivalent position. Mutual relationships include
                (<sch:value-of select="string-join($mutual, '; ')"/>).</sch:assert>
            <sch:report test=".[@ref = $reciprocal]">A @mutual attribute on the
                &lt;relation&gt; element is not allowed on reciprocal relationships, i.e.
                relationships where the parties occupy different positions. Reciprocal relationships
                include (<sch:value-of select="string-join($reciprocal, '; ')"/>).</sch:report>
        </sch:rule>-->

        <!--Cannot use because it doesn't seem possible to call a variable from the @context attribute in sch:rule.
            <sch:rule context="tei:div/tei:listRelation/tei:relation[@ref = $reciprocal]">
            <sch:report test="./@mutual">Elements of type &lt;relation&gt; that contain a @ref
                attribute indicating a reciprocal relationship, i.e. a relationship where the
                parties occupy different positions, cannot contain a @mutual attribute. Reciprocal
                relationships include (<sch:value-of select="string-join($reciprocal, '; ')"
                />).</sch:report>
            <sch:assert test="./@active">Elements of type &lt;relation&gt; that contain a @ref
                attribute indicating a reciprocal relationship, i.e. relationships where the parties
                occupy different positions, must contain an @active attribute.</sch:assert>
            <sch:assert test="./@passive">Elements of type &lt;relation&gt; that contain a @ref
                attribute indicating a reciprocal relationship, i.e. relationships where the parties
                occupy different positions, must contain a @passive attribute.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:div/tei:listRelation/tei:relation[@ref = $mutual]">
            <sch:report test="./@active or @passive">Elements of type &lt;relation&gt; that contain a @ref
                attribute indicating a mutual relationships, i.e. relationships where
                both parties occupy an equivalent position, cannot contain @active or @passive
                attributes. Mutual relationships include (<sch:value-of
                    select="string-join($mutual, '; ')"/>).</sch:report>
            <sch:assert test="./@mutual">Mutual relationships, i.e. relationships where both parties
                occupy an equivalent position, must contain a @mutual attribute.</sch:assert>
        </sch:rule>-->


        <!--In ODD already
            <sch:rule context="tei:div/tei:listEvent/tei:listRelation/tei:relation">
            <sch:report test="@type">A &lt;relation&gt; element inside an event factoid cannot take a @type attribute.</sch:report>
        </sch:rule>-->

        <!--In ODD already
            <sch:rule context="tei:div/tei:listRelation/tei:relation/@ref">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:assert
                test=". = $ti//listURI[@ref = 'http://syriaca.org/keyword/relationships']//uri"
                >Value must be one of the following: <sch:value-of
                    select="string-join($ti//listURI[@ref = 'http://syriaca.org/keyword/relationships']//uri, '; ')"
                />.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:div/tei:listEvent/tei:listRelation/tei:relation/@ref">
            <sch:let name="ti"
                value="doc('https://raw.githubusercontent.com/srophe/srophe-app-data/dev/data/subjects/taxonomyIndex.xml')"/>
            <sch:assert
                test=". = $ti//listURI[@ref = 'http://syriaca.org/keyword/event-relationships']/uri"
                >Value must be one of the following: <sch:value-of
                    select="string-join($ti//listURI[@ref = 'http://syriaca.org/keyword/event-relationships']/uri, '; ')"
                />.</sch:assert>
        </sch:rule>-->



        <!--I ended up not using these b/c there could be a need for more than one bibl URI and in some instances there won't be a urn at all.
            <sch:rule context="//tei:sourceDesc//tei:bibl[1]/tei:ptr/@target">
            <sch:assert test="contains(., 'work')">The first &lt;bibl&gt; element must contain a
                &lt;ptr&gt; element whose @target attribute points to a Syriaca.org work
                URI.</sch:assert>
        </sch:rule>
        <sch:rule context="//tei:sourceDesc//tei:bibl[2]/tei:ptr/@target">
            <sch:assert test="contains(., 'bibl')">The second &lt;bibl&gt; element must contain a
                &lt;ptr&gt; element whose @target attribute points to a Syriaca.org bibl
                URI.</sch:assert>
        </sch:rule>
        <sch:rule context="//tei:sourceDesc//tei:bibl[3]/tei:ptr/@target">
            <sch:assert test="contains(., 'urn')">The third &lt;bibl&gt; element must contain a
                &lt;ptr&gt; element whose @target attribute points to a urn.</sch:assert>
        </sch:rule>
        <sch:rule context="//tei:sourceDesc//tei:bibl[4]">
            <sch:report test=".">There cannot be more than three &lt;bibl&gt; elements in the &lt;sourceDesc&gt;.</sch:report>
        </sch:rule>-->


        <!--In ODD already
            <sch:let name="docURIno"
            value="//tei:publicationStmt/tei:idno[@type]/substring-after(substring-before(., '/tei'), 'spear/')"/>
        <sch:rule context="tei:sourceDesc//tei:bibl[@type = 'primary']/tei:ptr/@target">
            <sch:assert
                test=". = concat('http://syriaca.org/work/', $docURIno) or starts-with(., 'http://syriaca.org/bibl/')"
                > The @target attribute on a &lt;ptr&gt; element inside a &lt;bibl&gt; element with @type="primary"
                takes limited values. It either must be "http://syriaca.org/work/<sch:value-of
                    select="$docURIno"/>" or "http://syriaca.org/bibl/" followed by the
                corresponding Syriaca.org bibl URI number. </sch:assert>
        </sch:rule>
        <sch:rule context="tei:sourceDesc//tei:bibl[@type = 'urn']/tei:ptr/@target">
            <sch:assert
                test="starts-with(., concat('urn:cts:syriacLit:nhsl', $docURIno, '.syriacCorpus'))">
                The @target attribute on a &lt;ptr&gt; element inside a &lt;bibl&gt; element with @type="urn" must
                begin either with "urn:cts:syriacLit:nhsl<sch:value-of select="$docURIno"
                />.syriacCorpus" followed by the corresponding Syriac Corpus URI number.
            </sch:assert>
        </sch:rule>-->

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
