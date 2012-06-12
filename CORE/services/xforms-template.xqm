xquery version "3.0";

module namespace tmpl = "http://basepim.org/tmpl";
declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace xf = "http://www.w3.org/2002/xforms";
declare namespace ev = "http://www.w3.org/2001/xml-events";
(: import module namespace xmldb = "http://basex.org/basePIM/xmldb" at "../services/db-service.xqm"; :)

(:~
: Wraps any given Content in an XForms compliant container.
: @param $workspace need for determining the save to location
: @param $model the model to edit
: @param $bindings optional bindings, a sequence of xf:bind nodes
: @param $content is placed inside the body of the template
:)
declare function tmpl:body($workspace as xs:string, $model as element(), $bindings as element(xf:bind)*, $content as element()){
	
	let $id := if($model/@id) then attribute {"id"} {"ii_"||$model/@id/string()} else ()
	return
	<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms">
     <head>
			<style type="text/css">
			
			</style>
        <title>Edit</title>
        <xf:model xmlns="">
           <xf:instance  xmlns="">
							{ $id }
              { $model }
           	</xf:instance>
          <xf:submission action="/restxq/xforms/dump/{$workspace}" replace="instance" id="dump" method="post">
			    <xf:message ev:event="xforms-submit-error">A submission error (<output value="event('error-type')"/>) occurred.</xf:message>
			    <xf:message level="ephemeral" ev:event="xforms-submit-done">Data has been successfully saved</xf:message>

					</xf:submission>
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
        <xf:label>Speichern</xf:label>
      </xf:submit>
     </body>
  </html>
  
  
};
(:~
: Wraps any given Content in an XForms compliant container and allows the implementor to 
: specify XML fragments as template instances.
: @param $tmpls sequence of fragments that are to be used as template instances for the XForm
: @param $workspace need for determining the save to location
: @param $model the model to edit
: @param $bindings optional bindings, a sequence of xf:bind nodes
: @param $content is placed inside the body of the template
:)

