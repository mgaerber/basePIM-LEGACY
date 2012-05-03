module namespace api = "http://basepim.org/ws";
declare namespace rest = "http://exquery.org/ns/restxq";
import module namespace ws = "http://basepim.org/ws" at "../services/workspace-service.xqm";
import module namespace jsonutil = "http://basepim.org/jsonutil" at "../util/jsonutil.xqm";
(:~ 
: This resource returns a list of all available workspaces.
: Each workspace contains a hierarchy of nodes, with properties.
: @return a list of available workspaces in XML.
:)
declare
%rest:GET
%rest:path("/ws.xml")
%rest:produces("application/xml")
function api:list-workspaces-x(){
       ws:list() 
};

(:~ 
: This resource returns a list of all available workspaces.
: Each workspace contains a hierarchy of nodes, with properties.
: @return a list of available workspaces in JSON.
:)
declare
	%rest:GET
	%rest:path("/ws.json")
	%rest:produces("application/json")
	%output:method("json")
function api:list-workspaces(){
    let $ws := ws:list()
     return 
     <json objects="json workspace attributes" arrays="workspaces"> 
     <workspaces>{
        for $w in $ws/workspace
            return jsonutil:attr-to-elem($w, "attributes")
     }</workspaces></json>

};
