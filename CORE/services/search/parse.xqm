module namespace M = "http://basex.org/modules/parse";

(: Key for included search terms. :)
declare variable $M:INCLUDED := 'INCLUDED';
(: Key for excluded search terms. :)
declare variable $M:EXCLUDED := 'EXCLUDED';
(: Key for number of hits. :)
declare variable $M:HITS := 'HITS';
(: Key for database. :)
declare variable $M:DATABASE := 'DATABASE';
(: Fuzzy flag. :)
declare variable $M:FUZZY := 'FUZZY';

(:~
 : Parses the query string and additional parameters and
 : returns a map with all relevant information.
 : @param $query query keywords
 : @param $database database to be opened
 : @param $hits  number of hits to be returned
 : @param $fuzzy fuzzy flag
 :)
declare function M:parse(
    $query    as xs:string,
    $database as xs:string,
    $hits     as xs:string,
    $fuzzy    as xs:integer) as map(*) {

	let $p := analyze-string($query, '("[^"]+")')
	let $t := (
		$p//*:match/*:group ! replace(text(), '"', ''),
		$p//*:non-match ! tokenize(normalize-space(.), ' ')
	)
	return map {
	  $M:INCLUDED := $t[not(starts-with(., '-'))],
	  $M:EXCLUDED := $t[starts-with(., '-')] ! substring(., 2),
	  $M:HITS     := try { xs:int($hits) } catch * { 10000000 },
	  $M:DATABASE := $database,
	  $M:FUZZY    := boolean($fuzzy)
	}
};
