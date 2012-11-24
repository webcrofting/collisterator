Collisterator = 
	{
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
		loadEditable : function($element, node_id) 
		{
			var urlForJeditable = '/items/' + node_id;
			$element.editable(urlForJeditable, {
					method: 'PUT',
					submit: 'OK',
					name: 'item[data]'
			});
		},
		renderNodeContent: function(node)
		{
			var table_string = 
				"<table style='display: inline-block'>" + 
			    "<tr>" +
						"<td>" + 
							"{{item_id}}" +
                        "</td>" + 
                        "<td class='editable'>" + 
                                "{{data}}" + 
                         "</td>" +
                         "<td>" + 
							"<a class='add_item' href='#'>New Child of Item</a>" + 
                         "</td>" +
                         "<td>" + 
								"<input type='button' value='Destroy' onclick='Collisterator.destroy(this, {{item_id}})' />" +
                        "</td>" +
                 "</tr>" + 
                           "</table>";						   
			var output = Mustache.render(table_string, node);
			return output;
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
		            $listItem.append(Collisterator.renderNodeContent(node));
			    Collisterator.loadEditable($listItem.find(".editable"), node.item_id);
			    Collisterator.renderTree($listItem, node.children);
		        }
		        
		    }

		}
	
	}



