module namespace api = "http://basepim.org/ws";
declare namespace rest = "http://exquery.org/ns/restxq";
import module namespace nodes = "http://basepim.org/nodes" at "../services/node-service.xqm";
import module namespace properties = "http://basepim.org/properties" at "../services/property-service.xqm";
import module namespace util = "http://basepim.org/util" at "../util/util.xqm";


(:
: Get 
:)
declare
%rest:GET
%rest:path("/ws/{$type}/n/{$id}/slots.xml")
%rest:produces("application/xml")
function api:get-slots($type as xs:string, $id as xs:string){
   let $node := properties:get-slots($type, $id)
   return $node
};


(:

:)
declare
%rest:GET
%rest:path("/ws/{$type}/n/{$id}/slots.json")
%rest:produces("application/json")
%output:method("json")
function api:get-slots-j($type as xs:string, $id as xs:string){
  let $node := properties:get-slots($type, $id)
    return
     <json objects="json property" arrays="node">
         { $node }
     </json>
};
