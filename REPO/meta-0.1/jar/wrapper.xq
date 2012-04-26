(:~
 : This module parses meta data from files.
 : @author BaseX Team
 :)
module namespace module = "http://basex.org/modules/meta";

(:~ Java namespace. :)
declare namespace java = "java:org.basex.modules.meta.Meta";

(:~
 : Initializes the path to the ExifTool executable
 : (default: "exiftool").
 : @param path path to exiftool
 :)
declare %public function module:init-exiftool(
    $path as xs:string)
    as empty-sequence()
{
  java:init-exiftool($path)
};

(:~
 : Extracts meta data from the specified file, using ExifTool.
 : @param path source path
 : @return document node with meta data
 :)
declare %public function module:exiftool(
    $file as xs:string)
    as document-node()
{
  java:exiftool($file)
};

(:~
 : Extracts meta data from the specified file,
 : based on the file suffix
 : @param path source path
 : @return document node with meta data
 :)
declare %public function module:extract(
    $file as xs:string)
    as document-node()
{
  java:extract($file)
};
