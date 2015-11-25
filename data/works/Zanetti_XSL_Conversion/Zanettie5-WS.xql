xquery version "3.0";

(: Tested in eXide :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace syriaca = "http://syriaca.org";
declare namespace functx = "http://www.functx.com";

(: Compares the input string to a list of abbreviations and expands it, if found. :)
declare function syriaca:expand-abbreviations
  ( $abbreviation as xs:string?)  as xs:string? { 
   let $abb-uri := "https://raw.githubusercontent.com/srophe/draft-data/master/data/works/Zanetti_XSL_Conversion/Zanetti-and-Fiey-Abbreviations.xml"
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
            let $correct-part-text := $part/fn:group[@nr=$regex-group]/text()
            return
                <tei:bibl>
                {
                    if ($part instance of element(fn:match)) then
                        if($correct-part-text) then 
                            if(syriaca:trim($correct-part-text) != '') then
                                element {$element} {
                                    if($expand-abbreviation) then 
                                        syriaca:expand-abbreviations(syriaca:trim($correct-part-text))
                                    else syriaca:trim($correct-part-text)
                                    }
                            else ()
                        else ()
                    else <tei:p>{$part/text()}</tei:p>
                }
                </tei:bibl>
    } ;
    
declare function syriaca:trim
    ($text-to-trim as xs:string*) as xs:string* {
    for $text in $text-to-trim
    return replace($text,('^\s+|^[,]+|\s+$|[,]+$'),'')
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
    let $title-edited-book-test := syriaca:nodes-from-regex($editor-test/tei:p/text(),('^[,][\s]+(.+)$'),'tei:title',1,true())
    let $titles-edited-book := functx:add-attributes($title-edited-book-test/tei:title,xs:QName('level'),'m')
    let $unprocessed-text := 
        if($title-edited-book-test/tei:p/text() and $titles-analytic/text()) then
            replace($title-edited-book-test/tei:p/text(),$titles-analytic/text(),'')
        else $title-edited-book-test/tei:p/text()
    let $title-monograph-test := syriaca:nodes-from-regex($unprocessed-text,'(.+)','tei:title',1,true())
    let $titles-monograph := functx:add-attributes($title-monograph-test/tei:title,xs:QName('level'),'m')
    let $leftovers := $title-monograph-test/tei:p
        
let $citation := ($authors, $titles-analytic, $titles-monograph, $titles-journal, $vols-journal, $editors, $titles-edited-book, $titles-series, $vols-series, $pubPlaces, $dates, $citedRanges, $leftovers)
let $articeldatereturn := element tei:bibl {($bibl/@xml:id, $citation)}
return ($bibl,$articeldatereturn)