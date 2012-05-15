#!/bin/sh
# Loads workspace documents into BaseX
# (C) 2012 Alexander Holupirek <ah@basex.org> 
for i in ws_*.xml; do 
	echo "Create database via REST call (input: $i)"
	curl -s -XPUT -T $i admin:admin@localhost:8984/rest/${i%.*}; 
done
echo "Database path is defined in ../WEB-INF/web.xml:"
grep -C1 org.basex.dbpath ../../WEB-INF/web.xml
echo "List of databases (../../DATA):"
ls ../../../DATA
