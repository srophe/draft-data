xquery version "3.0";

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

let $uri := "ZanettiBiblFull-normalized-spaces-and-vertical-tabs.xml"
(:https://raw.githubusercontent.com/srophe/draft-data/master/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull-normalized-spaces-and-vertical-tabs.xml:)

let $all-bibls := 
    for $bibl in fn:doc($uri)//bibl
    return
        let $page-test :=
            syriaca:nodes-from-regex($bibl/text(),"[,]*\s*[p]\.\s*(\w*[-]*w*.*)$","biblScope",1,false())
        let $pages := functx:add-attributes($page-test/biblScope,('unit','corresp'),('pp',$bibl/@xml:id))
        let $col-test := syriaca:nodes-from-regex($page-test/p/text(),'[,]*\s*col\.\s*(\w*[-]*w*.*)$','biblScope',1,false())
        let $cols := functx:add-attributes($col-test/biblScope,('unit','corresp'),('col',$bibl/@xml:id))
        let $pages-and-cols := ($pages,$cols)
        
        let $articeldatereturn := element bibl {$bibl/@xml:id, element p {$col-test/p/text()}, element citedRange {($pages-and-cols/@unit,$pages-and-cols/@corresp,$pages-and-cols/node())}}
        return ($articeldatereturn,$pages)
let $unique-bibls := 
    for $unique-bibl at $pos in distinct-values($all-bibls/p)
    let $idno := 700 + $pos
    let $matching-bibls := $all-bibls[p/text()=$unique-bibl]
    let $corresp := 
        for $id in $matching-bibls/@xml:id
        return $id
    let $citedRanges :=
        for $citedRange in $matching-bibls/citedRange
        return 
            if($citedRange != '') then
                $citedRange
            else ()
    return
        element bibl {attribute xml:id {$idno}, attribute corresp {$corresp}, element p {$unique-bibl}, $citedRanges}
(:let $citedRanges := 
    for $bibl in $unique-bibls
    return
        for $item in $unique-bibls/@corresp
        return $all-bibls/biblScope[@corresp=$item]:)
return ($unique-bibls)
        }
        </listBibl>
      </body>
   </text>
</TEI>