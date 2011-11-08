import module namespace pim="http://basepim.org/lib" at "modules/pim.xqm";
import module namespace maps ="http://basepim.org/maps" at "modules/maps.xqm";


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
maps:show(
	pim:flatten-product(pim:get-product("870ab68b-afc5-44d1-8e5f-8ba367b3c7fc"))
) 