import module namespace pim="http://basepim.org/lib" at "modules/pim.xqm";
import module namespace maps ="http://basepim.org/maps" at "modules/maps.xqm";


let $prod := db:open('xml-for-briefing')//workspace[@name = 'Produkte']
return
maps:show(
  pim:flatten($prod, 5)
)