Collisterator = 
	{
		 // or templates : []; ?? 
		templates : {},
		bindNewItem : function()
		{
				$('.add_item').live("click", function(){
				var $listItem = $(this).closest("li");
				var parentId = $listItem.attr("id");
				$.post("/items.json", {'item[parent_id]': parentId, 'item[data]': 'change me ...'}, function(data){
				Collisterator.renderTree($listItem, [data]);
				});
		
			});
		},
		buildTree: function(id)
		{
			templates = new Array();
			$.getJSON(Collisterator.createJsonUrl(id), function(data)
				{
					var nodes;
					if(!$.isArray(data))
					{
						nodes = [data];
					}
					else
					{
						nodes = data;
					}
					$parent = $("#collisterator_tree");
					Collisterator.renderTree($parent, nodes);
					Collisterator.bindNewItem();

				}			
			);

		},
		createJsonUrl: function(itemId)
		{
			var jsonUrl;
			if (itemId == -1) { // using this for "root of all nodes" - better -1 than 0 as 0 can be a legit id
				jsonUrl = "items.json"; // only works in the index.
			} else if (itemId > -1) {
				jsonUrl = "/items/" + itemId + ".json";
			}
			return jsonUrl; // One function exit point is debug friendlier
		},
		destroy: function(destroyItem, itemId)
		{

			var itemURL = "/items/" + itemId;
			$.post(itemURL, {_method: "DELETE"}, function(data) {
				alert("Data Loaded: " + data);
				if($(destroyItem).closest("ul").parent().is("li")) {
					$(destroyItem).closest('li').remove();
				} else {
					window.location.replace("/items");
				}
			},
			"json"
			);
						
		},
		// getTemplate: function(list_type_id) 
		// {
			// // should probably write in some protection for the cases
			// // when list_type_id itself is undefined
			// var template_url = "/list_types/" + list_type_id;
			// $.getJSON(template_url, function(data) {
				// templates[list_type_id] = data;
			// });
		// },
		loadEditable : function($element, node_id) 
		{
			var urlForJeditable = '/items/' + node_id;
			$element.editable(urlForJeditable, {
					method: 'PUT',
					submit: 'OK',
					name: 'item[data]'
			});
		},
		renderNodeContent: function(node, $listItem)
		{
			
			if (templates[node.list_type_id]===undefined) 
			{
				var template_url = "/list_types/" + node.list_type_id + ".json";
				var test = $.getJSON(template_url, function(data) {
					templates[node.list_type_id] = data.template;
					Collisterator.renderNodeContentWithTemplate(node, $listItem, data.template);
				});
				
			}
			else
			{
			  var template = templates[node.list_type_id];
				Collisterator.renderNodeContentWithTemplate(node, $listItem, template);
			} 
		},
		
		renderNodeContentWithTemplate: function(node, $listItem, template)
		{
		  $listItem.append(Mustache.render(template, node));
	    Collisterator.loadEditable($listItem.find(".editable"), node.item_id);
	    Collisterator.renderTree($listItem, node.children);
		},
		
		renderTree: function($parent, nodes)
		{
		    var $list = $parent.children("ul");
		    if($list.length == 0){ 
		      $list = $('<ul class="list"/>');
		      $parent.append($list);
		    }
		    
		    if(! (typeof nodes == 'undefined'))
		    {
		        for(var i = 0; i < nodes.length; i++)
		        {
		            var node = nodes[i];
					
		            var $listItem = $('<li id=' + node.item_id + '/>');
		            $list.append($listItem);
		            Collisterator.renderNodeContent(node, $listItem);
		        }
		        
		    }

		}
	
	}



