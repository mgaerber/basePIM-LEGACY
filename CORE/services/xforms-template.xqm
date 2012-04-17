xquery version "3.0";

module namespace tmpl = "http://basepim.org/tmpl";
declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace xf = "http://www.w3.org/2002/xforms";
(: import module namespace xmldb = "http://basex.org/basePIM/xmldb" at "../services/db-service.xqm"; :)

declare function tmpl:body($model as element(), $bindings as element(xf:bind)*, $content as element()){
	
	let $id := if($model/@id) then attribute {"id"} {"ii_{$model/@id}"} else ()
	return
	<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms">
     <head>
        <title>Hello World in XForms</title>
        <xf:model>
           <xf:instance  xmlns="">
							{ $id }
              { $model }
           	</xf:instance>
          <xf:submission action="/restxq/xforms/dump" id="dump" method="post" />
          {$bindings}
        </xf:model>
			  <style>
			    label {{width:160px}}
			    .any, .all {{
	          padding:10px;
	        }}
	        .any {{
	          border-left:5px solid #004080;
	        }}
	        .all {{
	          border-left:5px solid #408000;
	        }}
	    
			  </style>

     </head>
     <body>
     {$content}
      <br />
      <hr />
      <xf:submit submission="dump">
        <xf:label>Dump Changes</xf:label>
      </xf:submit>
     </body>
  </html>
  
  
};

