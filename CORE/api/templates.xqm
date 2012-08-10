module namespace _ = "http://basepim.org/ws";

import module namespace tpl = "http://basepim.org/services/template";
import module namespace nodes = "http://basepim.org/services/nodes";

(:~
: Transforms a node with given template 
: @param $type defines the type of template (xsl, xquery, tal)
: @param $name defines the name of the template (file name)
: @param $uuid defines the unique id of a node
:)
declare
  %restxq:GET
  %restxq:path("/tpl/{$type}/{$name}/ws/{$ws}/node/{$uuid}")
  %output:method("html")
  function _:execute-tpl(
    $type,
    $name,
    $ws,
    $uuid)
{
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
