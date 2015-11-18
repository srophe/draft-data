xquery version "3.1";

(: Tested in eXide :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $uri := "https://raw.githubusercontent.com/srophe/draft-data/master/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull.xml"
for $bibl in fn:doc($uri)//tei:bibl
let $citation := 
    for $bibl in analyze-string($bibl/text(),"^(.+?),\s*|[,]*\s*[p]\.\s*(\w*[-]*w*.*)$|\s(\d{4})|\s\((\d{4})\)")/node()
    return 
        if ($bibl instance of element(fn:match)) then 
            if($bibl/fn:group[@nr='1']) then 
                <tei:author>{$bibl/fn:group[@nr='1']/text()}</tei:author>
            else if($bibl/fn:group[@nr='2']) then 
                <tei:citedRange>{$bibl/fn:group[@nr='2']/text()}</tei:citedRange>
            else if($bibl/fn:group[@nr='3']) then 
                <tei:date>{$bibl/fn:group[@nr='3']/text()}</tei:date>
            else if($bibl/fn:group[@nr='4']) then     
                <tei:date>{$bibl/fn:group[@nr='4']/text()}</tei:date>
            else <tei:p>{$bibl/text()}</tei:p>
        else 
            <tei:p>{$bibl/text()}</tei:p>
        
let $articeldatereturn := element tei:bibl {($bibl/@xml:id, $citation)}
return ($bibl,$articeldatereturn)