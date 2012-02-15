declare option output:method "xml";
 declare function local:show($item as item()) {
  typeswitch($item)
    case map(*)
      return
          for $k in map:keys($item)
          let $val := $item($k)
          return element{$k}  {local:show-seq($val)}
    case node()
      return element{name($item)}{$item}
    default
      return element{"val"} {string($item)}
};

declare function local:show-seq($seq as item()*) {
  if(empty($seq) or exists($seq[2]))
    then (: <a>{count($seq)} </a> :) ()
    else local:show($seq)
};

let $uuid := $GET("guid"),  
(: $map := nodes:flatten-product(nodes:get-product($uuid)) :)
$prod := nodes:flatten-product(nodes:get-product($uuid))
return  <prod>{(local:show($prod))}</prod>
