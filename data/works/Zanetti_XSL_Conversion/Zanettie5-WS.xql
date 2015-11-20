xquery version "3.0";

(: Tested in eXide :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace syriaca = "http://syriaca.org";

(: Compares the input string to a list of abbreviations and expands it, if found. :)
declare function syriaca:expand-abbreviations
  ( $abbreviation as xs:string?)  as xs:string? { 
   let $abb-uri := "https://raw.githubusercontent.com/srophe/draft-data/master/data/works/Zanetti_XSL_Conversion/ZanettiAbbreviations.xml"
   let $abbreviations := fn:doc($abb-uri)
   return
   (: If there's a row with an abbreviation that matches the input string ... :)
    if($abbreviations//row[Abbreviated_Title=$abbreviation]) then
        (: grab the expanded version :)
         $abbreviations//row[Abbreviated_Title=$abbreviation]/Expanded_Title/text()
         (: otherwise just return the input string :)
    else $abbreviation
 } ;

declare function syriaca:split-name-parts
    ($name as xs:string?, $name-part-pattern as xs:string?, $name-part-regex-group as xs:integer) {
        for $name-part in analyze-string($name, $name-part-pattern)/node()
        return
            if ($name-part instance of element(fn:match)) then 
                if($name-part/fn:group[@nr=$name-part-regex-group]) then 
                    $name-part/fn:group[@nr=$name-part-regex-group]/text()
                else ()
            else ()
    } ;
    
declare function syriaca:nodes-from-regex
    ($input-string as xs:string, $pattern as xs:string, $element as xs:string, $regex-group as xs:integer) as element()* {
        for $part in analyze-string($input-string, $pattern)/node()
        return
            <tei:bibl>
            {
                if ($part instance of element(fn:match)) then
                    if($part/fn:group[@nr=$regex-group]) then 
                        element {$element} {$part/fn:group[@nr=$regex-group]/text()}
                    else ()
                else <tei:p>{$part/text()}</tei:p>
            }
            </tei:bibl>
    } ;

let $uri := "https://raw.githubusercontent.com/srophe/draft-data/master/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull-normalized-spaces-and-vertical-tabs.xml"

for $bibl in fn:doc($uri)//tei:bibl

(:let $citedRangeTest :=
    syriaca:nodes-from-regex($bibl/text(),"[,]*\s*[p]\.\s*(\w*[-]*w*.*)$","tei:citedRange",1)
let $citedRanges := element tei:citedRange { attribute unit { 'pp' }, $citedRangeTest/tei:citedRange/text() }
let $all-authors := syriaca:nodes-from-regex($citedRangeTest/tei:p/text(),'^(.+?),\s*','tei:author',1)
let $unsplit-authors := tokenize($all-authors,"[\s]et[\s]|[,][\s]+")
let $authors := 
    for $author in $unsplit-authors
    return syriaca:nodes-from-regex($author,"^([\w\.\-]*\s*\w{0,1}\.{0,1}\s*\w{0,1}\.{0,1})[\s]+.+$","forename",1):)

let $citation := 
    for $bibl in analyze-string(normalize-space($bibl/text()),"^(.+?),\s*|[,]*\s*[p]\.\s*(\w*[-]*w*.*)$")/node()
    return 
        if ($bibl instance of element(fn:match)) then 
            if($bibl/fn:group[@nr='1']) then 
                for $author in tokenize($bibl/fn:group[@nr='1']/text(), "[\s]et[\s]|[,][\s]+")
                return
                    <tei:author>
                        <tei:forename>{syriaca:split-name-parts($author,"^([\w\.\-]*\s*\w{0,1}\.{0,1}\s*\w{0,1}\.{0,1})[\s]+.+$",1)}</tei:forename>
                        <tei:surname>
                            {syriaca:split-name-parts($author,"[\s]+([\w\-\?\s]+)$",1)}
                            {syriaca:split-name-parts($author,"^([\w\-\?]+)$",1)}
                        </tei:surname>
                    </tei:author>
            else if($bibl/fn:group[@nr='2']) then 
                <tei:citedRange unit="pp">{$bibl/fn:group[@nr='2']/text()}</tei:citedRange>
            else <tei:p>{$bibl/text()}</tei:p>
        else 
            for $titles in analyze-string($bibl/text(),"^(.*)[,][\s]*dans[\s]*|[\(]*([\d]+[\-]*[\d]*)[\)]*$")/node()
            return
                if ($titles instance of element(fn:match)) then 
                    if($titles/fn:group[@nr='1']) then 
                        <tei:title level="a">{$titles/fn:group[@nr='1']/text()}</tei:title>
                    else if($titles/fn:group[@nr='2']) then 
                        <tei:date>{$titles/fn:group[@nr='2']/text()}</tei:date>
                    else <tei:p>{$bibl/text()}</tei:p>
                else 
                    for $journal in analyze-string($bibl/text(), "^.*[,][\s]*dans[\s]*([\w\-:\s]*)[,]|[\s]*([\d]+)[\s]*\([\d\-]+\)$")/node()
                    return
                        if ($journal instance of element(fn:match)) then
                            if($journal/fn:group[@nr='1']) then 
                                <tei:title level="j">{syriaca:expand-abbreviations($journal/fn:group[@nr='1']/text())}</tei:title>
                            else if($journal/fn:group[@nr='2']) then 
                                <tei:citedRange unit="vol">{$journal/fn:group[@nr='2']/text()}</tei:citedRange>
                            else <tei:p>{$journal/text()}</tei:p>
                        else 
                            for $publication in analyze-string($journal/text(), "[,][\s]*([\w\-\s]+)[,][\s]*[\d]{4}$")/node()
                            return
                                if ($publication instance of element(fn:match)) then
                                    if($publication/fn:group[@nr='1']) then 
                                        <tei:pubPlace>{$publication/fn:group[@nr='1']/text()}</tei:pubPlace>
                                    else <tei:p>{$publication/text()}</tei:p>
                                else 
                                    for $series in analyze-string($publication/text(), "\(([^\(]*)[,\s]+[\d]+\)$")/node()
                                    return
                                        if ($series instance of element(fn:match)) then
                                            if($series/fn:group[@nr='1']) then 
                                                <tei:title level="s">{syriaca:expand-abbreviations(replace($series/fn:group[@nr='1']/text(),"[,]$",""))}</tei:title>
                                            else if($series/fn:group[@nr='2']) then 
                                                <tei:citedRange level="vol">{$series/fn:group[@nr='2']/text()}</tei:citedRange>
                                            else <tei:p>{$series/text()}</tei:p>
                                    else 
                                        for $series-vol in analyze-string($publication/text(), "\([^\(]*[,\s]+([\d]+)\)$")/node()
                                        return 
                                            if ($series-vol instance of element(fn:match)) then
                                                if($series-vol/fn:group[@nr='1']) then 
                                                    <tei:citedRange level="vol">{$series-vol/fn:group[@nr='1']/text()}</tei:citedRange>
                                                else <tei:p>{$series-vol/text()}</tei:p>
                                            else 
                                                for $editors in analyze-string(normalize-space($series-vol/text()), "[,\?][\s]*dans[\s]*(.+)[\s]+\([eé]d\.\)|[eé]d\.[\s]*(par|by)*[\s]*(.*)$")/node()
                                                return 
                                                    if ($editors instance of element(fn:match)) then
                                                        if($editors/fn:group[@nr='1'] or $editors/fn:group[@nr='3']) then 
                                                            let $editors-all := concat($editors/fn:group[@nr='1']/text(),$editors/fn:group[@nr='3']/text())
                                                            return 
                                                                for $editor in tokenize($editors-all, "[\s]et[\s]|[,][\s]+|[\s]and[\s]")
                                                                return <tei:editor>
                                                                            <tei:forename>{syriaca:split-name-parts($editor,"^([\w\.\-]*\s*\w{0,1}\.{0,1}\s*\w{0,1}\.{0,1})[\s]+.+$",1)}</tei:forename>
                                                                            <tei:surname>
                                                                                {syriaca:split-name-parts($editor,"[\s]+([\w\-\?\s]+)$",1)}
                                                                                {syriaca:split-name-parts($editor,"^([\w\-\?]+)$",1)}
                                                                            </tei:surname>
                                                                        </tei:editor>
                                                        else <tei:p>{$editors/text()}</tei:p>
                                                else 
                                                    for $edited-book in analyze-string($editors/text(), "^[,][\s]+(.*)$")/node()
                                                    return
                                                        if ($edited-book instance of element(fn:match)) then
                                                            if($edited-book/fn:group[@nr='1']) then 
                                                                <tei:title level="m">{syriaca:expand-abbreviations($edited-book/fn:group[@nr='1']/text())}</tei:title>
                                                            else <tei:p>{$edited-book/text()}</tei:p>
                                                        else <tei:title level="m">{syriaca:expand-abbreviations($edited-book/text())}</tei:title>
        
let $articeldatereturn := element tei:bibl {($bibl/@xml:id, $citation)}
return ($bibl,$articeldatereturn)