basePIM
=======

Welcome to **basePIM**. 

**basePIM** is a collaborative product information system.

Features
--------

* Flexible Storage
* Appealing web frontend
* Numerous Export
* Fully scriptable with XQuery
* t.b.a.

Requirements
------------

* [Java 1.6+](http://www.java.com/getjava/)
* [Apache Maven](http://maven.apache.org/)
* **basePIM** will run fine in 
	* Mozilla Firefox
	* Google Chrome
	* Microsoft Internet Explorer
	* Apple Safari

Installation
------------

1. Clone the project
2. Run [BaseX](http://basex.org/ "BaseX | The XML Database") with the following commands
3. `$ basex -c "REPO INSTALL /path/to/basePIM/src/main/webapp/basex-web-xq-1.0.1-distribution.zip"`
4. `$ basex -c "REPO INSTALL http://files.basex.org/xar/functx-1.0.xar"`
5. Start the web server via ``cd basePIM-web && mvn jetty:run``
6. Open [localhost:8080](http://localhost:8080) in a browser of your choice

License
-------

basePIM is licensed under [t.b.a.](http://www.opensource.org/licenses/alphabetical "Licenses by Name | Open Source Initiative")
