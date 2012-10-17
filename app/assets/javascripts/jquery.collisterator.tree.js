Collisterator = 
	{
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
		renderNodeContent: function(node)
		{
			var new_child_of_node_link = '<a href="/items/new?parent_id=' + node.item_id  + '">New Child of Item</a>';
			var table_string = "<table style='display: inline-block'><tr><td>" + node.item_id + "</td><td class='edit'>" + node.data + "</td><td>" + new_child_of_node_link + "</td></tr></table>";
			
			return table_string;
		},
		renderTree: function($parent, nodes)
		{
			var $list = $('<ul id="list"/>');
			$parent.append($list);
			
			if(! (typeof nodes == 'undefined'))
			{
				for(var i = 0; i < nodes.length; i++)
				{
					var node = nodes[i];
					var $listItem = $('<li id=' + node.item_id + '/>');
					$list.append($listItem);
					$listItem.append(Collisterator.renderNodeContent(node));
					Collisterator.renderTree($list, node.children);
				}
			}
				
		}
	
	}



