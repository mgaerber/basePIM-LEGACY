module namespace _ = "http://basepim.org/ws";

import module namespace ws = "http://basepim.org/services/workspace";
import module namespace json = "http://basepim.org/util/json";

(:~ 
: This resource returns a list of all available workspaces.
: Each workspace contains a hierarchy of nodes, with properties.
: @return a list of available workspaces in XML.
:)
declare
  %restxq:GET
  %restxq:path("/ws.xml")
  %restxq:produces("application/xml")
  function _:list-workspaces-x()
{
	ws:list() 
};

(:~ 
: This resource returns a list of all available workspaces.
: Each workspace contains a hierarchy of nodes, with properties.
: @return a list of available workspaces in JSON.
:)
declare
	%restxq:GET
	%restxq:path("/ws.json")
	%restxq:produces("application/json")
	%output:method("json")
  function _:list-workspaces()
{
  let $ws := ws:list()
  return 
   <json objects="json workspace attributes" arrays="workspaces"> 
   <workspaces>{
      for $w in $ws/workspace
          return json:attr-to-elem($w, "attributes")
   }</workspaces></json>
};
