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
module namespace _ = "http://basepim.org/services/file";

(:~
: This function is supposed to store files inside the file system.
: <strong>*TODO*</strong> at the moment it only dumps some information out to the browser.
:)
declare function _:store(
  $data as item())
  as element(data)
{
  (: Stores a binary resource specified by $data at the location specified by $path. 
   : db:store($db as item(), $path as xs:string, $data as item()) as empty-sequence()
   :)
	<data> { $data } </data>
};
