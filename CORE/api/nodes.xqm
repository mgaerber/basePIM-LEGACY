module namespace api = "http://basepim.org/ws";
declare namespace rest = "http://exquery.org/ns/restxq";
import module namespace nodes = "http://basepim.org/nodes" at "../services/node-service.xqm";

(:~
  This function says hello to everyone visiting /say/hello/<NAME>
  @param $w the name to say <strong>hello to</strong>
  @author Michael Seiferle
~:)
declare
%rest:GET
%rest:path("/say/hello/{$w}")
  function api:hello-world($w as xs:string){
    <strong>Hello { $w }</strong>
  };
  
declare
%rest:GET
%rest:path("/ws/{$type}/node/{$uuid}")
%rest:produces("application/xml")
function api:get-node($type as xs:string, $uuid as xs:string){
   nodes:get-product($type, $uuid)
};


(:
 : Receive name from input form.
 :)
declare    
	%rest:POST
	%rest:path("/hello/receive-name")
	%rest:form-param("name", "{$name}")
	%output:method("html5")
function nodes:result($name) {
	<html>
	<head>
		<title>Howdy ...</title>
        </head>
        <body>
            <p>Howdy, {
		if ($name eq "") then "lazy bro" else $name
		}!
	    </p>
        </body>
    </html>
};
