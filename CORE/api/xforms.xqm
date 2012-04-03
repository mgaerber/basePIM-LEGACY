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
        case "bezeichnung" return tmpl:edit-bezeichnung()
        case "dimensions" return tmpl:edit-dimensions()
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
  %rest:path("/xforms/grid-edit/{$workspace}/{$node}")
  %output:method("xhtml")
function xforms:grid-edit($workspace as xs:string,
    $node as xs:string){
      let $node  := nodes:get-product-by-name($workspace, $node)
      let $langs := nodes:get-languages-for($node)
      let $binds := for $prop in $node/property return switch(string($prop/@name))
       case "bezeichnung" return tmpl:bezeichnung-bind()
       case "dimensions" return tmpl:dimensions-bind()
       case "gewicht"    return tmpl:gewicht-bind()
       default return ()
      let $form  := 
      <table cellspacing="5" cellpadding="5"><tr> <th>Prop</th>{
      for $lang in $langs
      order by $lang
      return 
        <th>{$lang}</th>
     
     
      }<th>Form</th></tr>
      { 
     for $prop in $node/property
     return <tr>
     <th>{string($prop/@name)}</th>
     {
       for $lang in $langs
       let $vals := $prop/value//slot[@lang = $lang or tokenize(@lang, " ") = $lang]
       order by $lang
       
       return
       <td width="150">
        {
          if($vals) then
            ( string-join($vals/text(), "; ")
            )
          else "☃"
        }
       </td> 
     }
     <td width="600">{switch(string($prop/@name))
     case "bezeichnung" return tmpl:edit-bezeichnung()
     case "dimensions" return tmpl:edit-dimensions()
     case "gewicht"    return tmpl:edit-gewicht()
     default return ()
     }</td>
      </tr>
    }</table>
   return tmpl:body($node, $binds, $form)
};


(:~
 : Show the properties of a given node for editing.
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