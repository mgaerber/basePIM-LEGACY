module namespace _ = "http://basepim.org/ws";

import module namespace properties = "http://basepim.org/services/properties";

(:~ 
: This resource returns a list of all available properties.
: A property is a compound of schema defined XML Types, 
: such as dimensions, weights or prices.
: A property has per language slots.
: @return a list of available workspaces in XML.
:)
declare
  %restxq:GET
  %restxq:path("/ws/{$type}/n/{$id}/slots.xml")
  %restxq:produces("application/xml")
  function _:get-slots(
    $type as xs:string,
    $id as xs:string)
{
  properties:get-slots($type, $id)
};

(:~ 
: This resource returns a list of all available properties.
: A property is a compound of schema defined XML Types, 
: such as dimensions, weights or prices.
: A property has per language slots.
: @return a list of available workspaces in XML.
:)
declare
  %restxq:GET
  %restxq:path("/ws/{$type}/n/{$id}/slots.json")
  %restxq:produces("application/json")
  %output:method("json")
  function _:get-slots-j(
    $type as xs:string,
    $id as xs:string)
{
  let $node := properties:get-slots($type, $id)
  return
   <json objects="json property" arrays="node">
       { $node }
   </json>
};
