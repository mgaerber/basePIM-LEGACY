module namespace _ = "http://basepim.org/search/parse";

(: Key for included search terms. :)
declare variable $_:INCLUDED := 'INCLUDED';
(: Key for excluded search terms. :)
declare variable $_:EXCLUDED := 'EXCLUDED';
(: Key for number of hits. :)
declare variable $_:HITS := 'HITS';
(: Key for database. :)
declare variable $_:DATABASE := 'DATABASE';
(: Fuzzy flag. :)
declare variable $_:FUZZY := 'FUZZY';

(:~
 : Parses the query string and additional parameters and
 : returns a map with all relevant information.
 : @param $query query keywords
 : @param $database database to be opened
 : @param $hits  number of hits to be returned
 : @param $fuzzy fuzzy flag
 :)
declare function _:parse(
  $query    as xs:string,
  $database as xs:string,
  $hits     as xs:string,
  $fuzzy    as xs:integer)
  as map(*)
{
	let $p := analyze-string($query, '("[^"]+")')
	let $t := (
		$p//*:match/*:group ! replace(text(), '"', ''),
		$p//*:non-match ! tokenize(normalize-space(.), ' ')
	)
	return map {
	  $_:INCLUDED := $t[not(starts-with(., '-'))],
	  $_:EXCLUDED := $t[starts-with(., '-')] ! substring(., 2),
	  $_:HITS     := try { xs:int($hits) } catch * { 10000000 },
	  $_:DATABASE := $database,
	  $_:FUZZY    := boolean($fuzzy)
	}
};
