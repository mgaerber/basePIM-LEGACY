module namespace _ = "http://basex.org/basePIM/upload";

import module namespace meta = "http://basex.org/modules/meta/Meta";

(:~
: Test XMLHttpRequest GET functionality.
: **	This function should be removed? **
: Related website: WWW/test/put.html
 :)
declare
  %restxq:GET
  %restxq:path("/upload/file/get/answer/42")
  %output:method("xml")
  function _:xmlhttprequest-get()
{
  "The answer is 42"
};

(:~
: This function saves binary data.
: @param $data octet stream of data to save *TODO*
: @param $value used for *TODO*
 : Related website: WWW/test/put.html
 :)
declare
  %restxq:PUT("{$data}")
  %restxq:path("/upload/file/test/put/answer/{$value}")
  %output:method("text")
  function _:xmlhttprequest-get(
    $data,
    $value)
{
  concat("We all know it. The answer is: ", $value)
};

(:~
: Test PUT (via curl) and return HTML.
: This function saves binary data.
: @param $data octet stream of data to save *TODO*
: @param $value used for *TODO*
 : Related website: WWW/test/put.html
 : $ curl -s -i -X PUT -H "Content-Type: application/octet-stream" -T "./powermotor.png" "admin:admin@localhost:8984/restxq//upload/file/test/put/pm.png"
 :)
declare
  %restxq:PUT("{$img}")
	%restxq:path("/upload/file/test/put/{$name}")
	%output:method("html5")
  function _:put-file(
    $name,
    $img)
{
  <div>
    <h2>My Image File: {$name}</h2>
    <pre>{$img}</pre>
    <img src="data:image/png;base64,{$img}" width="200" height="200" alt="Data URL image"/>
  </div>
};

(:~
 : Returns file list on server.
 :)
declare
  %restxq:GET
  %restxq:path("/file/list")
	%restxq:produces("text/html")
  %output:method("html")
  function _:list-files()
{
  <ul>{
    for $f in db:list("ws_bilder")
    return 
      if ($f)
      then <li><a href="/rest/ws_bilder/{ $f }" target="_blank">{ $f }</a></li> 
      else ()
  }</ul>
};

(:~
 : Receives file data.
 :
 : Files uploaded are sent with 'Content-Type: application/octet-stream'.
 : BaseX Database Module (http://docs.basex.org/wiki/Database_Module)
 : is used to store the received data. Files are saved inside the database
 : directory in a subfolder entitled 'raw'.
 : @param $img the image to save
 : @param $name name for the image to save
 :)
declare %updating
  %restxq:PUT("{$img}")
	%restxq:path("/upload/image/put/{$name}")
	%output:method("text")
  function _:put-image(
    $name,
    $img)
{
  db:output("File is uploaded"),
  db:store("ws_bilder", $name, $img)
};

(:~
 : Returns metadata for all uploaded files.
 :)

declare
  %restxq:GET
	%restxq:path("/upload/metadata/")
	%output:method("xml")
  function _:get-metadata()
{
  let $root := "DATA/ws_bilder/raw/"
  return
      for $f in file:list($root)
      let $md := meta:extract($root || $f)
      return <file name="{ $f }">{$md}</file>
};

(:~
 : Get POSTed images and other form data.
 : Related website: WWW/test/dojo_file_upload.html
 : @param $payload the payload
 : @param $title the title *TODO*
 : @param $year the year *TODO*
 :)
declare
  %restxq:POST("{$payload}")
	%restxq:path("/upload/file/post")
	%restxq:form-param("title", "{$title}", "default title")
	%restxq:form-param("year",  "{$year}",  "default year")
	%output:method("html5")
  function _:post-file(
    $payload,
    $title,
    $year)
{
  <html>
    <head>
    <script type="text/javascript">
    <!--
    function doit() {
          var cipherText = btoa(document.b64.clear.value);
          document.b64.cipher.value = cipherText;
        }
        
        function undoit(){
          var clearText = atob(document.b64.cipher.value);
          document.b64.clear.value = clearText;
        }
    //-->
    </script>
    </head>
    <body>
      <div>
        <h2>Multiple File Upload Form: {$title}, {$year}</h2>
      </div>
      <hr/>
      <form name="b64">
        <p>POSTed base64 data:</p>
        <textarea name="cipher" cols="80" rows="20">{$payload}</textarea><br/>
        <input name="decodeit" onclick="undoit()" type="button" value="Decode"/>
        
        <p>Decoded Text:</p>
        <textarea name="clear" cols="80" rows="20">???</textarea><br/>
        <input name="encodeit" onclick="doit()" type="button" value="Encode"/>
      </form>
    </body>
  </html>
};
