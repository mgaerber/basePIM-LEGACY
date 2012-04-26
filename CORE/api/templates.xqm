xquery version "3.0";

module namespace api = "http://basepim.org/ws";
declare namespace rest = "http://exquery.org/ns/restxq";
import module namespace tpl = "http://basepim.org/tpl" at "../services/template-service.xqm";
import module namespace nodes = "http://basepim.org/nodes" at "../services/node-service.xqm";

(:~
 : Transforms a node with given template 
 :)
declare
%rest:GET
%rest:path("/tpl/{$type}/{$name}")
%output:method("html")
function api:execute-tpl($type, $name) {
    let $node := nodes:get-product-by-name('ws_produkte', 'Powermotor')
    let $tpl := concat('TPL/', $type, '/', $name)
    return
    (:<file>{
        file:resolve-path($tpl)
        }
    </file>:)
    <div>
    <p>{$xslt:processor} </p>
    <p>{$xslt:version} </p>
    {
     tpl:transform-xsl($node, $tpl)
     }
     </div>
};
