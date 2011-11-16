module namespace pim ="http://basepim.org/lib";

(:~ the database instance, this should be refactored :)
declare variable $pim:db := db:open('xml-for-briefing');

(:~
    Gets a single product identified by its uuid
    @param $uuid
    @return the product <node />
:)
declare function pim:get-product($uuid as xs:string) as element(node){
    $pim:db//node[@id eq $uuid]
}; 

(:~
    Flattens (i.e. dereferences all inherited properties) all nodes of a workspace.
    @param $ws the workspace to flatten
    @return a map() containing all products with their properties
:)
declare function pim:flatten-product($prod as element(node)) as map(*){
    let $ids := 
	   (for $id in 
	       //node[@id = $prod/@id]/ancestor::*/@id
        return string($id), $prod/@id)
    let $ws := $prod/ancestor::workspace
    return pim:flatten($ws, $ids)($prod/@id)
};

(:~
    Flattens (i.e. dereferences all inherited properties) all nodes of a workspace.
    @param $ws the workspace to flatten
    @return a map() containing all products with their properties
:)
declare function pim:flatten(
	$ws as element(workspace)) as map(*){
	pim:flatten($ws, (""))
};
(:~


:)
declare function pim:flatten(
  $ws as element(workspace),
  $filter as xs:string*
) as map(*) {

  fold-left(
    pim:flatten(?, ?, map:new(), tail($filter)),
    map:new(),
    if(head($filter)) then $ws/node[@id eq head($filter)]
    else $ws/node  )
};

declare function pim:flatten(
  $prods as map(*),
  $pr as element(node),
  $props as map(*),
  $filter as xs:string*
) as map(*) {
    (: let $trace := trace(( $pr/@id),"Products") :)
    
	  let $props := map:new(($props, pim:get-props($pr))),
	     $prods2 := map:new((
	       $prods,
	       map:entry($pr/@id,
	         map{
	           'name':=$pr/@name,
	           'type':=$pr/@type,
	           'properties':=$props
	         }
	       )
	     ))
	  return fold-left(
	      pim:flatten(?, ?, $props, tail($filter) (: - 1 :)),
	      $prods2,
	      if(head($filter)) then $pr/node[@id eq head($filter)]
	      else $pr/node
	    )
};
(:~
    Constructs the properties Map including a nodes referenced properties.
    @param $pr the current node
    @return a map consisting of the properties
:)
declare function pim:get-props(
  $pr as element(node)
) as map(*)* {
  let $refs := map:new( 
    (: get referenced properties :)
    for $_prop in $pr/property[@idref]
    let $prop := $pim:db//property[@id eq $_prop/@idref]
    return map:entry($prop/@name,
        map:new(
          for $lang in distinct-values($prop/value/slot/@lang)
          let $vals := $prop/value/slot[@lang = $lang]
          (: let $trace := trace(string-join($vals), "INH-VAL") :)
          let $map :=  pim:vals($vals)
          return map:entry(($lang, 'any')[1], $map)
      ) 
    ))
  let $direct := 
  map:new(
    for $prop in $pr/property[not(@idref)]
    return map:entry($prop/@name,
      map:new(
        for $lang in distinct-values($prop/value/slot/@lang)
        let $vals := $prop/value/slot[@lang = $lang]
        let $sl := trace(string-join($vals), "VAL") 
        let $map :=  pim:vals($vals)
        return map:entry(($lang, 'any')[1], $map)
      )
    )
  )
  return 
  if(map:size($refs)) then map:new(($refs, $direct))
  else $direct
};

declare function pim:vals($node){
  string-join($node, ", ")
};
