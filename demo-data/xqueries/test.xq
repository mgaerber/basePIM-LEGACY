import module namespace pim="http://basepim.org/lib" at "modules/pim.xqm";
import module namespace show-maps ="http://basepim.org/show-maps" at "modules/show-maps.xqm";

let $prod := $pim:db//workspace[@name = 'Produkte']
return
(:
Use this to flatten the whole Produkte workspace
 maps:show(
  pim:flatten($prod)
)  ,
:)
(: 
 Use this to flatten a single product
:)
show-maps:show(
	pim:flatten-product(pim:get-product("1-d1e257-340273-..."))
)