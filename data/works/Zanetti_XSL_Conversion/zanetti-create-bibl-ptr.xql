xquery version "3.0";

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace syriaca = "http://syriaca.org";
declare namespace functx = "http://www.functx.com";

(: Build TEI record for Syriaca.org data app :)
declare function syriaca:build-tei($node as element()*) as node(){
    <TEI xmlns="http://www.tei-c.org/ns/1.0">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                   {
                       for $titles in $node//tei:title
                       return $titles
                   }
                    <sponsor>Syriaca.org: The Syriac Reference Portal</sponsor>
                    <funder>The National Endowment for the Humanities</funder>
                    <funder>The International Balzan Prize Foundation</funder>
                    <principal>David A. Michelson</principal>
                    <editor role="general" ref="http://syriaca.org/editors.xml#tcarlson">Thomas A. Carlson</editor>
                    <editor role="general" ref="http://syriaca.org/editors.xml#dmichelson">David A. Michelson</editor>
                    <respStmt>
                        <resp>XML coded by</resp>
                        <name ref="http://syriaca.org/editors.xml#wsalesky">Winona Salesky</name>
                    </respStmt>
                </titleStmt>
                <publicationStmt>
                    <authority>Syriaca.org: The Syriac Reference Portal</authority>
                    <idno type="URI">{$node//tei:idno/text()}</idno>
                    <availability>
                        <licence target="http://creativecommons.org/licenses/by/3.0/">
                            <p>Distributed under a Creative Commons Attribution 3.0 Unported License.</p>
                        </licence>
                    </availability>
                    <date>{current-date()}</date>
                </publicationStmt>
                <sourceDesc>
                    <p>Born digital.</p>
                </sourceDesc>
            </fileDesc>
            <revisionDesc>
                <change who="http://syriaca.org/editors.xml#wsalesky" when="{current-date()}">CREATED: bibl</change>
            </revisionDesc>
        </teiHeader>
        <text>
            <body>
                <biblStruct>
                    {$node/child::*}
                </biblStruct>
            </body>
        </text>
            
    </TEI>

};

(: Need to handle cases where bibl has been split, see: bibl551-3a rec: works/tei/551.xml :)
declare function syriaca:add-ptr($node){
    let $id := $node//tei:idno
    for $corresp in tokenize($node/@corresp,' ')
    return
        for $rec in collection('/db/apps/srophe-data/data')//@xml:id[. = $corresp]
        let $current-bibl := $rec/parent::*
        let $pages := analyze-string($current-bibl,"[,]*\s*[p]\.\s*(\w*[-]*w*.*)$")//fn:group[@nr=1]/text()
        let $new-bibl := 
            <bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$corresp}">
                {(
                    $node//tei:title,
                    <ptr target="{$id}"/>,
                    $node//tei:citedRange[. = $pages]
                )}
            </bibl>
        return 
            (: do xquery update here :)
            ($rec/parent::*,$new-bibl)
};

(: Create and save new TEI records to filesystem or database :)
declare function syriaca:create-new-bibl($node) {
    for $bibl in $node//tei:biblStruct    
    return 
        (: save record to db and/or file system :)    
        (syriaca:add-ptr($bibl), syriaca:build-tei($bibl))
};


let $uri := "/db/apps/srophe-forms/data/zanetti.xml"
(:  :"https://raw.githubusercontent.com/srophe/draft-data/blob/master/data/works/Zanetti_XSL_Conversion/ZanettiBiblConverted.xml":)
(:"ZanettiBiblFull-normalized-spaces-and-vertical-tabs.xml":)
let $tei := doc($uri)//tei:TEI
return syriaca:create-new-bibl($tei)