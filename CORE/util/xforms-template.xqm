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
  <html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms">
     <head>
        <title>Hello World in XForms</title>
        <xf:model>
           <xf:instance xmlns="">
              <data>
              { $model }
              </data>
           </xf:instance>
          <xf:submission action="/restxq/xforms/dump" id="dump" method="post" />
          {$bindings}
        </xf:model>
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
(:~
 : Template for property "gewicht".
 :)

declare function tmpl:edit-gewicht() as element(div){
  <div xmlns:xf="http://www.w3.org/2002/xforms">
  <xf:repeat nodeset="//property[@name='gewicht']/value/slot" id="gslots">
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
  </xf:repeat>
  </div>
};
(:~
 : Template for property "gewicht".
 :)

declare function tmpl:gewicht-bind(){
  <xf:bind nodeset="//property[@name='gewicht']/value/slot/num" type="xs:integer" required="true()" constraint=". &gt; 0"/>
};
(:~
 : Template for property "bezeichnung".
 :)
declare function tmpl:edit-bezeichnung() as element(div) {

  <div xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events">
  <xf:repeat nodeset="//property[@name='bezeichnung']/value/slot" id="slots">
  <div>
     <xf:input ref="@brand">
       <xf:label>Brand name:</xf:label>
       <xf:hint></xf:hint>
    </xf:input>
     <xf:input ref="@lang">
       <xf:label>Valid languages:</xf:label>
       <xf:hint>Valid languages are seperated with a space.</xf:hint>
    </xf:input>
     <xf:input ref=".">
       <xf:label>Description:</xf:label>
       <xf:hint>Descriptions are full-text</xf:hint>
    </xf:input>

  </div>
  
  </xf:repeat> 
  <xf:trigger>
     <xf:label>+ New Description</xf:label>
     <xf:action ev:event="DOMActivate">
        <xf:insert nodeset="//property[@name='bezeichnung']/value/slot" position="after" />
     </xf:action>
  </xf:trigger>
  <xf:trigger>
     <xf:label>✘ Delete Selected</xf:label>
     <xf:delete nodeset="//property[@name='bezeichnung']/value/slot[index('slots')]" 
         at="index('slots')" ev:event="DOMActivate" />
   </xf:trigger>

  </div>
};
declare function tmpl:bezeichnung-bind() as empty-sequence(){
 ()
};


(:~
 : Template for property "dimension".
 :)
declare function tmpl:edit-dimensions() as element(div) {

  <div 
    xmlns:ev="http://www.w3.org/2001/xml-events"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" >
  <style>
    label {{width:60px}}
  </style>
  <div>
   <xf:input ref="//property[@name='dimensions']/value/slot/width/num">
     <xf:label>Width </xf:label>
     <xf:hint></xf:hint>
  </xf:input>
   <xf:select1 ref="//property[@name='dimensions']/value/slot/width/unit" appearance="minimal" >  
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
   <xf:input ref="//property[@name='dimensions']/value/slot/height/num">
     <xf:label>Height </xf:label>
     <xf:hint></xf:hint>
  </xf:input>
   <xf:select1 ref="//property[@name='dimensions']/value/slot/height/unit" appearance="minimal" >  
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
   <xf:input ref="//property[@name='dimensions']/value/slot/length/num">
     <xf:label>Length:</xf:label>
     <xf:hint></xf:hint>
  </xf:input>
   <xf:select1 ref="//property[@name='dimensions']/value/slot/length/unit" appearance="minimal" >  
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

declare function tmpl:dimensions-bind(){
  <xf:bind nodeset="//property[@name='dimensions']/value/slot/width/num" type="xs:integer" required="true()" constraint=". &gt; 0"/>,
  <xf:bind nodeset="//property[@name='dimensions']/value/slot/height/num" type="xs:decimal" required="true()" constraint=". &gt; 0"/>,
  <xf:bind nodeset="//property[@name='dimensions']/value/slot/length/num" type="xs:decimal" required="true()" constraint=". &gt; 0"/>
  
};
