xquery version "3.0";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";
declare function functx:sort
  ( $seq as item()* )  as item()* {

   for $item in $seq
   order by $item
   return $item
 } ;

functx:sort(
  distinct-values(
    (for $node in doc("/Users/davidmichelson/GitHub Repositories/srophe/draft-data/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull.xml")//tei:bibl/text()

return fn:replace($node
, "[,]*\s*[p]\.(\s)*\w*[-]*\w*.*$", ""))))

(: regex for dates
,\s\d{4}-*(\d{2,4})*
\s\(\d{4}-*d*\)
for pages
[,]\s*[p]\.(\s)*\d*[-]\d*
:)