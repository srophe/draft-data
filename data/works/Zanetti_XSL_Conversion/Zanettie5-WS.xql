xquery version "3.0";

(: Tested in eXide :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $uri := "https://raw.githubusercontent.com/srophe/draft-data/master/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull.xml"
for $bibl in fn:doc($uri)//tei:bibl
let $citation := 
    for $bibl in analyze-string(normalize-space($bibl/text()),"^(.+?),\s*|[,]*\s*[p]\.\s*(\w*[-]*w*.*)$")/node()
    return 
        if ($bibl instance of element(fn:match)) then 
            if($bibl/fn:group[@nr='1']) then 
                <tei:author>{$bibl/fn:group[@nr='1']/text()}</tei:author>
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
            else <tei:p>{$bibl/text()}</tei:p>
        
let $articeldatereturn := element tei:bibl {($bibl/@xml:id, $citation)}
return ($bibl,$articeldatereturn)