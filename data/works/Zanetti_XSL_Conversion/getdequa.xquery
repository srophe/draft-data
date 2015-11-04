xquery version "3.0";
For $bibl in fn:collection(/Users/bethanymichelson/Desktop/Repositories/Srophe/draft-data/data/works/tei)/TEI/text/body/bibl/bibl[not(ptr)]

Let $textnode:= $bibl/text()
Let $attribute:=$bibl@*[namespace-uri()='http://www.w3.org/XML/1998/namespace' and local-name()='id']

Return $attribute