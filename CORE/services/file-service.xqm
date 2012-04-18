xquery version "3.0";

(:~ 
 :  This module provides service functionality around files.
 :
 :  Stores regular files (images, documents, ...) in the database.
 :  Extracts metadata from files and stores them for later usage
 :  as unified XML representation in the database.
 :
 :  @author Alexander Holupirek
 :  @since April 4, 2012
 :  @version 1.0
 :)
module namespace file-service = "http://basex.org/basePIM/file-service";

(:~
 : Store file in database.
 :)
declare function file-service:store($data as item()) as element(data) {
    (: Stores a binary resource specified by $data at the location specified by $path. 
     : db:store($db as item(), $path as xs:string, $data as item()) as empty-sequence()
     :)
	<data> { $data } </data>
};
