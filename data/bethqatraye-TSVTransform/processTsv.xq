xquery version "3.1";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare option output:omit-xml-declaration "no";
declare option file:omit-xml-declaration "no";

(: ----------------------------------------- :)
(: function declarations :)
(: ----------------------------------------- :)

(: function from http://www.xqueryfunctions.com/xq/functx_trim.html :)
declare function local:trim
  ( $arg as xs:string? )  as xs:string {

   replace(replace($arg,'\s+$',''),'^\s+','')
 } ;
 
(: function from http://www.xqueryfunctions.com/xq/functx_distinct-deep.html :)
declare function local:distinct-deep
  ( $nodes as node()* )  as node()* {

    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(local:is-node-in-sequence-deep-equal(
                          .,$nodes[position() < $seq]))]
 } ;

(: function from http://www.xqueryfunctions.com/xq/functx_is-node-in-sequence-deep-equal.html :)
declare function local:is-node-in-sequence-deep-equal
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {

   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
 } ;

declare function local:loadCsvInternet($uri as xs:string, $delimiter as xs:string, $header as xs:boolean) as element()*
{
(: See https://github.com/HeardLibrary/digital-scholarship/tree/master/code/file for more on this function. :)

let $csvDoc := http:send-request(<http:request method='get' href='{$uri}'/>)[2] (: ignore initial response element :)
let $xmlDoc := csv:parse($csvDoc, map { 'header' : $header,'separator' : $delimiter })

return $xmlDoc/csv/record
};

declare function local:createNamesIndex($headerMap)
{
for $nameColumn in $headerMap
let $columnString := $nameColumn/string/string()
let $leftOfDot := tokenize($columnString,'\.')[1]
let $langCode := tokenize($columnString,'\.')[2]
return if ((string-length($leftOfDot) = 5 or string-length($leftOfDot) = 6) and substring(tokenize($columnString,'\.')[1],1,4) = 'name') then
  <name>{
    <langCode>{$langCode}</langCode>,
    <labelColumnElementName>{$nameColumn/name/string()}</labelColumnElementName>,
    
    for $uriColumn in $headerMap   (: find the element name of the sourceURI column :)
    return if ($uriColumn/string/string() = 'sourceURI.'||$leftOfDot)
           then <sourceUriElementName>{$uriColumn/name/string()}</sourceUriElementName>
           else (),
    for $pagesColumn in $headerMap   (: find the element name of the sourceURI column :)
    return if ($pagesColumn/string/string() = 'pages.'||$leftOfDot)
           then <pagesElementName>{$pagesColumn/name/string()}</pagesElementName>
           else ()
  }</name>
else 
 ()
};

declare function local:createHeadwordIndex($headerMap)
{
for $nameColumn in $headerMap
let $columnString := $nameColumn/string/string()
let $leftOfDot := tokenize($columnString,'\.')[1]
let $langCode := tokenize($columnString,'\.')[2]
return if (substring(tokenize($columnString,'\.')[1],1,12) = 'nameHeadword') then
  <headword>{
    <langCode>{$langCode}</langCode>,
    <labelColumnElementName>{$nameColumn/name/string()}</labelColumnElementName>,
    for $uriColumn in $headerMap   (: find the element name of the sourceURI column :)
    return if ($uriColumn/string/string() = 'sourceURI.'||$leftOfDot||'.'||$langCode)
           then <sourceUriElementName>{$uriColumn/name/string()}</sourceUriElementName>
           else (),
    for $pagesColumn in $headerMap   (: find the element name of the sourceURI column :)
    return if ($pagesColumn/string/string() = 'pages.'||$leftOfDot||'.'||$langCode)
           then <pagesElementName>{$pagesColumn/name/string()}</pagesElementName>
           else ()
  }</headword>
else 
 ()
};

declare function local:createAbstractIndex($headerMap) (:This is where we would need to change if altering our columns to call them 'desc's. We would likely want to rename functions and variables if that is the case. :)
{
for $nameColumn in $headerMap
let $columnString := $nameColumn/string/string()
let $leftOfDot := tokenize($columnString,'\.')[1]
let $langCode := tokenize($columnString,'\.')[2]
return if (substring(tokenize($columnString,'\.')[1],1,8) = 'abstract') then
  <abstract>{
    <langCode>{$langCode}</langCode>,
    <labelColumnElementName>{$nameColumn/name/string()}</labelColumnElementName>,

    for $uriColumn in $headerMap   (: find the element name of the sourceURI column :)
    return if ($uriColumn/string/string() = 'sourceURI.'||$leftOfDot||'.'||$langCode)
           then <sourceUriElementName>{$uriColumn/name/string()}</sourceUriElementName>
           else (),
    for $pagesColumn in $headerMap   (: find the element name of the sourceURI column :)
    return if ($pagesColumn/string/string() = 'pages.'||$leftOfDot||'.'||$langCode)
           then <pagesElementName>{$pagesColumn/name/string()}</pagesElementName>
           else ()
  }</abstract>
else 
 ()
};

declare function local:createDescIndex($headerMap)
{
for $nameColumn in $headerMap
let $columnString := $nameColumn/string/string()
let $leftOfDot := tokenize($columnString,'\.')[1]
let $langCode := tokenize($columnString,'\.')[2]
return if (substring(tokenize($columnString,'\.')[1],1,4) = 'desc') then
  <desc>{
    <langCode>{$langCode}</langCode>,
    <labelColumnElementName>{$nameColumn/name/string()}</labelColumnElementName>,

    for $uriColumn in $headerMap   (: find the element name of the sourceURI column :)
    return if ($uriColumn/string/string() = 'sourceURI.'||$leftOfDot||'.'||$langCode)
           then <sourceUriElementName>{$uriColumn/name/string()}</sourceUriElementName>
           else (),
    for $pagesColumn in $headerMap   (: find the element name of the sourceURI column :)
    return if ($pagesColumn/string/string() = 'pages.'||$leftOfDot||'.'||$langCode)
           then <pagesElementName>{$pagesColumn/name/string()}</pagesElementName>
           else ()
  }</desc>
else 
 ()
};

(: ----------------------------------------- :)
(: Start of script :)
(: ----------------------------------------- :)

(: This part of the script loads the data from GitHub and creates a mapping between the column header strings and the elements in the data XML:)

(: NOTE: line 236 controls whether a single record is output or if all records are output.  Uncomment it to test with a single record :)

let $localConfigDirectoryUrl := 'https://raw.githubusercontent.com/wlpotter/draft-data/master/data/bethqatraye-TSVTransform/' (: ultimately, this is probably the only line in the code that the user will have to modify before running the program. :)

let $projectConfigDirectoryUrl := 'https://raw.githubusercontent.com/wlpotter/draft-data/master/data/bethqatraye-TSVTransform/'
let $localConfig := doc($localConfigDirectoryUrl||'configLocal.xml')
let $projectConfig := doc($projectConfigDirectoryUrl||'configProject.xml')
let $url := $localConfig/configuration/inputFileUrl/text()  (: URL of TSV file to be processed :)
let $delimiter := $projectConfig/configuration/delimiter/text() (: delimiter character from config file :)
let $baseLanguage := $projectConfig/configuration/baseLanguage/text()  (: base language tag, e.g. "en" :)
let $fileOrConsole := $localConfig/configuration/outputTo/text()  (: value is 'file' to output to file(s) in $path and 'console' to output to the console :)
let $path := $localConfig/configuration/localPath/text()  (: path to save files; on Mac this seems to default to subdirectories of the home directory.   Specifying '~' isn't recognaized :)

(: This is no longer being included in the output:

let $listBibl := 
<listBibl xmlns="http://www.tei-c.org/ns/1.0">
    <bibl>
        <ptr target="#bib75-2"/>
    </bibl>
    <bibl>
        <ptr target="#bib75-3"/>
    </bibl>
    <bibl>
        <ptr target="#bib75-4"/>
    </bibl>
</listBibl>
:)

let $columnHeaders := local:loadCsvInternet($url,$delimiter,false())[1]/entry/text() (: load the TSV without headers, then pull text from 1st (header) row :)

(: Each row from the TSV table is read in as a record element like this.  $data is a sequence of these record elements.

<record>
  <New_place_add_data>new place</New_place_add_data>
  <uri>75</uri>
  <Possible_URI/>
  <nameHeadword.en>Doliche</nameHeadword.en>
  <nameHeadword.syr>ܕܠܘܟ</nameHeadword.syr>
...
</record>

Note that the element names differ from the column headers in that spaces, slashes, etc. may be replaced with underscores.  
:)
let $data := local:loadCsvInternet($url,$delimiter,true()) (: load the TSV with headers.  Headers are used as tag names subject to cleanup to make valid XML element names :)

let $columnElementNames := $data[1]/*/name()

(:
$headerMap is a sequence that looks like this.  It relates the strings used in the TSV column headers to the XML tag names in the data

<map>
  <string>New place/add data</string>
  <name>New_place_add_data</name>
</map>
<map>
  <string>uri</string>
  <name>uri</name>
</map>
<map>
  <string>Possible URI</string>
  <name>Possible_URI</name>
</map>
...

:)
let $headerMap := 
                  for $x at $pos in $columnHeaders
                  return (<map>{<string>{$x}</string>,<name>{$columnElementNames[$pos]}</name>}</map>)

(:
$namesIndex is a sequence looks like this:

<name>
  <langCode>en</langCode>
  <labelColumnElementName>name2.en</labelColumnElementName>
  <sourceUriElementName>sourceURI.name2</sourceUriElementName>
  <pagesElementName>pages.name2</pagesElementName>
</name>
<name>
  <langCode>syr</langCode>
  <labelColumnElementName>name3.syr</labelColumnElementName>
  <sourceUriElementName>sourceURI.name3</sourceUriElementName>
  <pagesElementName>pages.name3</pagesElementName>
</name>

:)
let $namesIndex := local:createNamesIndex($headerMap) (: find and process the names columns :)

(:
$headwordIndex is a sequence looks like this:

<headword>
  <langCode>en</langCode>
  <labelColumnElementName>nameHeadword.en</labelColumnElementName>
</headword>
<headword>
  <langCode>syr</langCode>
  <labelColumnElementName>nameHeadword.syr</labelColumnElementName>
</headword>

:)
let $headwordIndex := local:createHeadwordIndex($headerMap) (: find and process the headwords columns :)

(:
$abstractIndex is a sequence looks like this:

<abstract>
  <langCode>en</langCode>
  <labelColumnElementName>abstract.en</labelColumnElementName>
  <sourceUriElementName>sourceURI.abstract.en</sourceUriElementName>
  <pagesElementName>pages.abstract.en</pagesElementName>
</abstract>

In the current system, there is only one English abstract, but this allows for a different language or multiple abstracts in different languages
:)
let $abstractIndex := local:createAbstractIndex($headerMap) (: find and process the abstracts columns :)
(:
$descIndex is a sequence looks like this:

<desc>
  <langCode>en</langCode>
  <labelColumnElementName>desc.en</labelColumnElementName>
  <sourceUriElementName>sourceURI.desc.en</sourceUriElementName>
  <pagesElementName>pages.desc.en</pagesElementName>
</desc>

There should be only one true abstract, but this allows for a different language or multiple abstracts in different languages which are encoded as <desc> elements
:)
let $descIndex := local:createDescIndex($headerMap) (: find and process the descriptions columns :)
(: ----------------------------------------- :)
(: set up the loop that generates an output document for each row in the TSV file :)

for $document at $row in $data
(: where $row = 6  outputs a single row instead of all of them. Uncomment this line for testing :)
(: ----------------------------------------- :)
(: This part of the script builds the TEI header element from inner parts outward :)

(: Find every possible reference in the row and add it to a sequence. This is needed to build the respStmt list. :)
let $redundantSources :=
    for $source in $headerMap  (: loop through each item in the header map sequence :)
      let $sourceUriColumnName := $source/name/text()  (: get the XML element name :)
      let $sourceUri := local:trim($document/*[name() = $sourceUriColumnName]/text())  (: find the value for that column :)
      where substring($source/string/text(),1,9) = 'sourceURI' and $sourceUri != '' (: screen for right header string and skip over empty elements :)
      let $lastPartColString := substring($source/string/text(),10)  (: find the last part of the sourceUri column header label :)
      let $sourcePgColumnString := 'pages'||$lastPartColString  (: construct the column label for the page source :)
      let $sourcePgColumnName :=
          for $sourcePage in $headerMap    (: find the column string that matches the constructed on :)
          where $sourcePgColumnString = $sourcePage/string/text()
          return $sourcePage/name/text()     (: return the XML tag name for the matching column string :)
      let $sourcePage := local:trim($document/*[name() = $sourcePgColumnName]/text())
      return (<source><uri>{$sourceUri}</uri>,<pg>{$sourcePage}</pg></source>)

(: remove redundant sources.  :)
let $sources := local:distinct-deep($redundantSources)

(: Generate a list of just the URIs:)
let $sourceUris := 
    for $src in $sources
    let $uri := $src/*:uri/text()
    return <uri>{$uri}</uri>

(: remove redundant URIs from URI list :)
let $uniqueSourceUris := local:distinct-deep($sourceUris)
        
let $date := current-date()
let $uriLocalName := local:trim($document/uri/text())
let $fileName := local:trim($document/fileName/text())

let $availability :=
  <availability xmlns="http://www.tei-c.org/ns/1.0">
      <licence target="http://creativecommons.org/licenses/by/3.0/">
          <p>Distributed under a Creative Commons Attribution 3.0 Unported License.</p>
      </licence>
  </availability>

let $pubStatement :=
  <publicationStmt xmlns="http://www.tei-c.org/ns/1.0">
      <authority>{$localConfig/*:configuration/*:publicationInfo/*:authority/text()}</authority>
      <idno type="URI">{$localConfig/*:configuration/*:publicationInfo/*:idno/text()}{$uriLocalName}/tei</idno>
      {$availability}
      <date>{$date}</date>
  </publicationStmt>

let $title :=
    for $baseLanguageHeadword in $headwordIndex
    where $baseLanguageHeadword/langCode/text() = $baseLanguage
    let $bltag := $baseLanguageHeadword/langCode/text()
    let $blabel := local:trim($document/*[name() = $baseLanguageHeadword/labelColumnElementName/text()]/text())
    return 
         <title xmlns="http://www.tei-c.org/ns/1.0" level="a" xml:lang="{$bltag}">{$blabel}
          {
          let $foreignHeadwordElements :=
                    for $foreignHeadword in $headwordIndex
                    where $foreignHeadword/*:langCode/text() != $baseLanguage
                    let $fltag := $foreignHeadword/*:langCode/text()
                    let $flabel := local:trim($document/*[name() = $foreignHeadword/*:labelColumnElementName/text()]/text())
                    return if ($flabel != '')
                    then
                        <foreign xml:lang="{$fltag}">{$flabel}</foreign>
                    else ()
          return if (count($foreignHeadwordElements) != 0)
          then (
              " - ",
              $foreignHeadwordElements
            )
          else ()
        }</title>

let $monoTitle := 
    if($localConfig/*:configuration/*:monographTitle/*:titleString/text() != '') then
        <title xmlns="http://www.tei-c.org/ns/1.0" level="m" xml:lang="{$localConfig/*:configuration/*:monographTitle/*:titleLang/text()}">{$localConfig/*:configuration/*:monographTitle/*:titleString/text()}</title>
    else ()
    
let $sponsorList :=
    for $sponsor in $localConfig/*:configuration/*:sponsorList/*:sponsor/text()
    return if ($sponsor != '')
    then 
        <sponsor xmlns="http://www.tei-c.org/ns/1.0">{$sponsor}</sponsor>
    else ()
    
let $funderList :=
    for $funder in $localConfig/*:configuration/*:funderList/*:funder/text()
    return if ($funder != '')
    then
        <funder xmlns="http://www.tei-c.org/ns/1.0">{$funder}</funder>
    else ()

let $editorList :=
    for $editor in $localConfig/*:configuration/*:editorList/*:editor
    let $editorString := $editor/*:editorString/text()
    let $editorUri := $editor/*:editorUri/text()
    let $editorRole := $editor/*:editorRole/text()
    return if($editor != '')
    then 
        <editor xmlns="http://www.tei-c.org/ns/1.0" role="{$editorRole}" ref="{$editorUri}">{$editorString}</editor>
    else ()

let $additionalEditorList := 
    for $srcUri in $uniqueSourceUris
        let $includedEditors := 
            for $addCredit in $localConfig/*:configuration/*:additionalCredits/*:sourceSpecificCredits
            where $addCredit/*:sourceUri/text() = $srcUri/text()
            return <editor xmlns="http://www.tei-c.org/ns/1.0" role="{$addCredit/*:editor/*:editorRole/text()}" ref="{$addCredit/*:editor/*:editorUri/text()}">{$addCredit/*:editor/*:editorString/text()}</editor>
        return $includedEditors

let $compiledRespStmts := 
    for $srcUri in $uniqueSourceUris
        let $includedRespStmts := 
            for $addCredit in $localConfig/*:configuration/*:additionalCredits/*:sourceSpecificCredits
            where $addCredit/*:sourceUri/text() = $srcUri/text()
            return $addCredit/*:respStmtList/*:respStmt
        return $includedRespStmts

let $respStmtList :=
    for $respStmt in $compiledRespStmts
        let $respString := $respStmt/*:respString/text()
        let $nameString := $respStmt/*:nameString/text()
        let $nameUri := $respStmt/*:nameUri/text()
        return if ($respString != '')
        then 
            <respStmt xmlns="http://www.tei-c.org/ns/1.0"><resp>{$respString}</resp><name ref="{$nameUri}">{$nameString}</name></respStmt>
        else ()

let $titleStatement := 
  <titleStmt xmlns="http://www.tei-c.org/ns/1.0">{
      $title,
      $monoTitle,
      $sponsorList,
      $funderList,
      <principal>{$localConfig/*:configuration/*:principal/text()}</principal>,
      $editorList,
      local:distinct-deep($additionalEditorList),
      $respStmtList,
      <respStmt>
          <resp>Data merging and XML by</resp>
          <name ref="{$localConfig/*:configuration/*:mintedUri/text()}">{$localConfig/*:configuration/*:mintedString/text()}</name>
      </respStmt>
  }</titleStmt>

let $seriesStmt :=
    if($localConfig/*:configuration/*:seriesInfo != '') then <seriesStmt xmlns="http://www.tei-c.org/ns/1.0">
        <title level="s" xml:lang="{$localConfig/*:configuration/*:seriesInfo/*:titleLangCode/text()}">{$localConfig/*:configuration/*:seriesInfo/*:titleString/text()}</title>
        {
        for $editor in $localConfig/*:configuration/*:seriesInfo/*:editor
            return if ($editor != '') then <editor role="{$editor/*:editorRole/text()}" ref="{$editor/*:editorUri/text()}">{$editor/*:editorString/text()}</editor>
            else ()
        }
        {
            if ($localConfig/*:configuration/*:seriesInfo/*:idnoString/text() != '')
            then 
                <idno type="{$localConfig/*:configuration/*:seriesInfo/*:idnoType/text()}">{$localConfig/*:configuration/*:seriesInfo/*:idnoString/text()}</idno>
            else ()
        }
    </seriesStmt>
    else()
    
let $fileDesc := 
  <fileDesc xmlns="http://www.tei-c.org/ns/1.0">{
      $titleStatement,
      <editionStmt>
          <edition n="1.0"/>
      </editionStmt>,
      $pubStatement,
      $seriesStmt,
      <sourceDesc>
          <p>Born digital.</p>
      </sourceDesc>
  }</fileDesc>
  
let $header :=
    <teiHeader xmlns="http://www.tei-c.org/ns/1.0">{
      $fileDesc,
      <encodingDesc>
          <editorialDecl>
              <p>This record created following the guidelines for TEI encoding established by Syriaca.org. Documentation available at: <ref target="http://syriaca.org/documentation">http://syriaca.org/documentation</ref>.</p>
              <p>The <gi>state</gi> element of @type="existence" indicates the period for which this place was in use as a place of its indicated type (e.g. an inhabited settlement, a functioning monastery or church, an administrative province).  Natural features always in existence have no <gi>state</gi> element of @type="existence".</p>
          </editorialDecl>
          <classDecl>
              <taxonomy>
                  <category xml:id="srophe-headword">
                      <catDesc>The name used by the Srophé App for document titles, citation, and disambiguation. These names have been created according to the Syriac.org guidelines for headwords: <ref target="http://syriaca.org/documentation/headwords.html">http://syriaca.org/documentation/headwords.html</ref>.</catDesc>
                  </category>
              </taxonomy>
          </classDecl>
      </encodingDesc>,
      <profileDesc>
          <langUsage>
              <p>Language codes used in this record follow the Syriaca.org guidelines. Documentation available at: 
                  <ref target="http://syriaca.org/documentation/langusage.xml">http://syriaca.org/documentation/langusage.xml</ref></p>
          </langUsage>
      </profileDesc>,
      <revisionDesc status="draft">
          <change who="{$localConfig/*:configuration/*:mintedUri/text()}" when="{$date}">CREATED: place</change>
      </revisionDesc>

  }</teiHeader>       

(: ----------------------------------------- :)
(: This part of the script builds the text element from inner parts outward :)


(: build the bibl elements. The source list has already been created above for use with the respStmts :)
let $bibl :=
    for $source at $number in $sources
    return
    if (fn:lower-case($source/*:pg/text())='')
    then <bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="bib{$uriLocalName}-{$number}">
        <ptr target="{$source/*:uri/text()}"/>
        </bibl>
    else
    <bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="bib{$uriLocalName}-{$number}">
        <ptr target="{$source/*:uri/text()}"/>
        <citedRange unit="pp">{$source/*:pg/text()}</citedRange>
    </bibl>

let $idnos := 
    for $idno in $document/idno
    where local:trim($idno/text()) != ''
    return
      <idno xmlns="http://www.tei-c.org/ns/1.0" type="URI">{local:trim($idno/text())}</idno>

(: For this row, find only the headword columns that have values. Need to do this since the schema requires placeName ids to have consecutive nubmers and therefore there can't be missing names :)
let $lineHeadwordIndex :=
    for $headword in $headwordIndex
    let $element := local:trim($document/*[name() = $headword/labelColumnElementName/string()]/text())
    return if ($element != '')
            then $headword
            else ()

(: create the placeName elements for the headwords :)
let $headwordNames :=
    for $headword at $number in $lineHeadwordIndex
    let $text := local:trim($document/*[name() = $headword/labelColumnElementName/text()]/text()) (: look up the headword for that language :)
    where $text != '' (: skip the headword columns that are empty :)
    let $langAttrib := local:trim($headword/langCode/text())
    let $headwordUri := local:trim($document/*[name() = $headword/sourceUriElementName/text()]/text())
    let $headwordPg := local:trim($document/*[name() = $headword/pagesElementName/text()]/text())
    let $sourceFragId := 
        for $src at $srcNumber in $sources  (: step through the source index :)
        where  $headwordUri = $src/uri/text() and ($headwordPg = $src/pg/text() or $headwordPg = '') (: URI from columns must match with iterated item in the source index. This same process is used in getting names, abstracts, and descriptions. Perhaps turn into a function :)
        return $uriLocalName||'-'||$srcNumber    (: create the last part of the source attribute :)
    return if($headwordUri != '') then <placeName xmlns="http://www.tei-c.org/ns/1.0" xml:id="{'name'||$uriLocalName}-{$number}" xml:lang="{$langAttrib}" syriaca-tags="#syriaca-headword" source="#bib{$sourceFragId}">{$text}</placeName>
    else <placeName xmlns="http://www.tei-c.org/ns/1.0" xml:id="{'name'||$uriLocalName}-{$number}" xml:lang="{$langAttrib}" syriaca-tags="#syriaca-headword" resp="http://bqgazetteer.bethmardutho.org">{$text}</placeName>

(: for this row, find only the names columns that have values.  This avoids skipping numbers in placeName ids :)
let $lineNamesIndex :=
    for $name in $namesIndex
    let $element := local:trim($document/*[name() = $name/labelColumnElementName/string()]/text())
    return if ($element != '')
            then $name
            else ()

(: create the placeName elements for the names in different languages :)
let $numberHeadwords := count($headwordNames)  (: need to add this to the name index to generate last number at end of id attribute :)
let $names :=
    for $name at $number in $lineNamesIndex     (: loop through each of the names in various languages :)
    let $text := local:trim($document/*[name() = $name/labelColumnElementName/text()]/text()) (: look up the name for that column :)
    let $nameUri := local:trim($document/*[name() = $name/sourceUriElementName/text()]/text())  (: look up the URI that goes with the name column :)
    let $namePg := local:trim($document/*[name() = $name/pagesElementName/text()]/text())  (: look up the page that goes with the name column :)
    let $sourceFragId := 
        for $src at $srcNumber in $sources  (: step through the source index :)
        where  $nameUri = $src/uri/text() and ($namePg = $src/pg/text() or $namePg = '')  (: URI and page from columns must match with iterated item in the source index FIX to just require URI lookup? :)
        return $uriLocalName||'-'||$srcNumber    (: create the last part of the source attribute :)
    let $langAttrib := local:trim($name/langCode/text())
    return if($nameUri != '') then <placeName xmlns="http://www.tei-c.org/ns/1.0" xml:id="name{$uriLocalName}-{$number + $numberHeadwords}" xml:lang="{$langAttrib}" source="#bib{$sourceFragId}">{$text}</placeName>
    else <placeName xmlns="http://www.tei-c.org/ns/1.0" xml:id="name{$uriLocalName}-{$number + $numberHeadwords}" xml:lang="{$langAttrib}">{$text}</placeName>

(: create the abstract elements.  In the current table model there are only Engilsh ones, but this will still work if abstracts are added in other languages :)
let $abstracts :=
    for $abstract at $number in $abstractIndex
    let $text := local:trim($document/*[name() = $abstract/labelColumnElementName/text()]/text()) (: look up the abstract from that column :)
    where $text != ''   (: skip the abstract columns that are empty :)
    let $abstractUri := local:trim($document/*[name() = $abstract/sourceUriElementName/text()]/text())  (: look up the URI that goes with the abstract column :)
    let $abstractPg := local:trim($document/*[name() = $abstract/pagesElementName/text()]/text())  (: look up the page that goes with the name column :)
    let $sourceAttribute := 
        if ($abstractUri != '')
        then
            for $src at $srcNumber in $sources  (: step through the source index :)
            where  $abstractUri = $src/uri/text() and ($abstractPg = $src/pg/text() or $abstractPg = '') (: URI and page from columns must match with iterated item in the source index :)
            return '#bib'||$uriLocalName||'-'||$srcNumber    (: create the last part of the source attribute :)
        else ()
    return
        if ($abstractUri = '')
        then <desc xmlns = "http://www.tei-c.org/ns/1.0" type ="abstract" xml:id="{ 'abstract'||$uriLocalName||'-'||$number }" xml:lang="{ $abstract/*:langCode/text() }">{$text}</desc>
        else <desc xmlns = "http://www.tei-c.org/ns/1.0" type="abstract" xml:id="{ 'abstract'||$uriLocalName||'-'||$number }" xml:lang="{ $abstract/*:langCode/text() }" ><quote source="{$sourceAttribute}">{$text}</quote></desc>

(: create the description elements.  In the current table model there are only Engilsh ones, but this will still work if abstracts are added in other languages :)
let $descriptions :=
    for $desc at $number in $descIndex
    let $text := local:trim($document/*[name() = $desc/labelColumnElementName/text()]/text()) (: look up the description from that column :)
    where $text != ''   (: skip the description columns that are empty :)
    let $descUri := local:trim($document/*[name() = $desc/sourceUriElementName/text()]/text())  (: look up the URI that goes with the description column :)
    let $descPg := local:trim($document/*[name() = $desc/pagesElementName/text()]/text())  (: look up the page that goes with the name column :)
    let $sourceAttribute := 
        if ($descUri != '')
        then
            for $src at $srcNumber in $sources  (: step through the source index :)
            where  $descUri = $src/uri/text() and ($descPg = $src/pg/text() or $descPg = '')  (: URI and page from columns must match with iterated item in the source index; allows for there to be a URI but no page number :)
            return '#bib'||$uriLocalName||'-'||$srcNumber    (: create the last part of the source attribute :)
        else ()
    return
        if ($descUri = '')
        then <desc xmlns = "http://www.tei-c.org/ns/1.0" xml:lang="{ $desc/*:langCode/text() }">{$text}</desc>
        else <desc xmlns = "http://www.tei-c.org/ns/1.0" xml:lang="{ $desc/*:langCode/text() }"><quote source="{$sourceAttribute}">{$text}</quote></desc>
        
(: create the disambiguation element. It's a bit unclear whether there can be multiple values or multiple languages, or if source is required. :)
let $disambiguation := 
    for $dis in $headerMap 
    let $text := local:trim($document/*[name() = $dis/name/text()]/text()) (: look up the text in that column :)
    where $dis/string/text() = 'note.disambiguation' and $text != '' (: screen for correct column and skip over empty elements :)
    let $disUri := local:trim($document/*[name() = 'sourceURI.note.disambiguation']/text())  (: this is a hack that just pulls the text from the sourcURI column.  Use the lookup method if it gets more complicated :)
    let $disPg := local:trim($document/*[name() = 'pages.note.disambiguation']/text())  (: this is a hack that just pulls the text from the pages column.  Use the lookup method if it gets more complicated :)
    let $sourceAttribute := 
        if ($disUri != '')
        then
            for $src at $srcNumber in $sources  (: step through the source index :)
            where  $disUri = $src/uri/text() and $disPg = $src/pg/text()  (: URI and page from columns must match with iterated item in the source index :)
            return '#bib'||$uriLocalName||'-'||$srcNumber    (: create the last part of the source attribute :)
        else ()
    return  (: this is also a hack and can't handle disambiguations in other languages :)
        if ($disUri = '')
        then <note xmlns = "http://www.tei-c.org/ns/1.0" type="disabmiguation" xml:lang="en">{$text}</note>
        else <note xmlns = "http://www.tei-c.org/ns/1.0" type="disabmiguation" xml:lang="en" source="{$sourceAttribute}">{$text}</note>

(: create the incerta element. All the same issues with the disambituation element are here.  This is basically a cut and paste of disambiguation :)
let $incerta := 
    for $inc in $headerMap 
    let $text := local:trim($document/*[name() = $inc/name/text()]/text()) (: look up the text in that column :)
    where $inc/string/text() = 'note.incerta' and $text != '' (: screen for correct column and skip over empty elements :)
    let $incUri := local:trim($document/*[name() = 'sourceURI.note.incerta']/text())  (: this is a hack that just pulls the text from the sourcURI column.  Use the lookup method if it gets more complicated :)
    let $incPg := local:trim($document/*[name() = 'pages.note.incerta']/text())  (: this is a hack that just pulls the text from the pages column.  Use the lookup method if it gets more complicated :)
    let $sourceAttribute := 
        if ($incUri != '')
        then
            for $src at $srcNumber in $sources  (: step through the source index :)
            where  $incUri = $src/uri/text() and $incPg = $src/pg/text()  (: URI and page from columns must match with iterated item in the source index :)
            return '#bib'||$uriLocalName||'-'||$srcNumber    (: create the last part of the source attribute :)
        else ''
    return  (: this is also a hack and can't handle disambiguations in other languages :)
        if ($incUri = '')
        then <note xmlns = "http://www.tei-c.org/ns/1.0" type="incerta" xml:lang="en">{$text}</note>
        else <note xmlns = "http://www.tei-c.org/ns/1.0" type="incerta" xml:lang="en" source="{$sourceAttribute}">{$text}</note>

(: ----------------------------------------- :)
(: create nested location element. Since this is a very ideosyncratic element, I'm not going to attempt to generalize it, but rather just hard code the column headers :)

(: here's the settlement child element and it's associated source attribute :)
let $settlementElement := 
    let $setName := local:trim($document/*[name() = 'nestedName.settlement']/text())  (: this is a hack that just pulls the text from the sourcURI column.  Use the lookup method if it gets more complicated :)
    return
        if ($setName != '')
        then
            let $setUri := local:trim($document/*[name() = 'nestedURI.settlement']/text())
            return <settlement xmlns="http://www.tei-c.org/ns/1.0" ref="{$setUri}">{$setName}</settlement>
        else()
let $settlementSourceAttribute :=
    let $setSrc := local:trim($document/*[name() = 'sourceURI.nested.settlement']/text())    
    let $setPg := local:trim($document/*[name() = 'pages.nested.settlement']/text())
    return
        if ($setSrc != '')
        then
            for $src at $srcNumber in $sources  (: step through the source index :)
            where  $setSrc = $src/uri/text() and $setPg = $src/pg/text()  (: URI and page from columns must match with iterated item in the source index :)
            return '#bib'||$uriLocalName||'-'||$srcNumber    (: create the last part of the source attribute :)
        else ''

(: here's the region child element and it's associated source attribute :)
let $regionElement :=
    let $regName := local:trim($document/*[name() = 'nestedName.region']/text())  (: this is a hack that just pulls the text from the sourcURI column.  Use the lookup method if it gets more complicated :)
    return
        if ($regName != '')
        then
            let $regUri := local:trim($document/*[name() = 'nestedURI.region']/text())
            return <region xmlns="http://www.tei-c.org/ns/1.0" ref="{$regUri}">{$regName}</region>
        else()
let $regionSourceAttribute :=
    let $regSrc := local:trim($document/*[name() = 'sourceURI.nested.region']/text())    
    let $regPg := local:trim($document/*[name() = 'pages.nested.region']/text())
    return
        if ($regSrc != '')
        then
            for $src at $srcNumber in $sources  (: step through the source index :)
            where  $regSrc = $src/uri/text() and $regPg = $src/pg/text()  (: URI and page from columns must match with iterated item in the source index :)
            return '#bib'||$uriLocalName||'-'||$srcNumber    (: create the last part of the source attribute :)
        else ''

(: now we need to build the source attribute from one or more of the sources representing the child elements :)

let $separator :=   (: the separator needs to be the empty string if only one of the child elements has a source.  If they both do, the separator needs to be a single space :)
    if ($settlementSourceAttribute != '' and $regionSourceAttribute != '')
    then ' '
    else ''
let $locationAttribute := $settlementSourceAttribute||$separator||$regionSourceAttribute

(: we have all the pieces to build the nested location element now.  If the $locationAttribute isn't an empty string, there is a ref for one or the other nested type, so use that as the test :)

let $location :=
    if ($locationAttribute != '')
    then 
        <location xmlns="http://www.tei-c.org/ns/1.0" type="nested" source="{$locationAttribute}">{
            $settlementElement,
            $regionElement
      }</location>
    else ()

(: ----------------------------------------- :)
(: we now have all of the bits necessary to build the entire place element (which is the only element in listPlace, which is the only element in the body element, which is the only element in the text element :)

let $text := 
<text xmlns="http://www.tei-c.org/ns/1.0">
  <body>
     <listPlace>
        <place type="{local:trim($document/*[name() = 'placeType']/text())}">{
            $headwordNames,
            $names,
            $abstracts,
            $descriptions,
            $incerta,
            $disambiguation,
            $location,
            <idno type="URI">http://bqgazetteer.bethmardutho.org/place/{$uriLocalName}</idno>,
            <idno type="URI">http://syriaca.org/place/{$uriLocalName}</idno>,
            $idnos,
            $bibl
        }</place>
     </listPlace>
  </body>
</text>

(: ----------------------------------------- :)
(: build the entire document now :)

let $document:= (
<?xml-model href="https://raw.githubusercontent.com/srophe/draft-data/master/data/schemaPlaceDraftData/out/syriacaPlacesTEI.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>,
<?xml-model href="https://raw.githubusercontent.com/srophe/draft-data/master/data/schemaPlaceDraftData/out/syriacaPlacesTEI.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>,
<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">{
    $header,
    $text
}</TEI>
)

(: If output is to be written to files, hard-code the file location as $path :)
let $nothing := file:create-dir($path)    (: creates the directory if it doesn't already exist, does nothing if it exists :)

return
  if ($fileOrConsole = 'file')
  (:Change $uriLocalName to $fileName when running script on potential duplicates :)
  then file:write($path||$uriLocalName||'.xml',  $document, map { 'omit-xml-declaration': 'no'})
  else $document