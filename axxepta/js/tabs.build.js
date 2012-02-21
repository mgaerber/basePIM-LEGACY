// JavaScript Document


var loaded_tabs = [];
loaded_tabs['main'] = true;

// --------------------------------------------------------------------------------	

function tabBuild (element,name) {
	var refID = $(element).parent().attr('id');
	if (loaded_tabs[refID] != true) {
		
		var refNAME = name; //$(element).html();
		
		var output_tree = '<li id="tab_'
							+ refID + 
							'"><div class="tab_container" ref="'
							+ refID + 
							'"><h1>'
							+ refNAME +
							'</h1><a href="#" class="close_button" onclick="tabClose(this);"></a></div></li>'; 
		
		$('#tabs_main_list').append(output_tree);
		
		loaded_tabs[refID] = true;	
	}
	
}

// --------------------------------------------------------------------------------	

function tabClose(element) {
	var refID = $(element).parent().attr('ref');
	loaded_tabs[refID] = false;
	$('#tab_'+refID).remove();
}

// --------------------------------------------------------------------------------	