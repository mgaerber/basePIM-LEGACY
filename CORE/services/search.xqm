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
module namespace search = "http://basepim.org/search";
import module namespace nodes = "http://basepim.org/nodes" at "../services/node-service.xqm";
import module namespace parse =
  "http://basex.org/modules/parse" at "../services/search/parse.xqm";
import module namespace retrieve =
  "http://basex.org/modules/retrieve" at "../services/search/retrieve.xqm";
import module namespace render =
  "http://basex.org/modules/render" at "../services/search/render.xqm";
import module namespace properties = "http://basepim.org/properties" at "../services/property-service.xqm";
import module namespace jsonutil = "http://basepim.org/jsonutil" at "../util/jsonutil.xqm";

declare namespace rest = "http://exquery.org/ns/restxq";

(:~ 
: This resource returns a single node.
: @param $type the name of the workspace
: @param $uuid the UUID of the node to return
: @return a node
:)
declare
function search:search($type as xs:string, $search as xs:string){
	search:s($search, $type, "10", 0)
};

(:~
 : Returns a HTML representation of the requested hits.
 : @param $q query keywords
 : @param $s index of first hit
 : @param $h number of hits to be returned
 : @param $f fuzzy flag
 :)
declare
  %rest:GET
  %rest:path("/klett/s")
  %rest:form-param("q", "{$q}")
  %rest:form-param("d", "{$d}")
  %rest:form-param("h", "{$h}")
  %rest:form-param("f", "{$f}", 0)
  %output:method("xhtml")
  function search:s(
    $q as xs:string*,
    $d as xs:string,
    $h as xs:string,
    $f as xs:integer) as element()* {

  let $search := parse:parse($q, $d, $h, $f)
  let $results := retrieve:retrieve($search)
  return 
    if($results) then (
      render:render($results, $search)
    ) else (
    )
};
