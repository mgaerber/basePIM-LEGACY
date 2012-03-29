module namespace util = "http://basepim.org/util";

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
declare function util:attr-to-elem($elem as element(), $wrapper as xs:string ) as element() {

    element {name($elem)} {
    
    (if($wrapper ne '') then element {$wrapper}{util:atts-to-elems($elem/@*)}
     else util:atts-to-elems($elem/@*)),
       $elem/text(),
      (
           for $n in $elem/*
            return util:attr-to-elem($n, $wrapper)
       )
       }
};

declare function util:atts-to-elems($atts as attribute()*) as element()* {

        for $a in $atts
                    return 
                        element { name($a) } { data($a)}
};


