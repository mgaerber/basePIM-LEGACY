module namespace nodes = "http://basepim.org/nodes";

(:~ the database instance, this should be refactored :)
declare variable $nodes:db := <test></test>; (:db:open('ws_produkte'); :)
(:~
    Gets a single product identified by its uuid
    @param $uuid
    @return the product <node />
:)
declare function nodes:get-product($type as xs:string, $uuid as xs:string) as element(node){
    let $db := db:open($type)
    return $db//node[@id eq $uuid]
    
    (:<node>{
            element {"type"} {$type},
            element {"uuid"} {$uuid}
           }</node>
           :)
}; 

declare function nodes:get-product-by-name($type as xs:string, $name as xs:string) as element(node){
    let $db := db:open($type)
   return $db//node[@name eq $name]
   
}; 

(:~
    Flattens (i.e. dereferences all inherited properties) all nodes of a workspace.
    @param $ws the workspace to flatten
    @return a map() containing all products with their properties
:)
declare function nodes:flatten-product($prod as element(node)) as map(*){
    let $ids := 
	   (for $id in 
	       $nodes:db//node[@guid = $prod/@guid]/ancestor::*/@guid
        return string($id), $prod/@guid)
    let $ws := $prod/ancestor::workspace
    return nodes:flatten($ws, $ids)($prod/@guid)
};

(:~
    Flattens (i.e. dereferences all inherited properties) all nodes of a workspace.
    @param $ws the workspace to flatten
    @return a map() containing all products with their properties
:)
declare function nodes:flatten(
	$ws as element(workspace)) as map(*){
	nodes:flatten($ws, (""))
};
(:~


:)
declare function nodes:flatten(
  $ws as element(workspace),
  $filter as xs:string*
) as map(*) {

  fold-left(
    nodes:flatten(?, ?, map:new(), tail($filter)),
    map:new(),
    if(head($filter)) then $ws/node[@guid eq head($filter)]
    else $ws/node  )
};

declare function nodes:flatten(
  $prods as map(*),
  $pr as element(node),
  $props as map(*),
  $filter as xs:string*
) as map(*) {
    (: let $trace := trace(( $pr/@guid),"Products") :)
    
	  let $props := map:new(($props, nodes:get-props($pr))),
	     $prods2 := map:new((
	       $prods,
	       map:entry($pr/@guid,
	         map{
	           'name':=$pr/@name,
	           'type':=$pr/@type,
	           'properties':=$props
	         }
	       )
	     ))
	  return fold-left(
	      nodes:flatten(?, ?, $props, tail($filter) (: - 1 :)),
	      $prods2,
	      if(head($filter)) then $pr/node[@guid eq head($filter)]
	      else $pr/node
	    )
};
(:~
    Constructs the properties Map including a nodes referenced properties.
    @param $pr the current node
    @return a map consisting of the properties
:)
declare function nodes:get-props(
  $pr as element(node)
) as map(*)* {
  let $refs := map:new( 
    (: get referenced properties :)
    for $_prop in $pr/property[@guidref]
    let $prop := $nodes:db//property[@guid eq $_prop/@guidref]
    return map:entry($prop/@name,
        map:new(
          for $lang in distinct-values($prop/value/slot/@lang)
          let $vals := $prop/value/slot[@lang = $lang]
          (: let $trace := trace(string-join($vals), "INH-VAL") :)
          let $map :=  nodes:vals($vals)
          return map:entry(($lang, 'any')[1], $map)
      ) 
    ))
  let $direct := 
  map:new(
    for $prop in $pr/property[not(@guidref)]
    return map:entry($prop/@name,
      map:new(
        for $lang in distinct-values($prop/value/slot/@lang)
        let $vals := $prop/value/slot[@lang = $lang]
        let $sl := trace(string-join($vals), "VAL") 
        let $map :=  nodes:vals($vals)
        return map:entry(($lang, 'any')[1], $map)
      )
    )
  )
  return 
  if(map:size($refs)) then map:new(($refs, $direct))
  else $direct
};

declare function nodes:vals($node){
  string-join($node, ", ")
};

