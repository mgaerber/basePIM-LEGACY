

require(["dojo/_base/xhr", "dojo/dom", "dojo/_base/array", "dojo/domReady!"],
    function(xhr, dom, arrayUtil) {
         
        // Keep hold of the container node
        var containerNode = dom.byId("newsContainerNode");
         
        // Using xhr.get, as we simply want to retrieve information
        xhr.get({
            // The URL of the request
            url: "get-news.php",
            // Handle the result as JSON data
            handleAs: "json",
            // The success handler
            load: function(jsonData) {
                // Create a local var to append content to
                var content = "";
                // For every news item we received...
                arrayUtil.forEach(jsonData.newsItems, function(newsItem) {
                    // Build data from the JSON
                    content += "<h2>" + newsItem.title + "</h2>";
                    content += "<p>" + newsItem.summary + "</p>";
                });
                // Set the content of the news node
                containerNode.innerHTML = content;
            },
            // The error handler
            error: function() {
                containerNode.innerHTML = "News is not available at this time."
            }
        });
         
});