
var Collisterator = 
	{
		templates : {},
		bindShowExampleListItem: function()
		{
			var $triggerField = $(".example-trigger");
      $triggerField.live("blur", function() 
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
		},
		bindAddField: function()
		{
		  var fieldTemplate = 
		    "{{=[[ ]]=}}" +
		    "<td data-name='[[name]]' data-type='[[type]]' class='editable'>\n" +
		    "  {{data.[[name]]}}\n" +
		    "</td>\n";
		    
		  $("#new-field-form-submit").live("click", function()
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
		      $textArea.val($textArea.val() + "\n" + newFieldString);
		      $textArea.blur();
		    });
		},

		bindCreateNewList: function()
		{
			$(".new_list").live("click", function() 
				{			
					var list_type_id = $(this).attr("id");
					$.post("/items.json", {'item[list_type_id]': list_type_id},
					function(data) {
							var url = "/items/" + data.item_id;
							window.location = url;
					});
				});
		},
		bindNewItem : function()
		{
				$('.add_item').live("click", clickHandler);
				
				function clickHandler(click) 
					{
						if (click.handled !== true) 
							{
								var $listItem = $(this).closest("li");
								var parentId = $listItem.attr("id");
								$.post("/items.json", {'item[parent_id]': parentId}, function(data){
									Collisterator.renderTree($listItem, [data]);
								});
								click.handled=true;
							}
						return false;
					}
		},
		buildTree: function(id)
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
		/*bindDefaultValueEditable : function() 
		{
		  $("#new-field-form select.name=['type']").live("selectionChange", function()
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

		loadEditable : function($element, node_id) 
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
			
		},
		renderNodeContent: function(node, $listItem)
		{
			
			if (Collisterator.templates[node.list_type_id]===undefined) 
			{
				var template_url = "/list_types/" + node.list_type_id + ".json";
				var test = $.getJSON(template_url, function(data) {
					Collisterator.templates[node.list_type_id] = data.template;
					Collisterator.renderNodeContentWithTemplate(node, $listItem, data.template);
				});
				
			}
			else
			{
			  var template = Collisterator.templates[node.list_type_id];
				Collisterator.renderNodeContentWithTemplate(node, $listItem, template);
			} 
		},
		
		renderNodeContentWithTemplate: function(node, $listItem, template)
		{
		  $listItem.append(Mustache.render(template, node));
		  $listItem.find(".editable").each(function()
		  {
	      Collisterator.loadEditable($(this), node.item_id);
	    });
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

		},
		
		initListTypeForm: function()
		{
		  Collisterator.bindShowExampleListItem();
		  Collisterator.bindAddField();
		}
	
	}



