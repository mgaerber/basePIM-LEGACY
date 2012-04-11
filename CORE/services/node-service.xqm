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
declare function nodes:get-slot-by-id($workspace as xs:string,
    $uuid as xs:string) as element(slot){
  db:open($workspace)//slot[@id = $uuid]
};
(:~
 : Returns a map containing all available languages for any given node’s properties.
 : The map contains the language as its key and the number of properties with a given language
 : as its value.
 : 
:)
declare function nodes:get-languages-for($node) as element(lang)+{
 let $langs :=
    for $val in $node/descendant-or-self::*/@lang 
    let $langs := fn:tokenize($val, " ")
    return
        for $lang in $langs
        return element { "lang" } { $lang }
   return for $lang in $langs
   group by $l := $lang/text()
   return element { "lang" }
    { (attribute { "count" } { fn:count($lang) }, $l) }
};
declare function nodes:get-property-for($workspace as xs:string,
  $produkt as xs:string,
  $property as xs:string) as element(property){
    db:open($workspace)//node[@name = $produkt]/property[@name = $property]
};
(:~
 :  Returns all Property children for a node with a given name.
 :
:)
declare function nodes:get-properties-for($workspace as xs:string,
  $nodename as xs:string) as element(property)*{
    db:open($workspace)//node[@name = $nodename]/property
};
declare function nodes:get-nodes-for($workspace as xs:string) as element(node)+{
    db:open($workspace)//node
};

(:
: returns a single node (no children)
: TODO: check no sequence is returned
:)
declare function nodes:get-product-by-name($type as xs:string, $name as xs:string) as element(node){
    let $db := db:open($type)
    let $node := $db//node[@name eq $name]
    let $child-count := count($node/node)
    return
        <node>
        {$node/@*, attribute {'children'}{$child-count},
        $node/* except $node/node
        }
        </node>
    (: return $node except $node/node :)
}; 

(:
: returns a single node with list of direct children (no properties)
: TODO: check no sequence is returned
:)
declare function nodes:get-product-meta-by-name($type as xs:string, $name as xs:string) as element(node){
    let $db := db:open($type)
    let $node := $db//node[@name eq $name]
    let $child-count := count($node/node)
    return
        <node>
        {$node/@*, attribute {'child-count'}{$child-count},
        <children>
            {for $child in $node/node
            return <node>{$child/@*, (if($child/node) then attribute {'children'}{} else ())
            }</node>}
        </children>
        }
        </node>
    (: return $node except $node/node :)
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

