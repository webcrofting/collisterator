var JSTree = function(nodeNumber) {

	if (nodeNumber > 0) {
		$("#collisterator_tree").jstree({
			core : { "html_titles" : true },
			themes : { "theme" : "classic" },
			"json_data" : {
				"ajax" : { 
					"url" : "/items/" + nodeNumber + ".json",
					"data" : function(m) {
							var html_data = m.attr								
							return { id : html_data ? m.attr("id") : 0 };
						}
				}
			},
			plugins : ["themes", "json_data"]
		})
	}
} 

/**
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