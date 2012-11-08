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
					Helper.bindNewItem();

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
			});
			
			if($(destroyItem).is("li:first")) {
				window.location.replace("/items");	
			} else {
				$(destroyItem).closest('li').remove();
			}
			
		},
		renderNodeContent: function(node)
		{
			var table_string = 
			  "<table style='display: inline-block'>" + 
			    "<tr>" +
			      "<td>" + 
				node.item_id + 
                              "</td>" + 
                              "<td class='editable'>" + 
                                node.data + 
                              "</td>" +
                              "<td>" + 
                                Helper.getNewNode(node.item_id) + 
                              "</td>" +
                              "<td>" + 
                                Helper.getDeleteNode(node.item_id) +
                              "</td>" +
                             "</tr>" + 
                           "</table>";
			return table_string;
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
			    Helper.loadEditable($listItem.find(".editable"), node.item_id);
			    Collisterator.renderTree($listItem, node.children);
		        }
		        
		    }

		}
	
	}



