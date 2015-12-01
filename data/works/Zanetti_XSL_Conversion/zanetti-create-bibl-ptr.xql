xquery version "3.0";
(: 
 : Add/replace new bibl elements with ptr elements to newly created bibl TEI records 
 : Save changes to db, must be logged into eXist as admin/with admin privileges
 : :)

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace syriaca = "http://syriaca.org";
declare namespace functx = "http://www.functx.com";

(: Find matching biblStruct. Match bibl id against @corresp list. Match ids with optional 'a' or 'b' at the end as well :)
declare function syriaca:create-new-bibl($id, $node) {
    for $bibl in $node//tei:biblStruct[matches(@corresp, concat('(^|\W)',$id,'[a-z]?(\W|$)'))]
    let $bibl-id := analyze-string($bibl/@corresp, concat('(^|\W)',$id,'[a-z]?(\W|$)'))/fn:match/text()
    let $new-bibl := 
            <bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$bibl-id}">
                {(  
                    $bibl/descendant::tei:title,
                    <ptr target="{$bibl//tei:idno/text()}"/>,
                    $bibl/tei:citedRange[@corresp = $bibl-id]
                )}
            </bibl>
    return $new-bibl
};

(: Copy of latest xml data to be converted. This is my local path :)
let $uri := "/db/apps/srophe-forms/data/zanetti.xml"
(: This is the file on github :)
(:  :"https://raw.githubusercontent.com/srophe/draft-data/blob/master/data/works/Zanetti_XSL_Conversion/ZanettiBiblConverted.xml":)
let $tei := doc($uri)//tei:TEI
(: Run on all works :)
for $work in collection('/db/apps/srophe-data/data/works/tei')//tei:body
let $id := $work/descendant::tei:idno
return 
    for $bibl in $work/child::tei:bibl/tei:bibl
    let $id := $bibl/@xml:id
    return
        if(syriaca:create-new-bibl($id, $tei) != '') then 
            (: Insert new bibl elements, and delete old bibl (can not use replace with multiple elements to be inserted). :)
            (update insert syriaca:create-new-bibl($id, $tei) following $bibl, update delete $bibl)
        else ()