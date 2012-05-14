module namespace nodes = "http://basepim.org/nodes";

(:~ the database instance, this should be refactored :)
declare variable $nodes:db := db:open('ws_produkte'); 

(: All properties have are strings only. :)
declare function nodes:stringify($nodes as element(node)+, $stringify as xs:boolean) as element(node)+{
	if($stringify) then 
		for $node in $nodes
		return element {"node"}{
			$node/@*,
			for $child in $node/*
			let $name := name($child)
			return switch($name)
				case "node" return $child ! nodes:stringify(., fn:true())
				case "property" return element	{"property"}
																				{$child/@*,
																				for $c in $child/value
																				return element{"value"} {
																					for $s in $c/slot
																					return  element{"slot"}{
																											attribute {"id"} {$s/@id},
																											$s/string()
																									}
																					}
																					(: function call child ! util:toString(.)) :)
																				}
				default return ()
		}
	else $nodes
};

(:~ Removes unwanted slots.
: @param $nodes the nodes
: @param $filter
:)
declare function nodes:filter($nodes as element(node)+, $filter as xs:string*) as element(node)+{
	if(count($filter)) then
		for $node in $nodes
		return element {"node"}{
			$node/@*,
			for $child in $node/*
			let $name := name($child)
			return switch($name)
				case "node" return $child ! nodes:filter(., $filter)
				case "property" return if($child/@name = $filter) then
				 																element	{"property"}
																				{$child/@*,
																				 $child/*}
																			else
																				()
				default return ()
		}
		else $nodes
};

(:~
: Gets a single product identified by its uuid
: @param $type the workspace to fetch data from
: @param $uuid the unique identifier of the node
: @return the product <node />
:)
declare function nodes:get($type as xs:string, $uuid as xs:string) as element(node){
    try {
			let $db := db:open($type)
    	return $db//node[@id eq $uuid]
		}catch * {
			 <node>Error!</node>
		}
};

(:~
: Gets a slot identified by its uuid
: @param $workspace the workspace to fetch the &lt;slot /&gt; from
: @param $uuid the unique identifier of the slot
: @return a slot
:)
declare function nodes:get-slot-by-id($workspace as xs:string,
    $uuid as xs:string) as element(slot){
  db:open($workspace)//slot[@id = $uuid]
};
(:~
 : Returns a map containing all available languages for any given node’s properties.
 : The map contains the language as its key and the number of properties with a given language
 : as its value.
 : @param $node the node to fetch
:)
declare function nodes:get-languages-for($node as element(node)) as element(lang)+{
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

(:~
: Gets a <code>property</code> identified by its uuid
: @param $workspace the workspace to fetch the &lt;property /&gt; from
: @param $nodename the nodes name <strong>should be changed to UUID</strong> *TODO*
: @param $property the property name
: @return a property
:)

declare function nodes:get-property-for($workspace as xs:string,
  $nodename as xs:string,
  $property as xs:string) as element(property){
    db:open($workspace)//node[@name = $nodename]/property[@name = $property]
};
(:~
:  Returns all properties for a <code>node</code> with a given name in a given <code>workspace</code>
: Gets a property identified by its uuid
: @param $workspace the workspace to fetch the <code>property</code> from
: @param $nodename the nodes name <strong>should be changed to UUID</strong> *TODO*
:)
declare function nodes:get-properties-for($workspace as xs:string,
  $nodename as xs:string) as element(property)*{
    db:open($workspace)//node[@name = $nodename]/property
};

(:~
: Returns all <code>nodes</code> in a given <code>workspace</code>
: @param $workspace the workspace to fetch the property from
:)
declare function nodes:get-nodes-for($workspace as xs:string) as element(node)+{
    db:open($workspace)//node
};

(:
: Returns a single, i.e. without children, <code>node</code> by name.
: <strong>TODO: check no sequence is returned</strong>
: @param $type the workspace name
: @param $nodename the name of the node
:)
declare function nodes:get-product-by-name($type as xs:string, $nodename as xs:string) as element(node){
    let $db := db:open($type)
    let $node := $db//node[@name eq $nodename]
    let $child-count := count($node/node)
    return
        <node>
        {$node/@*, attribute {'children'}{$child-count},
        $node/* except $node/node
        }
        </node>
}; 

(:
: Returns a condensed, i.e. only a list of children, <code>node</code> by name.

: @param $type the workspace name
: @param $nodename the name of the node
:)
declare function nodes:get-product-meta-by-name($type as xs:string, $nodename as xs:string) as element(node){
    let $db := db:open($type)
    let $node := $db//node[@name eq $nodename]
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
}; 

(:~
:	*TODO* für Michi: Vererbung -> eigenes Modul
:	=> WIP!	
:    Flattens (i.e. dereferences all inherited properties) all nodes of a workspace.
:    @param $ws the workspace to flatten
:    @return a map() containing all products with their properties
:)
declare function nodes:flatten-product($prod as element(node)) as map(*)?{
    let $ids := 
     (for $id in 
         $nodes:db//node[@id = $prod/@id]/ancestor::*/@id
        return string($id), $prod/@id
		)
    let $ws := $prod/ancestor::workspace
    return nodes:flatten($ws, $ids)($prod/@id)
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
    if(head($filter)) then $ws/node[@id eq head($filter)]
    else $ws/node  )
};

