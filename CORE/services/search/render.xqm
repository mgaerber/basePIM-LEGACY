module namespace M = "http://basex.org/modules/render";

import module namespace parse =
  "http://basex.org/modules/parse" at "parse.xqm";

(:~
 : Renders a result view for the specified results.
 : @param $results returned results
 : @param $terms query terms
 : @param $fuzzy fuzzy flag
 : @param $hits number of results
 :)
declare function M:render(
    $results as element()*,
    $search as map(*)) as element()* {

	for $node in $results 
	where count($node/*[name(.)!="node"]) > 1
	return element {name($node)}
		{
		$node/@*
		,
		for $n in $node/*
		where name($n) != ("node")
		return $n
		
		}
};

(:~
 : Returns a text node in which all keywords have been highlighted.
 : @param $terms query terms
 : @param fuzzy fuzzy flag
 : @param $text text to mark
 :)
declare function M:mark(
    $text as item(),
    $search as map(*)) {

  let $fuzzy as xs:boolean := $search($parse:FUZZY)
  let $terms as xs:string* := $search($parse:INCLUDED)
  let $mark := 'emph'
  let $text := copy $c := text { $text } modify () return $c
  let $mark := if($fuzzy) then
    ft:mark($text[. contains text { $terms } using fuzzy], $mark) else
    ft:mark($text[. contains text { $terms }], $mark)
  return if($mark) then $mark else $text
};
