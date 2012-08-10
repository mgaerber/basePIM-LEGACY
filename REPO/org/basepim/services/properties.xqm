module namespace _ = "http://basepim.org/services/properties"; 

(:~
: This function returns a condensed representation of <code>property</code> nodes.
: Beware that the returned <code>node</code> does not contain any reference to the <code>node</code> actually stored in the database.
: @param $type the workspace name
: @param $id the unique id of the property to fetch
:)
declare function _:get-slots(
  $type as xs:string,
  $id as xs:string)
  as element(node)
{
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
                    <slot-en>{$prop/value/slot[2]//text()}</slot-en>
                    <slot-de-id>{string($prop/value/slot[1]/@id)}</slot-de-id>
                    <slot-en-id>{string($prop/value/slot[2]/@id)}</slot-en-id>
                </property>
        }</node>
}; 
