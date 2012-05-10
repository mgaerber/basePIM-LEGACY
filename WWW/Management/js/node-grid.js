
createGrid = function(ws, id, divid, Memory, ObjectStore, DataGrid, registry, xhr, Dialog){
				
    var grid = registry.byId(divid);

		//url: "http://localhost:8984/restxq/ws/ws_bootsmotoren/n/36088-d1e365206-346297/slots.json",
	xhr.get({
		url: "http://localhost:8984/restxq/ws/"+ ws +"/n/"+id+"/slots.json",
		handleAs: "json"
	}).then(function(data){
		store = new Memory({ data: data.node });
		dataStore = new ObjectStore({ objectStore: store });
		
		if(grid === undefined){
		grid = new DataGrid({
			store: dataStore,
			query: { name: "*" },
			structure: [
				{ name: "Name", field: "name", width: "20%" },
				{ name: "Slot DE", field: "slot-de", width: "70%"},
				{ name: "Slot DE ID", field: "slot-de-id"}
			]
		}, divid);
	  console.dir(grid);
	  require(["dojo/_base/connect"], function(connect){
         connect.connect(grid, "onRowDblClick", null, function(e){
            _id = e.grid.store.getValue(e.grid.getItem(e.rowIndex), "slot-de-id" );
            _url = '/restxq/xforms/edit-slot/'+ ws +'/'+ _id;
             editDialog = Dialog({
                title: "Editing Slot #"+ _id,
                content: '<iframe src="'+ _url +'" width="100%" height="100%" />',
                style: "width: 85%;height:85%;"
                });
        editDialog.show();
        }, true);
    });
			// since we created this grid programmatically, call startup to render it
			grid.startup();
			}else{
				grid.setStore(dataStore);
			}
    });// end then()
			
return grid;
}
				

/*
			xmlStore = new XmlStore({
    			url: 'http://localhost:8984/restxq/ws/ws_bootsmotoren/n/36088-d1e365206-346297/slots.xml',
    			label: 'name',
    			rootItem: 'node'
			});
			
			grid = new DataGrid({
				store: xmlStore,
				query: {},
				structure: [
					{ name: "Name", field: "name" },
					{ name: "Slot DE", field: "slot-de"},
					{ name: "Slot DE ID", field: "slot-de-id"}
				]
			}, "grid");
			grid.startup();
*/				