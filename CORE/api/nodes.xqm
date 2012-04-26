module namespace api = "http://basepim.org/ws";
import module namespace nodes = "http://basepim.org/nodes" at "../services/node-service.xqm";
import module namespace jsonutil = "http://basepim.org/jsonutil" at "../util/jsonutil.xqm";

declare namespace rest = "http://exquery.org/ns/restxq";


declare
%rest:GET
%rest:path("/ws/{$type}/node/{$uuid}")
%rest:produces("application/xml")
function api:get-node($type as xs:string, $uuid as xs:string){
   nodes:get-product($type, $uuid)
};

declare 
%rest:GET
%rest:path("/ws/flat/{$uuid}")
%rest:produces("application/xml")
function api:flat($uuid as xs:string){
	let $prod := nodes:get-product("ws_produkte", $uuid),
		$map := nodes:flatten-product($prod)
	return
	(
	nodes:from-map($map)
	)
};

declare
%rest:GET
%rest:path("/ws/{$type}/node/n/{$name}")
%rest:produces("application/xml")
function api:get-node-by-name($type as xs:string, $name as xs:string){
   nodes:get-product-by-name($type, $name)
};

(:
: TODO: serialization doesn't work if elements (e.g. slot) can have both: text content or element children
:)
declare
%rest:GET
%rest:path("/ws/{$type}/nodej/n/{$name}")
%rest:produces("application/json")
%output:method("json")
function api:get-nodej-by-name($type as xs:string, $name as xs:string){
   let $node := nodes:get-product-by-name($type, $name)
    return
     <json objects="json node attributes property value" arrays="">
       { jsonutil:attr-to-elem($node, 'attributes') }
     </json>
};

declare
%rest:GET
%rest:path("/ws/{$type}/node-meta/n/{$name}")
%rest:produces("application/xml")
function api:get-node-by-name-meta($type as xs:string, $name as xs:string){
   let $node := nodes:get-product-meta-by-name($type, $name)
   return $node
};

declare
%rest:GET
%rest:path("/ws/{$type}/nodej-meta/n/{$name}")
%rest:produces("application/json")
%output:method("json")
function api:get-nodej-by-name-meta($type as xs:string, $name as xs:string){
   let $node := nodes:get-product-meta-by-name($type, $name)
    return
     <json objects="json node" arrays="children">
         { jsonutil:attr-to-elem($node, '')/* }
     </json>
};
