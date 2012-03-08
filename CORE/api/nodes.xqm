module namespace nodes = "http://basepim.org/nodes";
declare namespace rest = "http://exquery.org/ns/rest/annotation/";


declare
%rest:path("/say/hello/{$w}")
function nodes:hello-world($w as xs:string){
	<strong>Hello { $w }</strong>
};