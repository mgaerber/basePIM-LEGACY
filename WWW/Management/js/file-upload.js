  /* Startup code. */
  /*
            window.onload = function() {
                // Check for the various File API support.
                if (window.File && window.FileReader && window.FileList && window.Blob) {
                    // Great success! All the File APIs are supported.
                    init_dropbox();
                } else {
                    alert('The File APIs are not fully supported in this browser.');
                }
            };
*/
            
            /* DropBox */
            function init_dropbox() {
                var dropbox;  
      
                dropbox = document.getElementById("dropbox");  
                dropbox.addEventListener("dragenter", _dragenter, false);  
                dropbox.addEventListener("dragleave", _dragleave, false);
                dropbox.addEventListener("dragover", _dragover, false);
                dropbox.addEventListener("drop", _drop, false);
                
            }
            
            function _dragenter(e) {
               e.stopPropagation();
               e.preventDefault();
               var status = document.getElementById("upload-status-text");
               status.innerHTML = "<h3>Uhh, my god, here they come.</h3>";
            }
            
            function _dragover(e) {
               e.stopPropagation();
               e.preventDefault();
               var status = document.getElementById("upload-status-text");
               status.innerHTML = "<h3>Now, its there.</h3>";
            }
            
            function _dragleave(e) {
               e.stopPropagation();
               e.preventDefault();
               var status = document.getElementById("upload-status-text");
               status.innerHTML = "<h3>Oh noes, they are leaving.</h3>";
            }
            
            function _drop(e) {
                //alert("dropped");
                e.stopPropagation();
                e.preventDefault();
                
                var dt = e.dataTransfer;
                var files = dt.files;
              
                select_files(files);
                
            }
            
              /* Reacts on user choice and displays selected files. */
            function select_files(files) {
                var oSelectedFiles = document.getElementById('selected_files');
                var fileList = '<ul>';
                for (i = 0; i < files.length; i++) {
                    fileList += '<li>' + files[i].name + ', ' + files[i].lastModifiedDate + '</li>';
                }
                fileList += '</ul>';
                oSelectedFiles.innerHTML = fileList;
                // Preceed with loading files into memory.
                load_files(files);
            }
            /* Load selected files into memory and PUT them to DB server. */
            function load_files(files) {
             //alert("loop image");
                var holder = document.getElementById('list');
                while(holder.hasChildNodes()){
                	holder.removeChild(holder.lastChild);
                }
                
                // Loop through FileList Object.
                for (var i = 0, f; f = files[i]; i++) {
                    // Only process image files.
                  /*  if (!f.type.match('image.*')) {
                      continue;
                    }*/
                   
                    var reader = new FileReader();
                    //alert("in the loop");
                    // Closure to capture the file information.
                    reader.onload = (function(theFile) {
                        return function(e) {
                            //alert("reader load");
                            // Render thumbnail.
                            var span = document.createElement('span');
                            var fdataURL = e.target.result
                            var fname = escape(theFile.name)
                            span.innerHTML = ['<img class="thumb" src="', fdataURL,
                                              '" title="', fname, '"/>'].join('');
                            document.getElementById('list').insertBefore(span, null);
                            // Send to server (as DataURL, data:image/jpeg;base64,/9j/4Sd+RXhpZgAAS...)
                            var fblob = dataURL_to_blob(fdataURL);
                            put_file(fblob, fname);
                           // alert("putted file");
                        };
                    })(f);
                    // Read in the image file as a dataURL.
                    reader.readAsDataURL(f);
                }
            }
            /* Uploads file data via XHR and PUT. */
            function put_file(data, name) {
              // alert("put" + data.toString());
               var xhReq = new XMLHttpRequest();
                xhReq.open("PUT", "/restxq/upload/image/put/" + name, true);
                xhReq.setRequestHeader('Content-Type', 'application/octet-stream');
                xhReq.onreadystatechange = function() {
                    if (xhReq.readyState != 4)  {
                        //alert("Not ready yet.");
                        return;
                    }
                    /* Server is ready, files have been uploaded.
                     * Since we use an 'updating function' in XQuery, no server
                     * response can be expected. Therefore, we explicitly request (GET)
                     * the information of what is stored in the server.
                     */
                };
                xhReq.send(data);
            }
            /* Converts file read as dataURL (reader.readAsDataURL(f);) to blob.
             * DataURL: data:image/jpeg;base64,/9j/4Sd+RXhpZgAAS...
             */
            function dataURL_to_blob(dataURI) {
                // convert base64 to raw binary data held in a string
                // doesn't handle URLEncoded DataURIs - see SO answer #6850276 for code that does this
                var byteString = atob(dataURI.split(',')[1]);

                // separate out the mime component
                var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
            
                // write the bytes of the string to an ArrayBuffer
                var ab = new ArrayBuffer(byteString.length);
                var ia = new Uint8Array(ab);
                for (var i = 0; i < byteString.length; i++) {
                    ia[i] = byteString.charCodeAt(i);
                }
                
                // write the ArrayBuffer to a blob, and you're done
                if (window.BlobBuilder) {
                  bb = new BlobBuilder();
                } else if (window.WebKitBlobBuilder) {
                  bb = new WebKitBlobBuilder();
                } else if (window.MozBlobBuilder) {
                  bb = new MozBlobBuilder();
                } else if (window.MSBlobBuilder) {
                  bb = new MSBlobBuilder();
                }
                bb.append(ab);
                return bb.getBlob(mimeString);
            }
            /* Lists files. */
            function list_files() {
                var xhReq = new XMLHttpRequest();
                xhReq.open("GET", "/restxq/file/list", false);
                 xhReq.onreadystatechange = function() {
                    if (xhReq.readyState != 4)  {
                        return;
                    }
                    var serverResponse = xhReq.responseText;
                    alert(serverResponse); // Shows "PUTvalue sent back from server"
                };
                xhReq.send(null);
            }