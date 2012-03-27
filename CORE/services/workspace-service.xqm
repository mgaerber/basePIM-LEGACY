module namespace ws = "http://basepim.org/ws";

(:~
 : Lists all available workspaces.
 :
 : Per convention workspace databases follow the naming scheme "ws_xxx".
 :
 : @return Nodes
 :)
declare function ws:list() {
       <workspaces>{
       for $db in db:list()[starts-with(.,"ws_")]
        return <workspace> { doc($db)//workspace/@* } </workspace>
       }</workspaces>
};

declare function ws:get($uuid){
	1
};

declare function ws:get-n($name){
	1
};
