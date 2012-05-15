module namespace jsonutil = "http://basepim.org/jsonutil";

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
declare function jsonutil:attr-to-elem($elems as element()+, $wrapper as xs:string ) as element()+ {
  for $elem in $elems
  return
    element {name($elem)} {
    
    (if($wrapper ne '') then element {$wrapper}{ jsonutil:atts-to-elems($elem/@*) }
     else jsonutil:atts-to-elems($elem/@*)),
       $elem/text(),
      (
           for $n in $elem/*
            return jsonutil:attr-to-elem($n, $wrapper)
       )
       }
};

declare function jsonutil:atts-to-elems($atts as attribute()*) as element()* {

        for $a in $atts
                    return 
                        element { name($a) } { data($a)}
};

(:~ 
: Micheee’s convenience function as I am too stupid to get the upper one working correctly for my purpose.
: Converts even text() nodes, in order to preserve structure.
:)
declare function jsonutil:jsonatts($element as element()+, $wrapper as xs:string){
  for $e in $element
    return element {name($e)}{ 
     if($e/@*) then  element {$wrapper} {
         for $inner in $e/@*
         return element  {name($inner)}
                         {$inner/string()}
     } else (),
    for $inner in $e/(*,  text())
      return typeswitch($inner)
          case text() return <text>{$inner}</text>
          case element(*) return jsonutil:jsonatts($inner, $wrapper)
       default return ()
    }
};