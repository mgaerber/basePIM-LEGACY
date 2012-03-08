module namespace nodes = "http://basepim.org/nodes";
declare namespace rest = "http://exquery.org/ns/rest/annotation/";

(:~
  This function says hello to everyone visiting /say/hello/<NAME>
  @param $w the name to say <strong>hello to</strong>
  @author Michael Seiferle
~:)
declare
%rest:path("/say/hello/{$w}")
  function nodes:hello-world($w as xs:string){
    <strong>Hello { $w }</strong>
  };