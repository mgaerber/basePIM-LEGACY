(:~ 
: This module provides the functions that control the Web presentation
: of search forms
:
: @author Christian Grün
: @author Maximilian Gärber
: @author Alexander Holupirek
: @author Michael Seiferle
: @version 0.8
:)
module namespace _ = "http://basepim.org/services/search";

import module namespace parse = "http://basepim.org/search/parse";
import module namespace retrieve = "http://basepim.org/search/retrieve";
import module namespace render = "http://basepim.org/search/render";
import module namespace properties = "http://basepim.org/services/properties";

(:~ 
: This resource returns a single node.
: @param $type the name of the workspace
: @param $uuid the UUID of the node to return
: @return a node
:)
declare function _:search(
  $type as xs:string,
  $search as xs:string)
{
	_:s($search, $type, "50", 0)
};

(:~
 : Returns a HTML representation of the requested hits.
 : @param $q query keywords
 : @param $s index of first hit
 : @param $h number of hits to be returned
 : @param $f fuzzy flag
 :)
declare function _:s(
  $q as xs:string*,
  $d as xs:string,
  $h as xs:string,
  $f as xs:integer)
  as element()*
{
  let $search := parse:parse($q, $d, $h, $f)
  let $results := retrieve:retrieve($search)
  return 
    if($results) then (
      render:render($results, $search)
    ) else (
    )
};
