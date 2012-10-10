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
		"contextmenu" : {
			
			"rename" : {
					"label" : "rename",
					"action" : function(obj) { this.rename(obj) }
			},
			"remove" : {
				"label" : "Delete",
				"action" : function(obj) { this.remove(obj) }
			},
			"create" : {
				"label" : "New Item",
				"action" : function(obj) { this.create(obj) }
			}	
		
		},
		plugins : ["themes", "json_data", "contextmenu"]
	})
});

/* Something like what I want?
function buildJSTree(item_id_number) {
	
	
	$(document).ready(function(){
		$("#collisterator_tree").jstree({
			core : { "html_titles" : true},
			themes : { "theme" : "classic" },
			plugins : ["themes", "json_data", "CRRM", "contextmenu"]

			"json_data" : {
				"ajax" : { 
					"url" : json_url,
					"data" : function(m) {
							var html_data = m.attr								
							return { id : html_data ? m.attr("id") : 0 };
						}
				}
			},
			
			"crrm" : {
				"input_width_limit" : 2000
			},
			"contextmenu" : {
				"rename" : {
					"label" : "Edit",
					"action" : function(obj) { this.rename(obj) },
				}
				"remove" : {
					"label" : "Delete",
					"action" : function(obj) { this.remove(obj) },
					
				}
				"create" : {
					"label" : "New Item",
					"action" : function(obj) { this.create(obj) },
				}
			
			},
		})
	});

}
*/

/**
Saw it written in stackoverflow as: 
	}).bind("rename.jstree create.jstree remove.jstree", function(event, data) {
		var type = event.type;
		alert(type)
		if (type === 'rename.jstree') {
			// handle move_node here
		} else if (type === 'create.jstree') {
			//handle rename jstree
		} else if (type === 'remove.jstree') {
			//handle create
		}
		
				$("#create_button").click(function() {
			$("collisterator_tree").jstree(null, "last", {data:title, attr: {id :item_id}}, null, false);
		}

		// blah blah blah close brackets

*/ 

/* This runs, but it never references buildJSTree and when I call it, I'm getting a "Reference 
   Error" that it is undefined...? 
   
   Also : url should be /items.json if in show view & items.json if on index.



$(document).ready(function(){
	$("#collisterator_tree").jstree({
		core : { "html_titles" : true},
		themes : { "theme" : "classic" },
		"json_data" : {
			"ajax" : { 
				"url" : "items.json",
				"data" : function(m) {
						var html_data = m.attr								
						return { id : html_data ? m.attr("id") : 0 };
					}
			}
		},
		plugins : ["themes", "json_data"]
	})
});

*/