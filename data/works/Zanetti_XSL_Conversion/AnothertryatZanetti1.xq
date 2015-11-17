xquery version "3.1";

(: Tested in BaseX :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $uri := "https://raw.githubusercontent.com/srophe/draft-data/e898b33a24e175b48931609d64d86a58d3a93f79/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull.xml"
for $bibl in fn:doc($uri)//tei:bibl
let $analyzed-pages := $bibl/text() => fn:analyze-string("[,]*\s*[p]\.\s*(\w*[-]*w*.*)$")
let $pages := element tei:citedRange {$analyzed-pages//fn:group[@nr="1"]/text()}
let $analyzed-date1 := $bibl/text() => fn:analyze-string(",\s(\d{4})")
let $date1 := element tei:date {$analyzed-date1//fn:group[@nr="1"]/text()}
let $analyzed-date2 := $bibl/text() => fn:analyze-string("\s\(\d{4}-*d*\)")
let $date2 := element tei:date {$analyzed-date2//fn:group[@nr="1"]/text()}
let $analyzed-author := $bibl/text() => fn:analyze-string("^(.+?),")
let $author := element tei:author {$analyzed-author//fn:group[@nr="1"]/text()}
let $non-matched := $analyzed-pages/fn:non-match/text()
return element tei:bibl {($bibl/@xml:id, $non-matched, " ", $author, $date1, $date2, $pages)}