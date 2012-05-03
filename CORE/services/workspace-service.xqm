module namespace ws = "http://basepim.org/ws";

(:~
 : Lists all <em>available</em> workspaces.
 : Per convention workspace databases follow the naming scheme <code>ws_xxx</code>
 :
 : @return Nodes
 :)
declare function ws:list() {
       <workspaces>{
       for $db in db:list()[starts-with(.,"ws_")]
        return <workspace> { doc($db)//workspace/@* } </workspace>
       }</workspaces>
};

(:
*TODO* are these needed?
 declare function ws:get($uuid){
	1
};

declare function ws:get-n($name){
	1
}; :)
