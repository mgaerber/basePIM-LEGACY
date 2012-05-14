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


