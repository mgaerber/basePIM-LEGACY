	
createTree = function(ws, rootnode, divid, JsonRest, Tree, dndSource){
				
				workspace = JsonRest({
					target:"/restxq/ws/"+ws+"/nodej-meta/n/",
					mayHaveChildren: function(object){
						// see if it has a children property
						return "children" in object
						//return object.child-count > 0
					},
					getChildren: function(object, onComplete, onError){
						// retrieve the full copy of the object
						this.get(object.name).then(function(fullObject){
							// copy to the original object so it has the children array as well.
							object.children = fullObject.children;
							// now that full object, we should have an array of children
							onComplete(fullObject.children);
						}, function(error){
							// an error occurred, log it, and indicate no children
							console.error(error);
							onComplete([]);
						});
					},
					getRoot: function(onItem, onError){
						// get the root object, we will do a get() and callback the result
						//this.get("Motoren").then(onItem, onError);
						this.get(rootnode).then(onItem, onError);
						
					},
					getLabel: function(object){
						// just get the name
						return object.name;
					},
					
					pasteItem: function(child, oldParent, newParent, bCopy, insertIndex){
						var store = this;
						store.get(oldParent.id).then(function(oldParent){
							store.get(newParent.id).then(function(newParent){
								var oldChildren = oldParent.children;
								dojo.some(oldChildren, function(oldChild, i){
									if(oldChild.id == child.id){
										oldChildren.splice(i, 1);
										return true; // done
									}
								});
								store.put(oldParent);
								newParent.children.splice(insertIndex || 0, 0, child);
								store.put(newParent);
							}, function(error){
								alert("Error occurred (this demo is not hooked up to a real database, so this is expected): " + error);
							});
						});
					},
					put: function(object, options){
						this.onChildrenChange(object, object.children);
						this.onChange(object);
						return JsonRest.prototype.put.apply(this, arguments);
					},
					remove: function(id){
						// We call onDelete to signal to the tree to remove the child. The 
						// remove(id) gets and id, but onDelete expects an object, so we create 
						// a fake object that has an identity matching the id of the object we 
						// are removing.
						this.onDelete({id: id});
						// note that you could alternately wait for this inherited add function to 
						// finish (using .then()) if you don't want the event to fire until it is 
						// confirmed by the server
						return JsonRest.prototype.remove.apply(this, arguments);
					}
				});

	           var tree = new Tree({
					model: workspace,
					dndController: dndSource
				}, divid); // make sure you have a target HTML element with this id
				
				/*
				query("#add-new-child").on("click", function(){
					var selectedObject = tree.get("selectedItems")[0];
					if(!selectedObject){
						return alert("No object selected");
					}
					workspace.get(selectedObject.id).then(function(selectedObject){
						selectedObject.children.push({
							name: "New child",
							id: Math.random()
						});
						workspace.put(selectedObject);
					});
					
				});
				
				query("#remove").on("click", function(){
					var selectedObject = tree.get("selectedItems")[0];
					if(!selectedObject){
						return alert("No object selected");
					}
					workspace.remove(selectedObject.id);
				});
				
				tree.on("dblclick", function(object){
					object.name = prompt("Enter a new name for the object");
					workspace.put(object);
				}, true);
				*/
	return tree;
}