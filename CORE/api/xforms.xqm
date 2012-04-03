xquery version "3.0";

module namespace xforms = "http://basex.org/basePIM/xforms";
declare namespace rest = "http://exquery.org/ns/restxq";

import module namespace tmpl = "http://basepim.org/tmpl" at "../util/xforms-template.xqm";
import module namespace nodes = "http://basepim.org/nodes" at "../services/node-service.xqm";

(:~
 : Edit a given Property
 :)
declare
  %rest:path("/xforms/edit/{$workspace}/{$node}/{$property}")
  %output:method("xhtml")
function xforms:edit($workspace as xs:string,
    $node as xs:string,
    $property as xs:string) as element() {
    
    let $link := <span><a href="/restxq/xforms/edit/{$workspace}">{$workspace}</a>
      / <a href="/restxq/xforms/edit/{$workspace}/{$node}">{$node}</a>
      / <a href="/restxq/xforms/edit/{$workspace}/{$node}/{$property}">{$property}</a></span>
    return
  <html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms">
     <head>
        <title>Hello World in XForms</title>
        <xf:model>
           <xf:instance xmlns="">
              <data>
              {
                nodes:get-property-for($workspace, $node, $property)
              }
              </data>
           </xf:instance>
          <xf:submission action="/restxq/xforms/dump" id="dump" method="post" />
          {
            switch($property)
            case "dimensions" return tmpl:dimensions-bind()
            default return ()
            
          }
        </xf:model>
     </head>
     <body>
      <h1>Edit {$link}</h1>
      <br />
      {
        switch($property)
        case "bezeichnung" return tmpl:bezeichnung()
        case "dimensions" return tmpl:dimensions()
        default return ()
      }
      <br />
      <hr />
      <xf:submit submission="dump">
        <xf:label>Dump Changes</xf:label>
      </xf:submit>
     </body>
  </html>
};
declare
  %rest:path("/xforms/dump")
  %rest:POST("{$body}")
  %output:method("text")
function xforms:dump($body){
  <pre>{serialize($body)}</pre>
};

(:~
 : Edit a given Property
 :)
declare
  %rest:path("/xforms/edit/{$workspace}/{$node}")
  %output:method("xhtml")
function xforms:edit($workspace as xs:string,
    $node as xs:string){
      let $link := <span>
        <a href="/restxq/xforms/edit/{$workspace}">{$workspace}</a>
        / <a href="/restxq/xforms/edit/{$workspace}/{$node}">{$node}</a>
      </span>
      return ($link,
      <ul>{
        for $prop in nodes:get-properties-for($workspace, $node)
        let $property := string($prop/@name)
        return 
          <li><a href="/restxq/xforms/edit/{$workspace}/{$node}/{$property}">{$property}</a></li>
      }</ul>)
};

(:~
 : Edit a given Property
 :)
declare
  %rest:path("/xforms/edit/{$workspace}")
  %output:method("xhtml")
function xforms:edit($workspace as xs:string){
  let $link := <span>
    <a href="/restxq/xforms/edit/{$workspace}">{$workspace}</a>
  </span>
  return ($link,
  <ul>{
    for $node in nodes:get-nodes-for($workspace)
    let $node := string($node/@name)
    return 
      <li><a href="/restxq/xforms/edit/{$workspace}/{$node}">{$node}</a></li>
  }</ul>)
};