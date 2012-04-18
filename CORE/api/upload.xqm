xquery version "3.0";

module namespace  upload = "http://basex.org/basePIM/upload";
declare namespace rest   = "http://exquery.org/ns/restxq";

import module namespace file-service = "http://basex.org/basePIM/file-service" at "../services/file-service.xqm";

(:~
 : Test XMLHttpRequest GET functionality.
 :
 : Related website: WWW/test/put.html
 :)
declare
    %rest:GET
    %rest:path("/upload/file/get/answer/42")
    %output:method("text")
function upload:xmlhttprequest-get() {
    "We all know it. The answer is: 42"
};

(:~
 : Test XMLHttpRequest PUT functionality.
 :
 : Related website: WWW/test/put.html
 :)
declare
    %rest:PUT("{$data}")
    %rest:path("/upload/file/test/put/answer/{$value}")
    %output:method("text")
function upload:xmlhttprequest-get($data, $value) {
    concat("We all know it. The answer is: ", $value)
};

(:~
 : Test PUT (via curl) and return HTML.
 :
 : $ curl -s -i -X PUT -H "Content-Type: application/octet-stream" -T "./powermotor.png" "admin:admin@localhost:8984/restxq//upload/file/test/put/pm.png"
 :)
declare
    %rest:PUT("{$img}")
	%rest:path("/upload/file/test/put/{$name}")
	%output:method("html5")
function upload:put-file($name, $img) {
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
    %rest:GET
    %rest:path("/file/list")
    %output:method("text")
function upload:list-files() {
    db:list("ws_bilder")
};

(:~
 : Receives file data.
 :)
declare
    %rest:PUT("{$img}")
	%rest:path("/upload/image/put/{$name}")
updating function upload:put-image($name, $img) {
     db:store("ws_bilder", $name, $img)
};

(:~
 : Get POSTed images and other form data.
 :
 : Related website: WWW/test/dojo_file_upload.html
 :)
declare
    %rest:POST("{$payload}")
	%rest:path("/upload/file/post")
	%rest:form-param("title", "{$title}", "default title")
	%rest:form-param("year",  "{$year}",  "default year")
	%output:method("html5")
function upload:post-file($payload, $title, $year) {
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