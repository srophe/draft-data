xquery version "3.0";

(: Tested in eXide :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace syriaca = "http://syriaca.org";
declare namespace functx = "http://www.functx.com";

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
    
declare function syriaca:nodes-from-regex
    ($input-string as xs:string*, $pattern as xs:string, $element as xs:string, $regex-group as xs:integer, $expand-abbreviation as xs:boolean) as element()* {
        for $string in $input-string
        return
            for $part in analyze-string($string, $pattern)/node()
            return
                <tei:bibl>
                {
                    if ($part instance of element(fn:match)) then
                        if($part/fn:group[@nr=$regex-group]) then 
                            element {$element} {
                                if($expand-abbreviation) then 
                                    syriaca:expand-abbreviations(replace($part/fn:group[@nr=$regex-group]/text(),('^\s+|^[,]+|\s+$|[,]+$'),''))
                                else replace($part/fn:group[@nr=$regex-group]/text(),('^\s+|^[,]+|\s+$|[,]+$'),'')
                                }
                        else ()
                    else <tei:p>{$part/text()}</tei:p>
                }
                </tei:bibl>
    } ;
    
declare function syriaca:trim-elements
    ($elements-to-trim as element()*) as xs:string* {
    for $element in $elements-to-trim
    return replace($element,('>[\s]+|[\s]+<|>[,]+|[,]+<'),'')
    
    } ;
    
declare function functx:add-attributes
  ( $elements as element()* ,
    $attrNames as xs:QName* ,
    $attrValues as xs:anyAtomicType* )  as element()? {

   for $element in $elements
   return element { node-name($element)}
                  { for $attrName at $seq in $attrNames
                    return if ($element/@*[node-name(.) = $attrName])
                           then ()
                           else attribute {$attrName}
                                          {$attrValues[$seq]},
                    $element/@*,
                    $element/node() }
 } ;

let $uri := "https://raw.githubusercontent.com/srophe/draft-data/master/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull-normalized-spaces-and-vertical-tabs.xml"

for $bibl in fn:doc($uri)//tei:bibl
return
    let $citedRange-test :=
        syriaca:nodes-from-regex($bibl/text(),"[,]*\s*[p]\.\s*(\w*[-]*w*.*)$","tei:citedRange",1,false())
    let $citedRanges := functx:add-attributes($citedRange-test/tei:citedRange,xs:QName('unit'),'pp')
    let $author-test := syriaca:nodes-from-regex($citedRange-test/tei:p/text(),'^(.+?),\s*','tei:author',1,false())
    let $authors-fullname := tokenize($author-test/tei:author/text(),"[\s]et[\s]|[,][\s]+")
    let $authors := 
        for $author in $authors-fullname
        return <tei:author> {
                    syriaca:nodes-from-regex($author,"^([\w\.\-]*\s*\w{0,1}\.{0,1}\s*\w{0,1}\.{0,1})[\s]+.+$","tei:forename",1,false())/tei:forename ,
                    syriaca:nodes-from-regex($author,"[\s]+([\w\-\?\s]+)$","tei:surname",1,false())/tei:surname ,
                    syriaca:nodes-from-regex($author,"^([\w\-\?]+)$","tei:surname",1,false())/tei:surname
               }
               </tei:author> 
    (: If the following doesn't work right, try running it on $bibl/text() instead of $author-test/tei:p/text() :)
    let $title-analytic-test := syriaca:nodes-from-regex($author-test/tei:p/text(),"^(.*)[,][\s]*dans[\s]*","tei:title",1,true())
    let $titles-analytic := functx:add-attributes($title-analytic-test/tei:title,xs:QName('level'),'a')
    let $date-test := syriaca:nodes-from-regex($title-analytic-test/tei:p/text(),'[\(]*([\d]+[\-]*[\d]*)[\)]*$','tei:date',1,false())
    let $dates := $date-test/tei:date
    let $title-journal-test := syriaca:nodes-from-regex($author-test/tei:p/text(),'^.*[,][\s]*dans[\s]*([\w\-:\s]*)[,]','tei:title',1,true())
    let $titles-journal := functx:add-attributes($title-journal-test/tei:title,xs:QName('level'),'j')
    let $vol-journal-test := syriaca:nodes-from-regex($title-journal-test/tei:p/text(), '[\s]*([\d]+)[\s]*\([\d\-]+\)$','tei:citedRange',1,false())
    let $vols-journal := functx:add-attributes($vol-journal-test/tei:citedRange,xs:QName('unit'),'vol')
    let $pubPlace-test := syriaca:nodes-from-regex($vol-journal-test/tei:p/text(),'[,][\s]*([\w\-\s]+)[,][\s]*[\d]{4}$','tei:pubPlace',1,false())
    let $pubPlaces := $pubPlace-test/tei:pubPlace
    let $title-series-test := syriaca:nodes-from-regex($pubPlace-test/tei:p/text(),'\(([^\(]*)[,\s]+[\d]+\)$','tei:title',1,true())
    let $titles-series := functx:add-attributes($title-series-test/tei:title,xs:QName('level'),'s')
    let $vol-series-test := syriaca:nodes-from-regex($pubPlace-test/tei:p/text(),'\([^\(]*[,\s]+([\d]+)\)$','tei:citedRange',1,false())
    let $vols-series := functx:add-attributes($vol-series-test/tei:citedRange,xs:QName('unit'),'vol')
    let $editor-test := 
        (: have to do this part manually using analyze-string instead of the custom syriaca:nodes-from-regex because 
        we need to be able to match against two patterns at once :)
        for $editor-test-string in analyze-string($vol-series-test/tei:p/text(),('[,\?][\s]*dans[\s]*(.+)[\s]+\([eé]d\.\)|[eé]d\.[\s]*(par|by)*[\s]+(.*)$'))/node()
        return
            <tei:bibl>
            {
                if($editor-test-string instance of element(fn:match)) then
                    if($editor-test-string/fn:group[@nr=1 or @nr=3]) then 
                        <tei:editor>{$editor-test-string/fn:group[@nr=1 or @nr=3]/text()}</tei:editor>
                    else ()
                else <tei:p>{$editor-test-string/text()}</tei:p>
            }
            </tei:bibl>
    let $editors-fullname := tokenize($editor-test/tei:editor/text(),"[\s]et[\s]|[,][\s]+|[\s]and[\s]")
    let $editors := 
        for $editor in $editors-fullname
        return <tei:editor> {
                    syriaca:nodes-from-regex($editor,"^([\w\.\-]*\s*\w{0,1}\.{0,1}\s*\w{0,1}\.{0,1})[\s]+.+$","tei:forename",1,false())/tei:forename ,
                    syriaca:nodes-from-regex($editor,"[\s]+([\w\-\?\s]+)$","tei:surname",1,false())/tei:surname ,
                    syriaca:nodes-from-regex($editor,"^([\w\-\?]+)$","tei:surname",1,false())/tei:surname
               }
               </tei:editor>
    let $title-edited-book-test := syriaca:nodes-from-regex($editor-test/tei:p/text(),('^[,][\s]+(.*)$'),'tei:title',1,true())
    let $titles-edited-book := functx:add-attributes($title-edited-book-test/tei:title,xs:QName('level'),'m')
    let $unprocessed-text := 
        if($title-edited-book-test/tei:p/text() and $titles-analytic/text()) then
            replace($title-edited-book-test/tei:p/text(),$titles-analytic/text(),'')
        else $title-edited-book-test/tei:p/text()
    let $title-monograph-test := syriaca:nodes-from-regex($unprocessed-text,'(.+)','tei:title',1,true())
    let $titles-monograph := functx:add-attributes($title-monograph-test/tei:title,xs:QName('level'),'m')
    let $leftovers := $title-monograph-test/tei:p

(:let $citation := 
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
                                                        else <tei:title level="m">{syriaca:expand-abbreviations($edited-book/text())}</tei:title>:)
        
let $citation := ($authors, $titles-analytic, $titles-monograph, $titles-journal, $vols-journal, $editors, $titles-edited-book, $titles-series, $vols-series, $pubPlaces, $dates, $citedRanges, $leftovers)
let $articeldatereturn := element tei:bibl {($bibl/@xml:id, $citation)}
return ($bibl,$articeldatereturn)