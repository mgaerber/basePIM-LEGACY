module namespace tpl = "http://basepim.org/tpl";

(:~

 :)
declare function tpl:transform-xsl($xml, $xsl) {
         (: xslt:transform($in, $style, <xslt:parameters><xslt:v>1</xslt:v></xslt:parameters>), :)
         (: xslt:transform($in, $style, map { "v" := 1 }) :)
         xslt:transform($xml, $xsl)
};

