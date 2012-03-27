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
    <_attributes>
        <uuid>3445-aba44</uuid>
        <type>product</type>
    </_attributes>
 : </node>
 :)
declare function util:attr-to-elem($elem as item()) as item() {

    let $has-attr := exists($elem/@*)
    
    return element {name($elem)} {
    
       <attributes>{
                for $a in $elem/(@*)
                    return 
                        element { name($a) } { data($a)}
       }</attributes>,
       $elem/text(),
      (
           for $n in $elem/node()
            return util:attr-to-elem($n)
       )
       }
};