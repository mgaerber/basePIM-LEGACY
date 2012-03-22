module namespace api = "http://basepim.org/ws";
declare namespace rest = "http://exquery.org/ns/restxq";
import module namespace ws = "http://basepim.org/ws" at "../services/workspace-service.xqm";

declare
	%rest:GET
	%rest:path("/ws")
	%rest:produces("application/xml")
function api:list-workspaces-x(){
       ws:list() 
};

declare
	%rest:GET
	%rest:path("/ws")
	%rest:produces("application/json")
	%output:method("json")
function api:list-workspaces(){
    (: let $ws := <json objects="json workspaces" arrays="workspace">{ws:list()}</json>
     let $ws-js := json:serialize($ws) :)
    (: arrays="workspace" :)
    let $ws := ws:list()
     return 
     <json objects="json workspaces" arrays="workspace"> 
     <workspaces>{
        for $w in $ws/workspace
            return
            <workspace>{
            for $a in $w/@*
                return
                    element {name($a)} {data($a)}
            }</workspace>
     }</workspaces></json>
        (:
     return
        '{ "workspaces": [' ||
        string-join((for $w in $ws/workspace
            return '{ "name": "' || $w/@name || '" }'), ',')
         || '] }'
         :)
};
