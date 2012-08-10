module namespace _ = "http://basex.org/basePIM/xforms";

import module namespace tmpl = "http://basepim.org/services/xforms-template";
import module namespace nodes = "http://basepim.org/services/nodes";

declare namespace xf = "http://www.w3.org/2002/xforms";

(:~
: Edit a given Slot referenced by its unique ID
: The XForms templates are contained within the `../services/xforms-template.xqm` module, 
: in case a property without predefined template is found, a generic form will be returned to the user.
: @param $workspace the name of the workspace
: @uuid ID of the slot the edit
:)
declare
  %restxq:path("/xforms/edit-slot/{$workspace}/{$uuid}")
  %restxq:produces("application/xml")
  function _:edit-slot(
    $workspace as xs:string,
    $uuid as xs:string)
    as node()+
{
     let $slot  := nodes:get-slot-by-id($workspace, $uuid)
     let $prop  := trace($slot/ancestor::property, "Ancestor")
     let $binds :=
      switch(string($prop/@name))
        case "bezeichnung" return tmpl:bezeichnung-bind($uuid)
        case "dimensions"  return tmpl:dimensions-bind($uuid)
        case "gewicht"     return tmpl:gewicht-bind($uuid)
        default return ()
     let $form  := 
      switch($prop/@name)
        case "bezeichnung"	return tmpl:edit-bezeichnung($uuid)
        case "dimensions" 	return tmpl:edit-dimensions($uuid)
        case "gewicht"    	return tmpl:edit-gewicht($uuid)
        default 						return tmpl:edit-generic($uuid, $slot)
    return tmpl:body($workspace, $slot, $binds, $form)
};

(:~
: Dump the edited Slot to the browser.
: This function is used for debugging purposes only.
: @param $body the model
:)

declare
  %restxq:path("/xforms/dump")
  %restxq:POST("{$body}")
  %output:method("text")
  function _:dump(
    $body)
{
  <pre>{serialize($body)}</pre>
};

(:~
: Save the edited Slot to the given workspace.
: This function currently only allows replacing a <code> &lt;slot /&gt;</code> given by its uuid in a given workspace
: <a href="/restxq/docs/CORE*api*workspaces.xqm">See <em>workspace.xqm</em></a>.
: @param $body the model
: @param $workspace the workspace to save
:)

declare %updating
  %restxq:path("/xforms/dump/{$workspace}")
  %restxq:POST("{$body}")
  %output:method("xml")
  function _:dump(
    $body,
    $workspace as xs:string)
{
	db:output($body/slot),
		replace node  db:open($workspace)//slot[@id = $body/slot/@id]
	 with $body/slot
};

(:~
 : Returns a FilterBuilder based on given data
 : This is work in progress, and not finally working.
:)
declare
  %restxq:path("/xforms/filterbuilder/{$workspace}")
	%restxq:produces("application/xml")
  function _:filterbuilder(
    $workspace as xs:string)
    as node()+
{
	tmpl:filterbuilder($workspace)
};
