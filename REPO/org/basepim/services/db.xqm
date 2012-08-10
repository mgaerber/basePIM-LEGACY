(:~ 
 :  This module provides database service functionality.
 : 
 :  @author Alexander Holupirek
 :  @since March 22, 2012
 :  @version 1.0
 :)
module namespace _ = "http://basepim.org/services/db";

(:~
 : Returns information on the database system, such as the database path and current database settings.
 :)
declare function _:system()
  as element(system)
{
	db:system()		
};
