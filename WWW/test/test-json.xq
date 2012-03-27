
declare function local:node-to-json($node as element(node)) as xs:string{
     '{' ||
     '"guid":"'   || $node/@guid         || '",' ||
     '"type":"'   || $node/@type         || '",' ||
     '"length":"' || count($node/node)   || '"' ||
     (if(exists($node/node)) then ',' || local:nodelist-to-json($node/node, 'child') else '')
     || '}'    
};

declare function local:nodelist-to-json($nodes as element(node)*, $list-name as xs:string) as xs:string{
	 '"' || $list-name || '":[' ||
	string-join( for $n in $nodes
 	return local:node-to-json($n) , ',')
	 || ']'
};

db:list()

(:local:node-to-json(<node guid="272-d1e43053-341024-..." type="foo">
  <property name="name">
    <value>
      <slot lang="de">Schäkel Niro Aisi 316</slot>
    </value>
  </property>
  <node guid="372-c1e43011-741021-..." type="foo">
	  <property name="name">
	    <value>
	      <slot lang="de">Aki 6</slot>
	    </value>
	  </property>
  </node>
   <node guid="312-c1e33011-741021-..." type="foo">
	  <property name="name">
	    <value>
	      <slot lang="de">Oku 888</slot>
	    </value>
	  </property>
	    <node guid="812-c1e33011-741021-..." type="foo">
			  <property name="name">
			    <value>
			      <slot lang="de">Iki 8999</slot>
			    </value>
			  </property>
  </node>
  </node>
  </node>)
:)
