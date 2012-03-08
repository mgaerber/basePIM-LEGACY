// JavaScript Document

var loaded_tree = [];
loaded_tree['main'] = false;

// --------------------------------------------------------------------------------	

function buildMainTree () {

	if (loaded_tree['main'] == false) {
	$.getJSON('http://phobos103.inf.uni-konstanz.de:8984/restxq/produkte/get-product', function(data) {
		var output_tree = '<ul id="main_tree">';
		$.each(data.categories, function(key, val) {
			output_tree = output_tree + LayoutOutputTree(val);
		});	
		output_tree = output_tree+'</ul>';
		$('#left_colm_content').append(output_tree);												  
	});
	loaded_tree['main'] = true;
	}
}

// --------------------------------------------------------------------------------	

function buildTree (element) {
	var parent_id = $(element).parent().attr('id');	
						
		if (loaded_tree[parent_id] != true) {
			$(element).addClass("loading");
			$.getJSON('request/jsonData.php?id='+parent_id, function(data) {															
				var output_tree = '<ul id="tree_'+ parent_id +'" class="sub_tree">';
				$.each(data.categories, function(key, val) { 
					output_tree = output_tree + LayoutOutputTree(val);	
				});	
				output_tree = output_tree+'</ul>';
				$('#'+parent_id).append(output_tree);
				$('#tree_'+ parent_id).slideDown("fast");
				$(element).removeClass("loading").addClass("open");
			});
			$('#tree_'+ parent_id + ' li:last-child').css({background:"none"});		
			loaded_tree[parent_id] = true;	
		}
		else {			
			if ($('#tree_'+ parent_id).is(':hidden')) { 
				$(element).removeClass("closed").addClass("open");
				$('#tree_'+ parent_id).slideDown("fast");
			} 
			else { 
				$('#tree_'+ parent_id).slideUp("fast"); 
				$(element).removeClass("open").addClass("closed");
			}
		}
		element.preventDefault();
}

// --------------------------------------------------------------------------------	

function LayoutOutputTree (element) {
	return	'<li id="' 
			+ element.id + 		
			'" class="list_tree"><span class="list_tree_element" onclick="buildTree(this);">' 
			+ element.name + 
			'</span><span class="open_tab" onclick="tabBuild(this,\'' + element.name + '\');">tab</span></li>';	
}


// --------------------------------------------------------------------------------	