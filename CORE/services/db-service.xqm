xquery version "3.0";

(:~ 
 :  This module provides database service functionality.
 : 
 :  @author Alexander Holupirek
 :  @since March 22, 2012
 :  @version 1.0
 :)
module namespace xmldb = "http://basex.org/basePIM/xmldb";

(:~
 : Returns information on the database system, such as the database path and current database settings.
 :)
declare function xmldb:system() as element(system) {
	db:system()		
};
