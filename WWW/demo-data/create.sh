#!/bin/sh
# Loads workspace documents into BaseX
# (C) 2012 Alexander Holupirek <ah@basex.org> 
for i in ws_*; do 
	echo "Create database via REST call (input: $i)"
	curl -s -XPUT -T $i admin:admin@localhost:8984/rest/${i%.*}; 
done
echo "Database path is defined in ../.basex:"
grep DBPATH ../.basex
echo "Databases (../data):"
ls ../data
