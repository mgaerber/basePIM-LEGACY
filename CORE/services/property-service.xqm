module namespace properties = "http://basepim.org/properties";

(:

:)
declare function properties:get-slots($type as xs:string, $id as xs:string) as element(node){
    let $db := db:open($type)
    let $node := $db//node[@id eq $id]

    return
        <node>{
            for $prop in $node/property
                return 
                (: TODO: multi-value properties :)
                (: TODO: how to handle html fragments inside slots ? :)
                    <property>
                        <name>{string($prop/@name)}</name>
                        <slot-de>{$prop/value/slot[1]//text()}</slot-de>
                        <slot-de-id>{string($prop/value/slot[1]/@id)}</slot-de-id>
                    </property>
            }</node>

}; 
