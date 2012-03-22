module namespace api = "http://basepim.org/ws";
declare namespace rest = "http://exquery.org/ns/restxq";
import module namespace ws = "http://basepim.org/ws" at "../services/workspace-service.xqm";
import module namespace util = "http://basepim.org/util" at "../util/util.xqm";

(: [XQST0108] No output declarations allowed in modules.
declare option output:media-type "application/json";
:)

declare
%rest:GET
%rest:path("/ws-x")
%rest:produces("application/xml")
function api:list-workspaces-x(){
       ws:list() 
};

declare
%rest:GET
%rest:path("/ws")
%rest:produces("application/json")
(: %output:media-type("application/json") :)
%output:method("json")
function api:list-workspaces(){
    let $ws := ws:list()
     return 
     <json objects="json workspace attributes" arrays="workspaces"> 
     <workspaces>{
        for $w in $ws/workspace
            return util:attr-to-elem($w)
     }</workspaces></json>

};

(: %rest:produces("application/atom+xml") :)
(: %rest:consumes("text/xml", “application/xml") :)
(: %output:method("xhtml") :)