declare function tmpl:body-with-filter($tmpls, 
	$model as element(), $bindings as element(xf:bind)*, $content as element()){
	
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
						<xf:instance xmlns="" id="tmpl">
							<tmpl>{$tmpls}</tmpl>
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

(:~ 
: Returns the XPath to a given slot, used to determine the references when generating the
: generic edit form.
: @param $child the slot
: @return path to $child
:)
declare function tmpl:path-to-slot($child as node()){
	string-join($child/ancestor-or-self::*/name(.)[not(. = ("value", "node", "property", "workspace", "slot"))], "/")
};

(:~
: Creates a generic edit template for a given <code>slot</code>
: @param $uuid unique id that has been given to the model instance
: @param $slot the slot to edit, used as the model
: @return XForm
:)
declare function tmpl:edit-generic($uuid as xs:string, $slot as element(slot)) as element(div){
     (: <h3>Merkmal: </h3> :)
  <div xmlns:xf="http://www.w3.org/2002/xforms">
	{
		for $child in $slot//(@*, *)

		let $path := typeswitch($child)
			case element(*) return tmpl:path-to-slot($child)
			case attribute(*) return tmpl:path-to-slot($child) || "/@" || name($child)
			default return ()

		where (typeswitch($child)
			case element(*) return $child/text()
			case attribute(*) return fn:true()
			default return ()) and name() ne 'id'

		return <div>
			<xf:input ref="instance('ii_{$uuid}')/{$path}">
				<xf:label>{$path}</xf:label>
			</xf:input>
		</div>
		}
		<div>
			<xf:input ref="instance('ii_{$uuid}')/.">
				<xf:label>Value</xf:label>
			</xf:input>
		</div>
  </div>
};

(:~
 : Template for property "gewicht".
 :)

(:~
: Template for editing <code>slot[@name = "gewicht"]</code>
: @param $uuid unique id that has been given to the model instance
: @return XForm
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
: Bindings for <code>slot[@name = "gewicht"]</code>
: @param $uuid unique id that has been given to the model instance
: @return XForm
:)
declare function tmpl:gewicht-bind($uuid as xs:string){
  <xf:bind nodeset="instance('ii_{$uuid}')/num" type="xs:integer" required="true()" constraint=". &gt; 0"/>
};

(:~
: Template for editing <code>slot[@name = "bezeichnung"]</code>
: @param $uuid unique id that has been given to the model instance
: @return XForm
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
: Template for editing <code>slot[@name = "dimensions"]</code>
: @param $uuid unique id that has been given to the model instance
: @return XForm
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
(:~
: Bindings for <code>slot[@name = "dimensions"]</code>
: @param $uuid unique id that has been given to the model instance
: @return XForm
:)

declare function tmpl:dimensions-bind($uuid){
  <xf:bind nodeset="instance('ii_{$uuid}')/width/num" type="xs:integer" required="true()" constraint=". &gt; 0"/>,
  <xf:bind nodeset="instance('ii_{$uuid}')/height/num" type="xs:decimal" required="true()" constraint=". &gt; 0"/>,
  <xf:bind nodeset="instance('ii_{$uuid}')/length/num" type="xs:decimal" required="true()" constraint=". &gt; 0"/>
  
};

declare function tmpl:filterbuilder($workspace as xs:string){
	let $m := <data><filters>
    <any>
      <filter property="bezeichnung" type="contains" value="boot"/>
	      <all>
	        <filter property="price" type="gt" value="1000"/>
	      </all>
	      <any>
	        <filter property="price" type="gt" value="1000"/>
	      </any>
    </any>
  </filters></data>
	let $filter := (<all><filter property="" type="" value=""/></all>,
									<any><filter property="" type="" value=""/></any>,
									<filter property="" type="" value=""/>
									),
   		 $binds := (
				 <xf:bind id="all" nodeset="filters/all" relevant="."/>,
				 <xf:bind id="allall" nodeset="filters/all/all"/>,
				 <xf:bind id="allany" nodeset="filters/all/any"/>,
				 <xf:bind id="any" nodeset="filters/any" relevant="."/>,
				 <xf:bind id="anyall" nodeset="filters/any/all"/>,
				 <xf:bind id="anyany" nodeset="filters/any/any"/>
			)
	return tmpl:body-with-filter($filter,$m, $binds, tmpl:generate-search())
};

(: XForms Filter Builder! :)
declare function tmpl:generate-search(){
 
  <div>
	  <xf:repeat class="all" id="all_1" nodeset="filters/all">
	    <div>
	      <xf:repeat nodeset="filter" test="hello" id="filter_1_977e8730-d98c-4748-8f71-c04ebb21af6c">
	      <table style="width:480px">
	        <tr>
	          <td>
	            <xf:select1 ref="@property">
							{tmpl:properties("ws_produkte")}
	            </xf:select1>
	          </td>
	          <td>
	            <xf:select1 ref="@type">
							{tmpl:items()}
	            </xf:select1>
	          </td>
	          <td>
	            <xf:input ref="@value"/>
	          </td>
	          <td/>
	        </tr>
	      </table>
	      </xf:repeat>
	      <table>
	        <tr>
	          <td>
	            <xf:trigger>
	              <xf:label>Add Filter</xf:label>
	              <xf:insert nodeset="filter" origin="instance('tmpl')/*:filter" position="after" at="last()"/>
	            </xf:trigger>
	          </td>
	          <td>
	            <xf:trigger>
	              <xf:label style="color:red">✘</xf:label>
	              <xf:delete nodeset="filter" at="index('filter_1_977e8730-d98c-4748-8f71-c04ebb21af6c')"/>
	            </xf:trigger>
	          </td>
	        </tr>
	      </table>
	    </div>
	    <div>
	      <xf:repeat class="all" id="all_2" nodeset="all">
	        <div>
	          <xf:repeat nodeset="filter" test="hello" id="filter_2_8e3df719-72c8-450e-b6db-25e565400bed">
	          <table style="width:480px">
	            <tr>
	              <td>
	                <xf:select1 ref="@property">
									{tmpl:properties("ws_produkte")}
	                </xf:select1>
	              </td>
	              <td>
	                <xf:select1 ref="@type">
									{tmpl:items()}
	                </xf:select1>
	              </td>
	              <td>
	                <xf:input ref="@value"/>
	              </td>
	              <td/>
	            </tr>
	          </table>
	          </xf:repeat>
	          <table>
	            <tr>
	              <td>
	                <xf:trigger>
	                  <xf:label>Add Filter</xf:label>
	                  <xf:insert nodeset="filter" origin="instance('tmpl')/*:filter" position="after" at="last()"/>
	                </xf:trigger>
	              </td>
	              <td>
	                <xf:trigger>
	                  <xf:label style="color:red">✘</xf:label>
	                  <xf:delete nodeset="filter" at="index('filter_2_8e3df719-72c8-450e-b6db-25e565400bed')"/>
	                </xf:trigger>
	              </td>
	            </tr>
	          </table>
	        </div>
	      </xf:repeat>
			  <!--    <table>
	        <tr>
	          <td>
	            <xf:trigger>
	              <xf:label>Add <strong>OR</strong> Group</xf:label>
	              <xf:insert nodeset="all" origin="instance('tmpl')/*:any" position="after" at="last()"/>
	            </xf:trigger>
	          </td>
	          <td>
	            <xf:trigger>
	              <xf:label>Add <strong>AND</strong> Group</xf:label>
	              <xf:insert nodeset="all" origin="instance('tmpl')/*:and" position="after" at="last()"/>
	            </xf:trigger>
	          </td>
	        </tr>
	      </table> -->
	    </div>
	    <div>
	      <xf:repeat class="any" id="any_2" nodeset="any">
	        <div>
	          <xf:repeat nodeset="filter" test="hello" id="filter_2_cb23138f-f39b-4b18-9bd2-40d137210021">
	            <table style="width:480px">
	              <tr>
	                <td>
	                  <xf:select1 ref="@property">
										{tmpl:properties("ws_produkte")}
	                  </xf:select1>
	                </td>
	                <td>
	                  <xf:select1 ref="@type">
										{tmpl:items()}
	                  </xf:select1>
	                </td>
	                <td>
	                  <xf:input ref="@value"/>
	                </td>
	                <td/>
	              </tr>
	            </table>
	          </xf:repeat>
	          <table>
	            <tr>
	              <td>
	                <xf:trigger>
	                  <xf:label>Add Filter</xf:label>
	                  <xf:insert nodeset="filter" origin="instance('tmpl')/*:filter" position="after" at="last()"/>
	                </xf:trigger>
	              </td>
	              <td>
	                <xf:trigger>
	                  <xf:label style="color:red">✘</xf:label>
	                  <xf:delete nodeset="filter" at="index('filter_2_cb23138f-f39b-4b18-9bd2-40d137210021')"/>
	                </xf:trigger>
	              </td>
	            </tr>
	          </table>
	        </div>
	      </xf:repeat>

	  <!--    <table>
	        <tr>
	          <td>
	            <xf:trigger>
	              <xf:label>Add <strong>OR</strong> Group</xf:label>
	              <xf:insert nodeset="any" origin="instance('tmpl')/*:any" position="after" at="last()"/>
	            </xf:trigger>
	          </td>
	          <td>
	            <xf:trigger>
	              <xf:label>Add <strong>AND</strong> Group</xf:label>
	              <xf:insert nodeset="any" origin="instance('tmpl')/*:and" position="after" at="last()"/>
	            </xf:trigger>
	          </td>
	        </tr>
	      </table> -->
	    </div>
	  </xf:repeat>
	<!-- Top LEVEL ANY -->
		<xf:repeat class="any" id="any1" nodeset="filters/any">
		  <div>
		    <xf:repeat nodeset="filter" test="hello" id="filterany_1_977e8730-d98c-4748-8f71-c04ebb21af6c">
		    <table style="width:480px">
		      <tr>
		        <td>
		          <xf:select1 ref="@property">
							{tmpl:properties("ws_produkte")}
		          </xf:select1>
		        </td>
		        <td>
		          <xf:select1 ref="@type">
							{tmpl:items()}
		          </xf:select1>
		        </td>
		        <td>
		          <xf:input ref="@value"/>
		        </td>
		        <td/>
		      </tr>
		    </table>
		    </xf:repeat>
		    <table>
		      <tr>
		        <td>
		          <xf:trigger>
		            <xf:label>Add Filter</xf:label>
		            <xf:insert nodeset="filter" origin="instance('tmpl')/*:filter" position="after" at="last()"/>
		          </xf:trigger>
		        </td>
		        <td>
		          <xf:trigger>
		            <xf:label style="color:red">✘</xf:label>
		            <xf:delete nodeset="filter" at="index('filterany_1_977e8730-d98c-4748-8f71-c04ebb21af6c')"/>
		          </xf:trigger>
		        </td>
		      </tr>
		    </table>
		  </div>
		  <div>
		    <xf:repeat class="all" id="all_2" nodeset="all">
		      <div>
		        <xf:repeat nodeset="filter" test="hello" id="filterany_2_8e3df719-72c8-450e-b6db-25e565400bed">
		        <table style="width:480px">
		          <tr>
		            <td>
		              <xf:select1 ref="@property">
									{tmpl:properties("ws_produkte")}
		              </xf:select1>
		            </td>
		            <td>
		              <xf:select1 ref="@type">
									{tmpl:items()}
		              </xf:select1>
		            </td>
		            <td>
		              <xf:input ref="@value"/>
		            </td>
		            <td/>
		          </tr>
		        </table>
		        </xf:repeat>
		        <table>
		          <tr>
		            <td>
		              <xf:trigger>
		                <xf:label>Add Filter</xf:label>
		                <xf:insert nodeset="filter" origin="instance('tmpl')/*:filter" position="after" at="last()"/>
		              </xf:trigger>
		            </td>
		            <td>
		              <xf:trigger>
		                <xf:label style="color:red">✘</xf:label>
		                <xf:delete nodeset="filter" at="index('filterany_2_8e3df719-72c8-450e-b6db-25e565400bed')"/>
		              </xf:trigger>
		            </td>
		          </tr>
		        </table>
		      </div>
		    </xf:repeat>
			  <!--    <table>
		      <tr>
		        <td>
		          <xf:trigger>
		            <xf:label>Add <strong>OR</strong> Group</xf:label>
		            <xf:insert nodeset="all" origin="instance('tmpl')/*:any" position="after" at="last()"/>
		          </xf:trigger>
		        </td>
		        <td>
		          <xf:trigger>
		            <xf:label>Add <strong>AND</strong> Group</xf:label>
		            <xf:insert nodeset="all" origin="instance('tmpl')/*:and" position="after" at="last()"/>
		          </xf:trigger>
		        </td>
		      </tr>
		    </table> -->
		  </div>
		  <div>
		    <xf:repeat class="any" id="any_2" nodeset="any">
		      <div>
		        <xf:repeat nodeset="filter" test="hello" id="filterany_2_cb23138f-f39b-4b18-9bd2-40d137210021">
		          <table style="width:480px">
		            <tr>
		              <td>
		                <xf:select1 ref="@property">
										{tmpl:properties("ws_produkte")}
		                </xf:select1>
		              </td>
		              <td>
		                <xf:select1 ref="@type">
										{tmpl:items()}
		                </xf:select1>
		              </td>
		              <td>
		                <xf:input ref="@value"/>
		              </td>
		              <td/>
		            </tr>
		          </table>
		        </xf:repeat>
		        <table>
		          <tr>
		            <td>
		              <xf:trigger>
		                <xf:label>Add Filter</xf:label>
		                <xf:insert nodeset="filter" origin="instance('tmpl')/*:filter" position="after" at="last()"/>
		              </xf:trigger>
		            </td>
		            <td>
		              <xf:trigger>
		                <xf:label style="color:red">✘</xf:label>
		                <xf:delete nodeset="filter" at="index('filterany_2_cb23138f-f39b-4b18-9bd2-40d137210021')"/>
		              </xf:trigger>
		            </td>
		          </tr>
		        </table>
		      </div>
		    </xf:repeat>
		  </div>
		</xf:repeat>
	</div>
};

declare function tmpl:properties($name){
	(for $prop in distinct-values(db:open($name)//property/@name)
	return <xf:item>
                    <xf:label>{string($prop)}</xf:label>
                    <xf:value>{string($prop)}</xf:value> 
                </xf:item>)
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