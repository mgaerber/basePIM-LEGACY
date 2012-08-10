module namespace _ = "http://basepim.org/maps";

declare function _:show(
  $item as item())
  as xs:string
{
  typeswitch($item)
    case map(*)
      return concat('map { ',
        string-join(
          for $k in map:keys($item)
          let $val := $item($k)
          return concat('"', $k, '":=', _:show-seq($val)),
        ', '),
      ' }')
    case node()
      return serialize($item)
    default
      return xs:string($item)
};

declare function _:show-seq(
  $seq as item()*)
  as xs:string
{
  if(empty($seq) or exists($seq[2]))
    then '(' || string-join(map(_:show#1, $seq), ', ') || ')'
    else _:show($seq)
};
