xquery version "3.0";

module namespace utils = "http://basex.org/basePIM/utils";
declare namespace rest = "http://exquery.org/ns/restxq";

import module namespace xmldb = "http://basex.org/basePIM/xmldb" at "../services/db-service.xqm";

(:~
 : Provides system information.
 :)
declare
	%rest:path("/admin/db/info")
	%output:method("html5")
function utils:system() {
	<pre>{ serialize(xmldb:system()) }</pre>
};
