declare option output:method "xml";
 declare function local:show($item as item()) as xs:string {
  typeswitch($item)
    case map(*)
      return concat('map { ',
        string-join(
          for $k in map:keys($item)
          let $val := $item($k)
          return concat('"', $k, '":=', local:show-seq($val)),
        ', '),
      ' }')
    case node()
      return serialize($item)
    default
      return xs:string($item)
};

declare function local:show-seq($seq as item()*) as xs:string {
  if(empty($seq) or exists($seq[2]))
    then '(' || string-join( $seq, ', ') || ')'
    else local:show($seq)
};

let $uuid := $GET("guid"),  
(: $map := pim:flatten-product(pim:get-product($uuid)) :)
$prod := pim:flatten-product(pim:get-product($uuid))
return local:show($prod)
