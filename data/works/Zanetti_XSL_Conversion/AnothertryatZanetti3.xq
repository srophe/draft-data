xquery version "3.1";

(: Tested in BaseX :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $uri := "https://raw.githubusercontent.com/srophe/draft-data/e898b33a24e175b48931609d64d86a58d3a93f79/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull.xml"

for $bibl in fn:doc($uri)//tei:bibl


let $pages := 
                for $segment in analyze-string($bibl/text(),"[,]*\s*[p]\.\s*(\w*[-]*w*.*)$")/node()
                return
                    if ($segment instance of element(fn:match)) then 
                        <tei:citedRange>{$segment/fn:group[@nr='1']/text()}</tei:citedRange>
                    else 
                        $segment/string()
                        

return element tei:bibl {($bibl/@xml:id, $pages)}

(:let $author := 
                for $segment1 in analyze-string($pagesreturn/text(),"^(.+?),")/node()
                return
                    if ($segment1 instance of element(fn:match)) then 
                        <tei:author>{$segment1/fn:group[@nr='1']/text()}</tei:author>
                    else 
                        $segment1/string()
                        

let $authorreturn := element tei:bibl {($bibl/@xml:id, $author, $pages)}

return $authorreturn :)