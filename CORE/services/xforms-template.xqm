(: <p>Type your first name in the input box. <br/>
  If you are running XForms, the output should be displayed in the output area.</p>   
   <xf:input ref="PersonGivenName" incremental="true">
      <xf:label>Please enter your first name: </xf:label>
   </xf:input>
   <br />
   <xf:output value="concat('Hello ', PersonGivenName, '. We hope you like XForms!')">
      <xf:label>Output: </xf:label>
   </xf:output>
:)
xquery version "3.0";

module namespace tmpl = "http://basepim.org/tmpl";
declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace xf = "http://www.w3.org/2002/xforms";
(: import module namespace xmldb = "http://basex.org/basePIM/xmldb" at "../services/db-service.xqm"; :)

declare function tmpl:body($model as element(), $bindings as element(xf:bind)*, $content as element()){
(	<?xml-stylesheet href="/xsltforms/xsltforms.xsl" type="text/xsl"?>,
	<?xsltforms-options debug="no"?>,
	<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms">
     <head>
<link rel="stylesheet" href="/xsltforms/xsltforms.css" type="text/css" media="screen" title="XSLTForms" charset="utf-8" />
        <title>Hello World in XForms</title>
        <xf:model>
           <xf:instance id="ii_{$model/@id}" xmlns="">
              { $model }
           		</xf:instance>
          <xf:submission action="/restxq/xforms/dump" id="dump" method="post" />
          {$bindings}
        </xf:model>
			  <style>
			    label {{width:160px}}
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
)  
  
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
