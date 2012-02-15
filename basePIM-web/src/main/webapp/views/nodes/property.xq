declare namespace xf="http://www.w3.org/2002/xforms";
declare option output:method "xml";

(: xmlns:ev="http://www.w3.org/2001/xml-events" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" :)
<xf:model>
  
{
 let $prop := ($nodes:db//property[@name = $GET("name") ])
 return  (
   <xf:instance>{$prop}</xf:instance>,
   for $node in $prop//slot/*/*
   return element {"xf:bind"}
      {
        attribute {"nodeset"} { 
          string-join(
            for $n in $node/ancestor-or-self::*[name(.) = ('value','slot','width','num','height','length')]
            return name($n),'/'
          )
        },
         attribute {"type"}  {
           let $name := name($node),
               $cand := string(doc('../demo-data/pim.rng')//element[@name = $name]/data/@type)
           return if(empty($cand)) then () else  "xs:" || $cand
         }
      }
   )
}
</xf:model>

