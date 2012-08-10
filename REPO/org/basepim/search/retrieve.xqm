module namespace _ = "http://basepim.org/search/retrieve";

import module namespace parse = "http://basepim.org/search/parse";

(: Categories to search. :)
declare variable $_:CATEGORIES := ('slot');
(: Root node. :)
declare variable $_:ROOT := 'node';

(:~
 : Returns the requested hits.
 : @param $search search variables
 :)
declare function _:retrieve(
  $search as map(*))
{
  let $terms as xs:string* := $search($parse:INCLUDED)
  let $exc   as xs:string* := $search($parse:EXCLUDED)
  let $db    as xs:string  := $search($parse:DATABASE)
  let $hits  as xs:integer := $search($parse:HITS)
  let $fuzzy as xs:boolean := $search($parse:FUZZY)
  return (
    (: no search terms? show all results :)
    if(empty($terms)) then db:open($db)/descendant::*[name() = $_:ROOT][.//Text] else
    (: terms to be excluded? :)
    if(empty($exc)) then _:retrieve-fast($search)
    (: use full search? :)
    else _:retrieve-all($search)
  )[position() <= $hits]
};

(:~
 : Returns the requested hits, using a fast approach.
 : @param $search search variables
 :)
declare function _:retrieve-fast(
  $search as map(*))
{
  (: return one more result to indicate if more results follow :)
  let $results := _:retrieve($search, 'all')
  return if($results)
         then $results
         else _:retrieve-all($search)
};

(:~
 : Returns the requested hits.
 : @param $search search variables
 :)
declare function _:retrieve-all(
  $search as map(*))
{
  (: return one more result to indicate if more results follow :)
  let $fuzzy as xs:boolean := $search($parse:FUZZY)
  let $terms as xs:string* := $search($parse:INCLUDED)
  let $exc   as xs:string* := $search($parse:EXCLUDED)
  return
    (: check if all terms occur in the relevant categories :)
    _:retrieve($search, 'any')[
       let $s := string-join(*[name() = $_:CATEGORIES], ' ')
       return if($fuzzy)
              then ($s contains text { $terms } all using fuzzy
                         ftand ftnot { $exc} using fuzzy)
              else ($s contains text { $terms } all
                         ftand ftnot { $exc })]
};

(:~
 : Returns the requested hits.
 : @param $search search variables
 : @param $mode search mode
 :)
declare function _:retrieve(
  $search as map(*),
  $mode  as xs:string)
  as element()*
{
  let $db    as xs:string  := $search($parse:DATABASE)
  let $inc as xs:string* := $search($parse:INCLUDED)
  let $exc as xs:string* := $search($parse:EXCLUDED)
  let $fuzzy as xs:boolean := $search($parse:FUZZY)
  let $options := map { 'fuzzy' := $fuzzy, 'mode' := $mode }
  let $results := ft:search($db, $inc, $options)
  return (if(empty($results) or empty($exc))
         then $results
         else $results except ft:search($db, $exc, $options))
   /ancestor::*[name() = $_:CATEGORIES]/ancestor::*[name() = $_:ROOT]
};
