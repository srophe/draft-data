xquery version "3.1";

(: Tested in BaseX :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $uri := ""

for $bibl in fn:doc($uri)//tei:bibl


let $pages := 
                for $segment in analyze-string($bibl/text(),"[,]*\s*[p]\.\s*(\w*[-]*w*.*)$")/node()
                return
                    if ($segment instance of element(fn:match)) then 
                        <tei:citedRange>{$segment/fn:group[@nr='1']/text()}</tei:citedRange>
                    else 
                        <tei:p>{$segment/string()}</tei:p>
                        

let $pagesreturn := element tei:bibl {($bibl/@xml:id, $pages)}

let $author := 
                for $segment1 in analyze-string($pagesreturn/tei:p/text(),"^(.+?),\s*")/node()
                return
                    if ($segment1 instance of element(fn:match)) then 
                        <tei:author>{$segment1/fn:group[@nr='1']/text()}</tei:author>
                    else 
                         <tei:p>{$segment1/string()}</tei:p>
                        

let $authorreturn := element tei:bibl {($bibl/@xml:id, $author, $pagesreturn//tei:citedRange)}

let $bookdate := 
                for $segment2 in analyze-string($authorreturn/tei:p/text(),",\s(\d{4})")/node()
                return
                    if ($segment2 instance of element(fn:match)) then 
                        <tei:date>{$segment2/fn:group[@nr='1']/text()}</tei:date>
                    else 
                         <tei:p>{$segment2/string()}</tei:p>
                        

let $bookdatereturn := element tei:bibl {($bibl/@xml:id, $authorreturn//tei:author, $bookdate, $pagesreturn//tei:citedRange)}

return $bookdatereturn

(: up to this point my query works but from here on there are multiple tei:p sections of the data and the query runs into an error where it expects an item and gets a sequence, telling it to chose the first instance can fix that but then one loses the other instance:)

(: let $articledate := 
                for $segment3 in analyze-string($bookdatereturn/tei:p[1]/text(),"\((\d{4})\)$")/node()
                return
                    if ($segment3 instance of element(fn:match)) then 
                        <tei:date>{$segment3/fn:group[@nr='1']/text()}</tei:date>
                    else 
                         <tei:p>{$segment3/string()}</tei:p>
                        

let $articeldatereturn := element tei:bibl {($bibl/@xml:id, $authorreturn//tei:author, $articledate, $bookdatereturn//tei:date, $pagesreturn//tei:citedRange)}
:)
