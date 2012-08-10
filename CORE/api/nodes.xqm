(:~ 
: This module provides the functions that control the Web presentation
: of 
:
: @author Maximilian Gärber
: @author Christian Grün
: @author Alexander Holupirek
: @author Michael Seiferle
: @version 0.8
:)
module namespace api = "http://basepim.org/ws";

import module namespace nodes = "http://basepim.org/nodes" at "../services/node-service.xqm";
import module namespace jsonutil = "http://basepim.org/jsonutil" at "../util/jsonutil.xqm";

(:~ 
: This resource returns a single node.
: @param $type the name of the workspace
: @param $uuid the UUID of the node to return
: @return a node
:)
declare
%restxq:GET
%restxq:path("/ws/{$type}/node/{$uuid}")
%restxq:produces("application/xml")
%restxq:query-param("filter", "{$filter}", '')
%restxq:query-param("stringify", "{$str}", '')
%restxq:query-param("inherit", "{$inh}", '')
%restxq:query-param("expand", "{$exp}", '')
function api:get-node-stringify($type as xs:string,
                                $uuid as xs:string,
                                $filter as xs:string,
                                $str as xs:string,
                                $inh as xs:string,
                                $exp as xs:string){
  let $filters  := tokenize($filter, ","),
    $inherit    := fn:boolean($inh),
    $expand      := fn:boolean($exp),
    $stringify  := fn:boolean($str),
    $nodes      := nodes:get($type, $uuid)
  return
  nodes:filter(              (: remove unwanted properties :)
      nodes:expand(          (: get properties from aside :)
        nodes:inherit(      (: get properties from above :)
          nodes:stringify(  (: make properties string only :)
            $nodes, $stringify),
          $inherit),
        $expand),
      $filters)
};

declare 
%restxq:GET
%restxq:path("/ws/{$type}/search/{$search}")
%output:method("json")
%restxq:query-param("filter", "{$filter}", '')
%restxq:query-param("stringify", "{$str}", '')
%restxq:query-param("inherit", "{$inh}", '')
%restxq:query-param("expand", "{$exp}", '')

function api:search($type as xs:string, $search as xs:string,
  $filter as xs:string,
  $str as xs:string,
  $inh as xs:string,
  $exp as xs:string){
  <json objects="property attributes slot value" arrays="json node">
  {
    let $filters  := tokenize($filter, ","),
      $inherit    := fn:boolean($inh),
      $expand      := fn:boolean($exp),
      $stringify  := fn:boolean($str),
      $nodes      := nodes:search($type, $search)
    return
    jsonutil:jsonatts(
    nodes:stringify(
      nodes:filter(           (: remove unwanted properties :)
        nodes:expand(         (: get properties from aside :)
          nodes:inherit(      (: get properties from above :)
                              (: make properties string only :)
              $nodes,$inherit),
          $expand),
        $filters),
     $stringify),
      "attributes")
    }</json>

  (: <results>{nodes:stringify(, fn:true())}</results> :)
};
(:~ 
: This resource returns a single node with all inherited attributes inlined
: @param $uuid the UUID of the node to return
: @return a flat node
:)
declare 
%restxq:GET
%restxq:path("/ws/flat/{$uuid}")
%restxq:produces("application/xml")
function api:flat($uuid as xs:string){
  let $prod := nodes:get("ws_produkte", $uuid),
    $map := nodes:flatten-product($prod)
  return
  (
  nodes:from-map($map)
  )
};

(:~ 
: This resource returns a single node by name.
: @param $type the name of the workspace
: @param $name the name of the node to return
: @return a node
:)

declare
%restxq:GET
%restxq:path("/ws/{$type}/node/n/{$name}")
%restxq:produces("application/xml")
function api:get-node-by-name($type as xs:string, $name as xs:string){
   nodes:get-product-by-name($type, $name)
};

(:
: TODO: serialization doesn't work if elements (e.g. slot) can have both: text content or element children
:)
(:~ 
: This resource returns a single node by name.
: @param $type the name of the workspace
: @param $name the name of the node to return
: @return a node in JSON
:)
declare
%restxq:GET
%restxq:path("/ws/{$type}/nodej/n/{$name}")
%restxq:produces("application/json")
%output:method("json")
function api:get-nodej-by-name($type as xs:string, $name as xs:string){
   let $node := nodes:get-product-by-name($type, $name)
    return
     <json objects="json node attributes property value" arrays="">
       { jsonutil:attr-to-elem($node, 'attributes') }
     </json>
};

(:~ 
: This resource returns node metadata by name.
: @param $type the name of the workspace
: @param $name the name of the node to return
: @return a node with metadata
:)
declare
%restxq:GET
%restxq:path("/ws/{$type}/node-meta/n/{$name}")
%restxq:produces("application/xml")
function api:get-node-by-name-meta($type as xs:string, $name as xs:string){
   let $node := nodes:get-product-meta-by-name($type, $name)
   return $node
};

(:~ 
: This resource returns node metadata by name.
: @param $type the name of the workspace
: @param $name the name of the node to return
: @return a node with metadata serialized as JSON
:)
declare
%restxq:GET
%restxq:path("/ws/{$type}/nodej-meta/n/{$name}")
%restxq:produces("application/json")
%output:method("json")
function api:get-nodej-by-name-meta($type as xs:string, $name as xs:string){
   let $node := nodes:get-product-meta-by-name($type, $name)
    return
     <json objects="json node" arrays="children">
         { jsonutil:attr-to-elem($node, '')/* }
     </json>
};
