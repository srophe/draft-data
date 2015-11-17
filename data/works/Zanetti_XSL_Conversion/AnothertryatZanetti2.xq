xquery version "3.1";

(: Tested in BaseX :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $uri := "https://raw.githubusercontent.com/srophe/draft-data/e898b33a24e175b48931609d64d86a58d3a93f79/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull.xml"
for $bibl in fn:doc($uri)//tei:bibl
let $analyzed := fn:replace($bibl/text(),"[,]*\s*[p]\.\s*(\w*[-]*w*.*)$", "$1")
return element tei:bibl {($bibl/@xml:id, $analyzed)}