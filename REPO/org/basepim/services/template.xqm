module namespace _ = "http://basepim.org/services/template";

(:~
: This function handles XSL Transforms
: @param $xml input fragment
: @param $xsl XSL Template
:)
declare function _:transform-xsl(
  $xml,
  $xsl)
{
  (: xslt:transform($in, $style, <xslt:parameters><xslt:v>1</xslt:v></xslt:parameters>), :)
  (: xslt:transform($in, $style, map { "v" := 1 }) :)
  xslt:transform($xml, $xsl)
};
