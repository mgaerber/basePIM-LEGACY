#!/bin/sh
# Adds indices to selected databases into BaseX
# (C) 2012 Alexander Holupirek <ah@basex.org> 
for c in cmd_*.xml; do 
	echo "Run Command on database via REST call (input: $c)"
	l=`expr //$c : '.*/cmd_\(.*\)\.xml'`
	curl  -XPOST -T $c admin:admin@localhost:8984/rest/ws_$l;
done
# echo "Database path is defined in ../WEB-INF/web.xml:"
# grep -C1 org.basex.dbpath ../../WEB-INF/web.xml
# echo "List of databases (../../DATA):"
# ls ../../../DATA