declare function tmpl:filterbuilder($workspace as xs:string){
	let $m := <data><filters>
    <all>
      <all>
        <filter property="art-nr" type="starts-with" value="84"/>
        <filter property="price" type="gt" value="1000"/>
      </all>
      <filter property="bezeichnung" type="contains" value="boot"/>
      <filter property="bezeichnung" type="contains" value="motor"/>
        <any>
          <filter property="art-nr" type="starts-with" value="e"/>
          <filter property="price" type="gt" value="f"/>
        </any>
    </all>
  </filters></data>
	return tmpl:body($m, (), tmpl:generate-search($m/*, "" ))
};

declare function tmpl:path-to-slot($child as node()){
	string-join($child/ancestor-or-self::*/name(.)[not(. = ("value", "node", "property", "workspace", "slot"))], "/")
};
(:~
 : Creates a generic edit template
 :
 :
:)
declare function tmpl:edit-generic($uuid as xs:string, $slot as element(slot)) as element(div){
  <div xmlns:xf="http://www.w3.org/2002/xforms">
	{
		for $child in $slot//(@*, *)

		let $path := typeswitch($child)
			case element(*) return tmpl:path-to-slot($child)
			case attribute(*) return tmpl:path-to-slot($child) || "/@" || name($child)
			default return ()

		where typeswitch($child)
			case element(*) return $child/text()
			case attribute(*) return fn:true()
			default return ()

		return <div>
			<xf:input ref="instance('ii_{$uuid}')/{$path}">
				<xf:label>{$path}</xf:label>
			</xf:input>
		</div>
		}
  </div>
};

(:~
 : Template for property "gewicht".
 :)

declare function tmpl:edit-gewicht($uuid as xs:string) as element(div){
  <div xmlns:xf="http://www.w3.org/2002/xforms">
  <div>
     <xf:input ref="@lang">
       <xf:label>Lang name:</xf:label>
       <xf:hint>Valid languages are seperated with a space</xf:hint>
    </xf:input>
     <xf:input ref="num">
       <xf:label>Num:</xf:label>
       <xf:hint>Number.</xf:hint>
    </xf:input>
     <xf:input ref="unit">
       <xf:label>Unit:</xf:label>
       <xf:hint>Unit</xf:hint>
    </xf:input>
  </div>
  </div>
};

(:~
 : Template for property "gewicht".
 :)

declare function tmpl:gewicht-bind($uuid as xs:string){
  <xf:bind nodeset="instance('ii_{$uuid}')/num" type="xs:integer" required="true()" constraint=". &gt; 0"/>
};
(:~
 : Template for property "bezeichnung".
 :)
declare function tmpl:edit-bezeichnung($uuid as xs:string) as element(div) {

  <div xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events">
  <div>
     <xf:input ref="instance('ii_{$uuid}')/@brand">
       <xf:label>Brand name:</xf:label>
       <xf:hint></xf:hint>
    </xf:input>
     <xf:input ref="instance('ii_{$uuid}')/@lang">
       <xf:label>Valid languages:</xf:label>
       <xf:hint>Valid languages are seperated with a space.</xf:hint>
    </xf:input>
     <xf:input ref=".">
       <xf:label>Description:</xf:label>
       <xf:hint>Descriptions are full-text</xf:hint>
    </xf:input>

  </div>
  </div>
};
declare function tmpl:bezeichnung-bind($uuid as xs:string) as empty-sequence(){
 ()
};


(:~
 : Template for property "dimension".
 :)
declare function tmpl:edit-dimensions($uuid as xs:string) as element(div) {

  <div>
  <div>
   <xf:input ref="instance('ii_{$uuid}')/width/num">
     <xf:label>Width </xf:label>
     <xf:hint></xf:hint>
  </xf:input>
   <xf:select1 ref="instance('ii_{$uuid}')/width/unit" appearance="minimal" >  
       <xf:item>
           <xf:label>millimeters</xf:label>
           <xf:value>mm</xf:value> 
       </xf:item>
       <xf:item>
           <xf:label>centimeters</xf:label>
           <xf:value>cm</xf:value>
       </xf:item>
       <xf:item>
           <xf:label>meters</xf:label>
           <xf:value>m</xf:value>
       </xf:item>
       <xf:hint>Unit</xf:hint>
  </xf:select1>
  </div>
  <div>
   <xf:input ref="instance('ii_{$uuid}')/height/num">
     <xf:label>Height </xf:label>
     <xf:hint></xf:hint>
  </xf:input>
   <xf:select1 ref="instance('ii_{$uuid}')/height/unit" appearance="minimal" >  
       <xf:item>
           <xf:label>millimeters</xf:label>
           <xf:value>mm</xf:value> 
       </xf:item>
       <xf:item>
           <xf:label>centimeters</xf:label>
           <xf:value>cm</xf:value>
       </xf:item>
       <xf:item>
           <xf:label>meters</xf:label>
           <xf:value>m</xf:value>
       </xf:item>
       <xf:hint>Unit</xf:hint>
  </xf:select1>
  </div>
  <div>
   <xf:input ref="instance('ii_{$uuid}')/length/num">
     <xf:label>Length:</xf:label>
     <xf:hint></xf:hint>
  </xf:input>
   <xf:select1 ref="instance('ii_{$uuid}')/length/unit" appearance="minimal" >  
       <xf:item>
           <xf:label>millimeters</xf:label>
           <xf:value>mm</xf:value> 
       </xf:item>
       <xf:item>
           <xf:label>centimeters</xf:label>
           <xf:value>cm</xf:value>
       </xf:item>
       <xf:item>
           <xf:label>meters</xf:label>
           <xf:value>m</xf:value>
       </xf:item>
       <xf:hint>Unit</xf:hint>
  </xf:select1>
  </div>
  </div>
};

declare function tmpl:dimensions-bind($uuid){
  <xf:bind nodeset="instance('ii_{$uuid}')/width/num" type="xs:integer" required="true()" constraint=". &gt; 0"/>,
  <xf:bind nodeset="instance('ii_{$uuid}')/height/num" type="xs:decimal" required="true()" constraint=". &gt; 0"/>,
  <xf:bind nodeset="instance('ii_{$uuid}')/length/num" type="xs:decimal" required="true()" constraint=". &gt; 0"/>
  
};
(: XForms Filter Builder! :)
declare function tmpl:generate-search($node, $root as xs:string){
 
	if(name($node) = "filters") then tmpl:generate-search($node/*, "filters/"||$root) else 
	<xf:repeat class="{name($node)}" nodeset="{$root}{name($node)}">
	{
	for $item in $node/filter[1]
	return
		<xf:repeat nodeset="filter">
			<xf:group>
			<table><tr><td>
				<xf:select1 ref="@property">{tmpl:properties("ws_produkte")}</xf:select1>
				</td>
				<td>
				<xf:select1 ref="@type">{tmpl:items()}</xf:select1> 
				</td>
				<td>
				<xf:input ref="@value" />
				</td>
				</tr></table>
			</xf:group>
	  </xf:repeat>
	}
	{
		for $item in $node/(all | any)
		return tmpl:generate-search($item, "")
	}
	</xf:repeat>
};

declare function tmpl:properties($name){
	for $prop in distinct-values(db:open($name)//property/@name)
	return <xf:item>
                    <xf:label>{string($prop)}</xf:label>
                    <xf:value>{string($prop)}</xf:value> 
                </xf:item>
};
declare function tmpl:items(){
                <data><xf:item>
                    <xf:label>contains text</xf:label>
                    <xf:value>contains</xf:value> 
                </xf:item>
                <xf:item>
                    <xf:label>starts with</xf:label>
                    <xf:value>starts-with</xf:value>
                </xf:item>
                <xf:item>
                    <xf:label>ends with</xf:label>
                    <xf:value>ends-with</xf:value>
                </xf:item>
                <xf:item>
                    <xf:label>&gt;</xf:label>
                    <xf:value>gt</xf:value>
                </xf:item>
                <xf:item>
                    <xf:label>&lt;</xf:label>
                    <xf:value>lt</xf:value>
                </xf:item>
                <xf:item>
                    <xf:label>=</xf:label>
                    <xf:value>eq</xf:value>
                </xf:item></data>//*:item
};