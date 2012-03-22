module namespace nodes = "http://basepim.org/nodes";
declare namespace rest = "http://exquery.org/ns/restxq";

(:~
  This function says hello to everyone visiting /say/hello/<NAME>
  @param $w the name to say <strong>hello to</strong>
  @author Michael Seiferle
~:)
declare
	%rest:path("/say/hello/{$w}")
function nodes:hello-world($w as xs:string){
	<strong>Hello { $w }</strong>
};


(:
 : Receive name from input form.
 :)
declare    
	%rest:POST
	%rest:path("/hello/receive-name")
	%rest:form-param("name", "{$name}")
	%output:method("html5")
function nodes:result($name) {
	<html>
	<head>
		<title>Howdy ...</title>
        </head>
        <body>
            <p>Howdy, {
		if ($name eq "") then "lazy bro" else $name
		}!
	    </p>
        </body>
    </html>
};
