xquery version "3.0";

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace syriaca = 'http://syriaca.org';

declare function syriaca:remove-element-by-pos
($context as element()*, $pos-of-element as xs:integer*) as element()* {
if (count($pos-of-element)>0) then
for $parent-element in $context
(: the recursion messes up the numbering, since once an element is removed the other's are no longer in the same position :)
let $new-element := element {name($parent-element)} {$parent-element/@*, $parent-element/*[position()<$pos-of-element[1]],$parent-element/*[position()>$pos-of-element[1]]}
return syriaca:remove-element-by-pos($new-element,remove($pos-of-element,1))
else $context
};

let $doc := doc('ZanettiBiblConverted.xml')
let $x :=  syriaca:remove-element-by-pos($doc//biblStruct, (1,2))
return $x