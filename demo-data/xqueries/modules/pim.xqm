module namespace pim ="http://basepim.org/lib";

declare function pim:flatten(
	$ws as element(workspace)) as map(*){
	pim:flatten($ws, 1)
};

declare function pim:flatten(
  $ws as element(workspace),
  $height as xs:integer
) as map(*) {
  fold-left(
    pim:flatten(?, ?, map:new(), $height),
    map:new(),
    $ws/node
  )
};

declare function pim:flatten(
  $prods as map(*),
  $pr as element(node),
  $props as map(*),
  $height as xs:integer
) as map(*) {
	if($height ne 0) then
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
	      pim:flatten(?, ?, $props, $height - 1),
	      $prods2,
	      $pr/node
	    )
	  else
	  	$prods
};

declare function pim:get-props(
  $pr as element(node)
) as map(*)* {
  map:new(
    for $prop in $pr/property
    return map:entry($prop/@name,
      map:new(
        for $val in $prop/value
        return map:entry(($val/@lang, 'default')[1], $val/node())
      )
    )
  )
};


