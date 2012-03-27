xquery version "3.0";

module namespace xforms = "http://basex.org/basePIM/xforms";
declare namespace rest = "http://exquery.org/ns/restxq";

(: import module namespace xmldb = "http://basex.org/basePIM/xmldb" at "../services/db-service.xqm"; :)

(:~
 : Provides system information.
 :)
declare
	%rest:path("/xforms/test")
	%output:method("xhtml")
function xforms:test() {

  <html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms">
     <head>
        <title>Hello World in XForms</title>
        <xf:model>
           <xf:instance xmlns="">
              <data>
                 <PersonGivenName/>
              </data>
           </xf:instance>
        </xf:model>
     </head>
     <body>
        <p>Type your first name in the input box. <br/>
          If you are running XForms, the output should be displayed in the output area.</p>   
           <xf:input ref="PersonGivenName" incremental="true">
              <xf:label>Please enter your first name: </xf:label>
           </xf:input>
           <br />
           <xf:output value="concat('Hello ', PersonGivenName, '. We hope you like XForms!')">
              <xf:label>Output: </xf:label>
           </xf:output>
     </body>
  </html>

};
