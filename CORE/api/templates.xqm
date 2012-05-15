xquery version "3.0";

module namespace api = "http://basepim.org/ws";
declare namespace rest = "http://exquery.org/ns/restxq";
import module namespace tpl = "http://basepim.org/tpl" at "../services/template-service.xqm";
import module namespace nodes = "http://basepim.org/nodes" at "../services/node-service.xqm";

(:~
: Transforms a node with given template 
: @param $type defines the type of template (xsl, xquery, tal)
: @param $name defines the name of the template (file name)
: @param $uuid defines the unique id of a node
:)
declare
%rest:GET
%rest:path("/tpl/{$type}/{$name}/ws/{$ws}/node/{$uuid}")
%output:method("html")
function api:execute-tpl($type, $name, $ws, $uuid) {
    let $node := nodes:get($ws, $uuid)
    let $tpl := concat('TPL/', $type, '/', $name)
    return  tpl:transform-xsl($node, $tpl)
   (: <div>
    <p>{$xslt:processor} </p>
    <p>{$xslt:version} </p>
    {
     tpl:transform-xsl($node, $tpl)
     }
     </div>
     :)
};
