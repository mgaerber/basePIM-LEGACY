module namespace _ = "http://basepim.org/util/json";

(:~
 : Convert attributes to corresponding elements
 :
 : <node uuid="3445-aba44" type="product">
 : </node>
 :
 : will be converted to
 :
 : <node>
    <attributes>
        <uuid>3445-aba44</uuid>
        <type>product</type>
    </attributes>
 : </node>
 :)
declare function _:attr-to-elem(
  $elems as element()*,
  $wrapper as xs:string)
  as element()*
{
  for $elem in $elems
  return
    element {name($elem)} {
    
    (if($wrapper) then element {$wrapper}{ _:atts-to-elems($elem/@*) }
     else _:atts-to-elems($elem/@*)),
       $elem/text(),
      (
           for $n in $elem/*
            return _:attr-to-elem($n, $wrapper)
       )
       }
};

declare function _:atts-to-elems(
  $atts as attribute()*)
  as element()*
{
  for $a in $atts
  return element { name($a) } { data($a)}
};

(:~ 
 : Micheee’s convenience function as I am too stupid to get the
 : upper one working correctly for my purpose.
 : Converts even text() nodes, in order to preserve structure.
:)
declare function _:jsonatts(
  $element as element()*,
  $wrapper as xs:string)
{
  for $e in $element
  return element {name($e)}{ 
   if($e/@*) then  element {$wrapper} {
       for $inner in $e/@*
       return element  {name($inner)}
                       {$inner/string()}
   } else (),
  for $inner in $e/(*, text())
  return typeswitch($inner)
      case text() return <text>{$inner}</text>
      case element(*) return _:jsonatts($inner, $wrapper)
   default return ()
  }
};
