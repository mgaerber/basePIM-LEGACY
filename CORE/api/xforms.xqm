xquery version "3.0";

module namespace xforms = "http://basex.org/basePIM/xforms";
declare namespace rest = "http://exquery.org/ns/restxq";

import module namespace tmpl = "http://basepim.org/tmpl" at "../services/xforms-template.xqm";
import module namespace nodes = "http://basepim.org/nodes" at "../services/node-service.xqm";
declare namespace xf = "http://www.w3.org/2002/xforms";

(:~
 : Edit a given Slot referenced by its ID
 : 
:)
declare
  %rest:path("/xforms/edit-slot/{$workspace}/{$uuid}")
  %rest:produces("application/xml")
function xforms:edit-slot($workspace as xs:string, $uuid as xs:string) as node()+ {
     let $slot  := nodes:get-slot-by-id($workspace, $uuid)
     let $prop  := $slot/ancestor::property
     let $binds :=
      switch(string($prop/@name))
        case "bezeichnung" return tmpl:bezeichnung-bind($uuid)
        case "dimensions" return tmpl:dimensions-bind($uuid)
        case "gewicht"    return tmpl:gewicht-bind($uuid)
        default return ()
     let $form  := 
      switch($prop/@name)
        case "bezeichnung"	return tmpl:edit-bezeichnung($uuid)
        case "dimensions" 	return tmpl:edit-dimensions($uuid)
        case "gewicht"    	return tmpl:edit-gewicht($uuid)
        default 						return tmpl:edit-generic($uuid, $slot)
    return tmpl:body($slot, $binds, $form)
};

declare
  %rest:path("/xforms/dump")
  %rest:POST("{$body}")
  %output:method("text")
function xforms:dump($body){
  <pre>{serialize($body)}</pre>
};

(:~
 : Returns a FilterBuilder based on given data
 : 
:)
declare
  %rest:path("/xforms/filterbuilder/{$workspace}")
	%rest:produces("application/xml")
function xforms:filterbuilder($workspace as xs:string) as node()+ {
	tmpl:filterbuilder($workspace)
};
