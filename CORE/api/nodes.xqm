module namespace api = "http://basepim.org/ws";
declare namespace rest = "http://exquery.org/ns/restxq";
import module namespace nodes = "http://basepim.org/nodes" at "../services/node-service.xqm";
import module namespace util = "http://basepim.org/util" at "../util/util.xqm";

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

declare
%rest:GET
%rest:path("/ws/{$type}/node/n/{$name}")
%rest:produces("application/xml")
function api:get-node-by-name($type as xs:string, $name as xs:string){
   nodes:get-product-by-name($type, $name)
};

(:
: TODO: serialization doesn't work if elements (e.g. slot) can have both: text content or element children
:)
declare
%rest:GET
%rest:path("/ws/{$type}/nodej/n/{$name}")
%rest:produces("application/json")
%output:method("json")
function api:get-nodej-by-name($type as xs:string, $name as xs:string){
   let $node := nodes:get-product-by-name($type, $name)
    return
     <json objects="json node attributes property value" arrays="">
       { util:attr-to-elem($node, 'attributes') }
     </json>
};



declare
%rest:GET
%rest:path("/ws/{$type}/node-meta/n/{$name}")
%rest:produces("application/xml")
function api:get-node-by-name-meta($type as xs:string, $name as xs:string){
   let $node := nodes:get-product-meta-by-name($type, $name)
   return $node
};


declare
%rest:GET
%rest:path("/ws/{$type}/nodej-meta/n/{$name}")
%rest:produces("application/json")
%output:method("json")
function api:get-nodej-by-name-meta($type as xs:string, $name as xs:string){
   let $node := nodes:get-product-meta-by-name($type, $name)
    return
     <json objects="json node" arrays="children">
         { util:attr-to-elem($node, '')/* }
     </json>
};



(:
 : Receive name from input form.
 :)
declare    
	%rest:POST
	%rest:path("/hello/receive-name")
	%rest:form-param("name", "{$name}")
	%output:method("html5")
function api:result($name) {
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
