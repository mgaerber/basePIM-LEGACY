module namespace _ = "http://basepim.org/services/workspace"; 

(:~
 : Lists all <em>available</em> workspaces.
 : Per convention workspace databases follow the naming scheme <code>ws_xxx</code>
 :
 : @return Nodes
 :)
declare function _:list()
{
   <workspaces>{
   for $db in db:list()[starts-with(.,"ws_")]
    return <workspace> { doc($db)//workspace/@* } </workspace>
   }</workspaces>
};

(:
*TODO* are these needed?
 declare function _:get($uuid){
	1
};

declare function _:get-n($name){
	1
}; :)
