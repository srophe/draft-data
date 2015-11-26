xquery version "3.0";

(: Tested in eXide :)

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace syriaca = "http://syriaca.org";
declare namespace functx = "http://www.functx.com";

(: perhaps could add a language function that adds @xml:lang to titles based on common words appearing 
in Fr/En/De :)
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
                <bibl>
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
                    else <p>{$part/text()}</p>
                }
                </bibl>
    } ;
    
declare function syriaca:trim
    ($text-to-trim as xs:string*) as xs:string* {
    for $text in $text-to-trim
    return replace($text,('^\s+|^[,]+|\s+$|[,]+$'),'')
    } ;
    
declare function functx:add-attributes
  ( $elements as element()* ,
  (: changed $attrNames from xs:QName* to xs:string* since it was creating namespace problems I was having trouble resolving :)
    $attrNames as xs:string* ,
    $attrValues as xs:anyAtomicType* )  as element()? {

   for $element in $elements
   return element { node-name($element)}
                  { for $attrName at $seq in $attrNames
                    return if ($element/@*[string(node-name(.)) = $attrName])
                           then ()
                           else attribute {$attrName}
                                          {$attrValues[$seq]},
                    $element/@*,
                    $element/node() }
 } ;
 
 declare function functx:escape-for-regex
  ( $arg as xs:string? )  as xs:string {

   replace($arg,
           '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
 } ;
 
<TEI xmlns="http://www.tei-c.org/ns/1.0">
   <teiHeader>
      <fileDesc>
         <titleStmt>
            <title></title>
         </titleStmt>
         <publicationStmt><p/></publicationStmt>
         <sourceDesc><p/></sourceDesc>
      </fileDesc>
   </teiHeader>
   <text>
      <body>
         <listBibl> 
            {

let $uri := "https://raw.githubusercontent.com/srophe/draft-data/master/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull-normalized-spaces-and-vertical-tabs.xml"

for $bibl in fn:doc($uri)//bibl
return
    let $page-test :=
        syriaca:nodes-from-regex($bibl/text(),"[,]*\s*[p]\.\s*(\w*[-]*w*.*)$","biblScope",1,false())
    let $pages := functx:add-attributes($page-test/biblScope,'unit','pp')
    let $col-test := syriaca:nodes-from-regex($page-test/p/text(),'[,]*\s*col\.\s*(\w*[-]*w*.*)$','biblScope',1,false())
    let $cols := functx:add-attributes($col-test/biblScope,'unit','col')
    let $author-test := syriaca:nodes-from-regex($col-test/p/text(),'^(.+?),\s*','author',1,false())
    let $authors-fullname := tokenize($author-test/author/text(),"[\s]et[\s]|[,][\s]+")
    let $authors := 
        for $author in $authors-fullname
        return <author> {
                    syriaca:nodes-from-regex($author,"^([\w\.\-]*\s*\w{0,1}\.{0,1}\s*\w{0,1}\.{0,1})[\s]+.+$","forename",1,false())/forename ,
                    syriaca:nodes-from-regex($author,"[\s]+([\w\-\?\s]+)$","surname",1,false())/surname ,
                    syriaca:nodes-from-regex($author,"^([\w\-\?]+)$","surname",1,false())/surname
               }
               </author> 
    (: If the following doesn't work right, try running it on $bibl/text() instead of $author-test/p/text() :)
    let $title-analytic-parsing := replace($author-test/p/text(),'[,][\s]*dans','~~~dans')
    let $title-analytic-test := syriaca:nodes-from-regex($title-analytic-parsing,"^(.*)~~~","title",1,true())
    let $titles-analytic := functx:add-attributes($title-analytic-test/title,'level','a')
    let $date-test := syriaca:nodes-from-regex($title-analytic-test/p/text(),'[\(]*([\d]+[\-]*[\d]*|s\.\s*d\.)[\)]*$','date',1,false())
    let $dates := $date-test/date
    let $title-journal-test := syriaca:nodes-from-regex($title-analytic-test/p/text(),'[,]*[\s]*dans[\s]*([\w\-:\s]+)[,][\s]*([\d]+[\d\s\(\)]*)[\s]*\([\d\-]+\)','title',1,true())
    let $titles-journal := functx:add-attributes($title-journal-test/title,'level','j')
    let $vol-journal-test := syriaca:nodes-from-regex($title-analytic-test/p/text(), '[,]*[\s]*dans[\s]*([\w\-:\s]+)[,][\s]*([\d]+[\d\s\(\)]*)[\s]*\([\d\-]+\)','biblScope',2,false())
    let $vols-journal := functx:add-attributes($vol-journal-test/biblScope,'unit','vol')
    let $pubPlace-test := syriaca:nodes-from-regex($vol-journal-test/p/text(),'[,][\s]*([\w\-\s]+)[,][\s]*[\d]{4}$','pubPlace',1,false())
    let $pubPlaces := $pubPlace-test/pubPlace
    let $title-series-test := syriaca:nodes-from-regex($pubPlace-test/p/text(),'\(([^\(]*)[,\s]+[\d]+\)$','title',1,true())
    let $titles-series := functx:add-attributes($title-series-test/title,'level','s')
    let $vol-series-test := syriaca:nodes-from-regex($pubPlace-test/p/text(),'\([^\(]*[,\s]+([\d]+)\)$','biblScope',1,false())
    let $vols-series := functx:add-attributes($vol-series-test/biblScope,'unit','vol')
    let $editor-test := 
        (: have to do this part manually using analyze-string instead of the custom syriaca:nodes-from-regex because 
        we need to be able to match against two patterns at once :)
        for $string in $vol-series-test/p/text()
        return
            for $editor-test-string in analyze-string($string,('([,\?][\s]*|^)dans[\s]*(.+)[\s]+\([eé]d\.\)|[eé]d\.[\s]*(par|by)*[\s]+(.*)$'))/node()
            return
                <bibl>
                {
                    if($editor-test-string instance of element(fn:match)) then
                        if($editor-test-string/fn:group[@nr=2 or @nr=4]) then 
                            <editor>{$editor-test-string/fn:group[@nr=2 or @nr=4]/text()}</editor>
                        else ()
                    else <p>{$editor-test-string/text()}</p>
                }
                </bibl>
    let $editors-fullname := tokenize($editor-test/editor/text(),"[\s]et[\s]|[,][\s]+|[\s]and[\s]")
    let $editors := 
        for $editor in $editors-fullname
        return <editor> {
                    syriaca:nodes-from-regex($editor,"^([\w\.\-]*\s*\w{0,1}\.{0,1}\s*\w{0,1}\.{0,1})[\s]+.+$","forename",1,false())/forename ,
                    syriaca:nodes-from-regex($editor,"[\s]+([\w\-\?\s]+)$","surname",1,false())/surname ,
                    syriaca:nodes-from-regex($editor,"^([\w\-\?]+)$","surname",1,false())/surname
               }
               </editor>
    (: the following is not catching all the instances of "dans ..." that it should. e.g., ", dans V Symposium Syriacum..." :)
    let $title-edited-book-test := syriaca:nodes-from-regex($editor-test/p/text(),('(^[,][\s]*|dans)[\s]+(.+)$'),'title',2,true())
    let $titles-edited-book := functx:add-attributes($title-edited-book-test/title,'level','m')
    let $unprocessed-text := 
        if($title-edited-book-test/p/text() and $titles-analytic/text()) then
            replace($title-edited-book-test/p/text(),functx:escape-for-regex($titles-analytic/text()),'')
        else $title-edited-book-test/p/text()
    let $title-monograph-test := syriaca:nodes-from-regex($unprocessed-text,'(.+)','title',1,true())
    let $titles-monograph := functx:add-attributes($title-monograph-test/title,'level','m')
    let $leftovers := $title-monograph-test/p
        
let $citation := 
    (if($titles-analytic) then
        <analytic>
            {$authors, $titles-analytic}
        </analytic>
    else (),
    if($titles-monograph) then
        <monogr>
            {$authors,$titles-monograph}
            <imprint>
                {$pubPlaces,$dates}
            </imprint>
            {$pages, $cols}
        </monogr>
    else (),
    if($titles-edited-book or $editors) then
        <monogr>
            {$editors,$titles-edited-book}
            <imprint>
                {$pubPlaces,$dates}
            </imprint>
            {$pages, $cols}
        </monogr>
    else (),
    if($titles-journal or $vols-journal) then
        <monogr>
            {$titles-journal}
            <imprint>
                {$dates}
            </imprint>
            {$vols-journal,$pages, $cols}
        </monogr>
    else (),
    if($titles-series or $vols-series) then
        <series>
            {$titles-series,$vols-series}
        </series>
    else(),
    if($leftovers) then
        <note>
            {$leftovers}
        </note>
    else())

let $articeldatereturn := element biblStruct {($bibl/@xml:id, $citation)}
return ($bibl,$articeldatereturn)

            }
        </listBibl>
      </body>
   </text>
</TEI>
