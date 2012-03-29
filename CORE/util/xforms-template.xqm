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

(: import module namespace xmldb = "http://basex.org/basePIM/xmldb" at "../services/db-service.xqm"; :)

(:~
 : Template for property "bezeichnung".
 :)
declare function tmpl:bezeichnung() as element(div) {

  <div xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events">
  <xf:repeat nodeset="property/value/slot" id="slots">
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
        <xf:insert nodeset="property/value/slot" position="after" />
     </xf:action>
  </xf:trigger>
  <xf:trigger>
     <xf:label>✘ Delete Selected</xf:label>
     <xf:delete nodeset="property/value/slot[index('slots')]" 
         at="index('slots')" ev:event="DOMActivate" />
   </xf:trigger>

	</div>
};
(:~
 : Template for property "dimension".
 :)
declare function tmpl:dimensions() as element(div) {

  <div xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events">
	<style>
		label {{width:60px}}
	</style>
	<div>
   <xf:input ref="property/value/slot/width/num">
     <xf:label>Width </xf:label>
     <xf:hint></xf:hint>
	</xf:input>
	 <xf:select1 ref="property/value/slot/width/unit" appearance="minimal" >  
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
   <xf:input ref="property/value/slot/height/num">
     <xf:label>Height </xf:label>
     <xf:hint></xf:hint>
	</xf:input>
	 <xf:select1 ref="property/value/slot/height/unit" appearance="minimal" >  
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
   <xf:input ref="property/value/slot/length/num">
     <xf:label>Length:</xf:label>
     <xf:hint></xf:hint>
	</xf:input>
	 <xf:select1 ref="property/value/slot/length/unit" appearance="minimal" >  
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
