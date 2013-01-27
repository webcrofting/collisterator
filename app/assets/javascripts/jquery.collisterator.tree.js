
var Collisterator = (function(Collisterator) 
	{
		Collisterator.templates = {};
		Collisterator.bindShowExampleListItem = function()
		{
			
      $(document).on("blur", ".example-trigger", function() 
				{			
					var $container = $(".list-type-example");
					var node = {};
          var default_data_string = $("#list-type-default-data").val();
          if(default_data_string)
          {
					  node.data = JSON.parse(default_data_string);
					  var template = $("#list-type-template-text").val();
					  $container.empty();
            Collisterator.renderNodeContentWithTemplate(node, $container, template);
          }
				});
		};
		Collisterator.bindAddField = function()
		{
		  var fieldTemplate = 
		    "{{=[[ ]]=}}\n" +
		    "<td data-name='[[name]]' data-type='[[type]]' class='editable'>\n" +
		    "  {{data.[[name]]}}\n" +
		    "</td>\n";
		    
		  $(document).on("click", "#new-field-form-submit", function()
		    {
		      var fieldArray = $("#new-field-form").serializeArray();
		      var data = {};
		      for(var i = 0; i < fieldArray.length; i++)
		      {
		        var field = fieldArray[i];
		        data[field.name] = field.value;
		      }
		      
		      var defaultTextArea = $("#list-type-default-data");
		      var defaultString = defaultTextArea.val();
		      var defaultData = defaultString ? JSON.parse(defaultString) : {};
		      defaultData[data['name']] = data['default'];
		      defaultTextArea.val(JSON.stringify(defaultData));
		      
		      var newFieldString = Mustache.render(fieldTemplate, data)
		      $textArea = $("#list-type-template-text");
		      $textArea.val($textArea.val() + newFieldString);
		      $textArea.blur();
		    });
		};

		Collisterator.bindCreateNewList = function()
		{
			$(document).on("click", ".new_list", function() 
				{			
					var list_type_id = $(this).attr("id");
					$.post("/items.json", {'item[list_type_id]': list_type_id},
					function(data) {
							var url = "/items/" + data.item_id;
							window.location = url;
					});
				});
		};
		Collisterator.bindNewItem = function()
		{
								
			$(document).on("click", ".add_item", function() 
			{			
				var $listItem = $(this).closest("tr");
				var parentIdString = $listItem.attr("id").slice(-1);
				var parentId = parseInt(parentIdString);
											
				$.post("/items.json", {'item[parent_id]': parentId},
					function(data) {
					Collisterator.renderTree($listItem, [data]);
	
				});
			});
													
				
		};
		Collisterator.buildTree = function(id)
		{
			Collisterator.templates = new Array();
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
					$parent.append('<table id="tree" class="table table-hover"><tbody>');
					Collisterator.renderTree($parent, nodes);
					$parent.append('</tbody></table>');
					Collisterator.bindNewItem();

				}			
			);

		};
		Collisterator.createJsonUrl= function(itemId)
		{
			var jsonUrl;
			if (itemId == -1) { // using this for "root of all nodes" - better -1 than 0 as 0 can be a legit id
				jsonUrl = "items.json"; // only works in the index.
			} else if (itemId > -1) {
				jsonUrl = "/items/" + itemId + ".json";
			}
			return jsonUrl; // One function exit point is debug friendlier
		};
		Collisterator.destroy = function(destroyItem, itemId)
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
						
		};
		/*bindDefaultValueEditable : function() 
		{
		  $(document).on("selectionChange","#new-field-form select.name=['type']", function()
		  {
			  var $element = $("#new-field-form-default");
			  $element.editable({
			      ajaxOptions: {
              type: 'put',
              dataType: 'json'
            },
			      url: urlForJeditable,
			      send: "always",
			      params: function(params) {
              
              newParams = {};
              newParams["item[data][" + $element.attr("data-name") + "]"] = params.value; 
              return newParams;
            } 
			  });
			});
			
		},*/

		Collisterator.loadEditable = function($element, node_id) 
		{
			var urlForJeditable = '/items/' + node_id;
			$element.editable({
			    ajaxOptions: {
            type: 'put',
            dataType: 'json'
          },
			    url: urlForJeditable,
			    send: "always",
			    params: function(params) {
            
            newParams = {};
            newParams["item[data][" + $element.attr("data-name") + "]"] = params.value; 
            return newParams;
          } 
			});
			
		};
		
		Collisterator.renderNodeButtons = function(node, $listItem) 
		{

			var template = Collisterator.templates[node.list_type_id];
			
			if (template.can_have_children) {
				$listItem.append('<td><a href="#" class="add_item"><i class="icon-plus"></i></a></td>');
			} else {
				console.log("in renderNodeButtons. this node cannot have children.");
			}
			
			$listItem.append('<td><a href="#" class="remove_item"><i class="icon-remove"></i></a></td>');
			
			Collisterator.renderTree($listItem, node.children);
			
		};
		Collisterator.renderNodeContent = function(node, $listItem)
		{
			
			if (Collisterator.templates[node.list_type_id]===undefined) 
			{
				var template_url = "/list_types/" + node.list_type_id + ".json";
				var test = $.getJSON(template_url, function(data) {
					Collisterator.templates[node.list_type_id] = data;
					Collisterator.renderNodeContentWithTemplate(node, $listItem, data.template);
				});
				
			}
			else
			{
			  var list_type = Collisterator.templates[node.list_type_id];
				Collisterator.renderNodeContentWithTemplate(node, $listItem, list_type.template);
			} 
			//Collisterator.renderTree($listItem, node.children);

		};
		
		Collisterator.renderNodeContentWithTemplate = function(node, $listItem, template)
		{
		  $listItem.append(Mustache.render(template, node));
		  $listItem.find(".editable").each(function()
		  {
	      Collisterator.loadEditable($(this), node.item_id);
	    });
		Collisterator.renderNodeButtons(node, $listItem);
		};
		
		Collisterator.renderTree = function($parent, nodes)
		{

		    if(! (typeof nodes == 'undefined'))
		    {
		        for(var i = 0; i < nodes.length; i++)
		        {
		            var node = nodes[i];
					
					var $listItem = $('<tr id="' + node.item_id + '"/>');
					
					//DELETE
					console.log("Node.parent_id = " + node.parent_id);
					
					if (node.parent_id) {
						$listItem = $('<tr id="' + node.item_id + '" class="child-of-node-' + node.parent_id + '"/>');
					}
		            Collisterator.renderNodeContent(node, $listItem);
		            //$list.append($listItem);
					$('#tree tbody:last').append($listItem);
					
		        }
		        
		    }

		};
		
		Collisterator.initListTypeForm= function()
		{
		  Collisterator.bindShowExampleListItem();
		  Collisterator.bindAddField();
		};
		
		return Collisterator;
	
	}(Collisterator || {}));



