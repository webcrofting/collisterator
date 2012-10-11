var item_id_number; 

var buildJSTree = function(item_id_number) {
	this.item_id_number = item_id_number;
}

var json_url = function() {
	if (item_id_number===0) { // using this for "root of all nodes"
		return "items.json"; // only works in the index.
	} else if (item_id_number > 0) {
		return "/items/" + item_id_number + ".json";
	}
}

$(document).ready(function(){
	
	$("#collisterator_tree").jstree({
		core : { "html_titles" : true},
		plugins : ["themes", "json_data", "contextmenu"],
		themes : { "theme" : "classic" },
		"json_data" : {
			"ajax" : { 
				"url" : json_url,
				"data" : function(m) {
						var html_data = m.attr								
						return { id : html_data ? m.attr("id") : 0 };
					}
			}
		},
	})
});