declare function nodes:flatten(
  $prods as map(*),
  $pr as element(node),
  $props as map(*),
  $filter as xs:string*
) as map(*) {
    let $props := map:new(($props, nodes:get-props($pr))),
				
       $prods2 := map:new((
         $prods,
         map:entry($pr/@id,
           map{
             'name':=$pr/@name,
             'type':=$pr/@type,
             'id':=$pr/@id,
             'properties':=$props
           }
         )
       ))
    return fold-left(
        nodes:flatten(?, ?, $props, tail($filter) (: - 1 :)),
        $prods2,
        if(head($filter)) then $pr/node[@id eq head($filter)]
        else $pr/node
      )
};
(:~
    Constructs the properties Map including a node’s referenced properties.
    @param $pr the current node
    @return a map consisting of the properties
:)
declare function nodes:get-props(
  $pr as element(node)
) as map(*)* {
  let $refs := map:new( 
    (: get referenced properties :)
    for $_prop in $pr/property[@idref]
    let $prop := $nodes:db//property[@id eq $_prop/@idref]
				(: $_ := trace($prop/@name/string(), "PROP") :)
    return if($prop/@name) then map:entry($prop/@name,
        map:new(
          for $lang in distinct-values($prop/value/slot/@lang)
          let $vals := $prop/value/slot[@lang = $lang]
          (: let $trace := trace(string-join($vals), "INH-VAL") :)
          let $map :=  nodes:vals($vals)
          return map:entry(($lang, 'any')[1], $map)
      ) 
    ) else ()
	)
  let $direct := 
  map:new(
    for $prop in $pr/property[not(@idref)]
    return map:entry($prop/@name,
      map:new(
				(: keep the language to allow per language overwrites of slots :)
        for $lang in distinct-values($prop/value/slot/@lang)
        let $vals := $prop/value/slot[@lang = $lang]
        let $map :=  $vals
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
(:~ 
: Serializes a map to a Node with Property->Slot hierarchies
:
~:)
declare function nodes:from-map($map as map(*)) as element(node){
	<node>{
	for $k in map:keys($map)
		where $k = ("name", "id", "type")
	return attribute {$k} {$map($k)}
	}
	{
		for $it in map:keys($map("properties"))
		let $item := $map("properties")($it)
		return <property>{
			attribute {"name"} {$it},
			for $kk in map:keys($item)
			return $item($kk)
		}</property>
	}
	</node>
};