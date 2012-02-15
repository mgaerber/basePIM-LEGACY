module namespace show-maps ="http://basepim.org/show-maps";

declare function show-maps:show($item as item()) as xs:string {
  typeswitch($item)
    case map(*)
      return concat('map { ',
        string-join(
          for $k in map:keys($item)
          let $val := $item($k)
          return concat('"', $k, '" := ', show-maps:show-seq($val)),
        ', '),
      ' }')
    case node()
      return serialize($item)
    default
      return xs:string($item)
};

declare function show-maps:show-seq($seq as item()*) as xs:string {
  if(empty($seq) or $seq[2])
  then '(' || string-join(
    for $s in $seq return show-maps:show($s), ', ') || ')'
  else show-maps:show($seq[1])
};
