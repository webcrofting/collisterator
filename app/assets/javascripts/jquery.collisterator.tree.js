
var Collisterator = (function(Collisterator) 
	{
		Collisterator.templates = {};
		Collisterator.bindShowExampleListItem = function()
		{
			
      $(document).on("blur", ".example-trigger", function() 
				{			
				  var $header_container = $(".list-type-example-header");
					var $row_container = $(".list-type-example-row");
					var node = {};
          var default_data_string = $("#list-type-default-data").val();
          if(default_data_string)
          {
					  node.data = JSON.parse(default_data_string);
					  var template = $("#list-type-template-text").val();
					  $header_container.empty();
					  Collisterator.renderHeader($header_container, template);
					  $row_container.empty();
            Collisterator.renderNodeContentWithTemplate(node, $row_container, template);
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
		      data["name"] = data["display_name"].replace(/\W/g, '');
		      
		      var fields_array = [];
		      try
		      {
            var fields_definition_string = $("#list-type-fields-text").val();
            fields_array = JSON.parse(fields_definition_string);
		      }
		      catch(e)
		      {	      
		        console.log("no data yet");
		      }
		      fields_array.push(data);
		      $("#list-type-fields-text").val(JSON.stringify(fields_array));
		      
		      Collisterator.updateFieldsTable()
		      
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
							var url = "/items/" + data.token;
							window.location = url;
					});
				});
		};
		Collisterator.bindChangeListTypeType = function()
		{
		  $(document).on("change", ".list-type-type-selector", function() 
				{
					if($(".list-type-type-selector").val() == "custom")
					{
					  $("fieldset.customization-options").slideDown();
					}
					else
					{
					  $("fieldset.customization-options").slideUp();
					}
				});
		};

		Collisterator.bindCustomizeButton = function()
		{
								
			$(document).on("click", "#toggle-list-type-customization", function() 
			{
			  $("#list-type-customizations").slideToggle();			
			});
		};
		
		Collisterator.bindNewItem = function()
		{
								
			$(document).on("click", ".add_item", function() 
			{			
        var $anchor = $(this);
        var parentId = $anchor.attr('data-parent-id');
        //var parentId = parseInt($anchor.attr('data-parent-id'));
				$.post("/items.json", {'item[parent_id]': parentId},
					function(data) {
					$('#' + parentId).after(Collisterator.renderNodeContent(data, parentId));
	
				});
        
        
			});
													
				
		};
		Collisterator.buildListTree = function(id) 
		{
			var json_url = "/items/" + id + ".json";
			Collisterator.buildTree(json_url, id, true);
		};
		Collisterator.buildSampleTree = function(id)
		{
			var list_type_url = "/list_types/" + id + ".json";
			Collisterator.buildTree(list_type_url, id, false);
		};
		Collisterator.buildTree = function(json_url, id, is_list)
		{
			Collisterator.templates = new Array();
  		var $parent = $("#collisterator_tree");
	  	$parent.append('<table id="tree" class="table table-hover"><tbody>');
			$.getJSON(json_url, function(data)
				{
          if (is_list) {
  					var nodes;
	  				if(!$.isArray(data))
		  			{
			  			nodes = [data];
				  	}
					  else
					  {
						  nodes = data;
					  }
 
            Collisterator.renderTree(nodes, id);
            Collisterator.bindNewItem();
            Collisterator.bindDestroyItem();
          } else {
            Collisterator.renderSample(data);
          }

          $parent.append('</tbody></table>');
				}			
			); // end JSON

		};
		Collisterator.bindDestroyItem = function()
		{
			$(document).on("click", ".remove_item", function() {
				var itemID = $(this).closest('tr').attr('id');
        var itemURL = "/items/" + itemID;
        $('#' + itemID).remove();
        alert("Deleting item at : " + itemURL);
        
        $.post(itemURL, {_method: "DELETE"},
          function(data) {
          //NOTE: THIS FUNCTION DOESNT SEEM TO WORK PROPERLY.
          console.log("deletes item ok, but then this doesn't show.");
        });
       });
		};
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
  Collisterator.renderSample = function(nodes) 
  {
    var sample_array = nodes.sample_array;
    for (var i=0; i<sample_array.length; i++) {
      var $sample = $('<tr id="' + sample_array[i].list_type + '"/>');
      $sample.append(Mustache.render(sample_array[i].template, sample_array[i]));
      $('#tree > tbody').append($sample);
      $sample.editable({
        ajaxOptions: {
          dataType: 'json'
        }
      });
    }

  };  
	Collisterator.renderNodeButtons = function(node, $listItem) 
		{

			var template = Collisterator.templates[node.list_type_id];
			
			if (template && template.can_have_children) {
        if (!node.children || node.children.length == 0) {
          $listItem.append('<td><a href="#" class="add_item" data-parent-id="' + node.token + '"><i class="icon-plus"></i></a></td>');
        } else {
          var dummy ='<tr data-parent-id="' + node.token + '><td><a href="#" class="add_item"><i class="icon-plus"></i></a></td></tr>';
            $('#tree > tbody').append(dummy);
        }
       
			} 
			
			$listItem.append('<td><a href="#" class="remove_item"><i class="icon-remove"></i></a></td>');
			
			
		};
		
		Collisterator.renderNodeContent = function(node, parent_id)
		{
			var $listItem = $('<tr id="' + node.token + '"/>');
					
      if (parent_id) {
        $listItem.addClass('child-of-node-' + parent_id);
      }
					
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
      return $listItem;
		};

		Collisterator.renderHeader = function($header_container)
		{
		  try
		  {
		    var fields_definition_string = $("#list-type-fields-text").val();
		    var fields_array = JSON.parse(fields_definition_string);
		    for(var index in fields_array)
		    {
		      $header_container.append("<th>" + fields_array[index].display_name + "</th>");
		    }
		  }
		  catch(e)
		  {
		    console.log("no valid definition");
		  }

		};

		
		Collisterator.renderNodeContentWithTemplate = function(node, $listItem, template)
		{
		  $listItem.append(Mustache.render(template, node));
		  $listItem.find(".editable").each(function()
		  {
	      Collisterator.loadEditable($(this), node.token);
	    });
      Collisterator.renderNodeButtons(node, $listItem);
		};
		
		Collisterator.renderTree = function(nodes, parent_id)
		{

		    if(! (typeof nodes == 'undefined'))
		    {
		        for(var i = 0; i < nodes.length; i++)
		        {
		            var node = nodes[i];
					
                var $listItem = Collisterator.renderNodeContent(node, parent_id);
		            
                $('#tree > tbody').append($listItem);
                
                Collisterator.renderTree(node.children, node.token);
            }
		        
		    }

		};
		
		Collisterator.fields_table_template = "<tr><td>{{display_name}}</td><td>{{type}}</td><td>{{default}}</td></tr>";
		
		Collisterator.updateFieldsTable= function()
		{
		  try
		  {
		    var fields_definition_string = $("#list-type-fields-text").val();
		    var fields_array = JSON.parse(fields_definition_string);
		    var $container = $("#fields-table > tbody");
		    $container.empty();
		    for(var index in fields_array)
		    {
		      var row = Mustache.render(Collisterator.fields_table_template, fields_array[index]);
		      $container.append(row);
		    }
		  }
		  catch(e)
		  {
		    console.log("no valid definition");
		  }
		};
		Collisterator.showFieldsTable= function(fields_text) 
		{
		  try
		  {
			var fields_array = JSON.parse(fields_text);
			var template = "<tr><td>{{name}}</td><td>{{type}}</td><td>{{default}}</td></tr>";
			for(var index in fields_array) 
			{
			  var row = Mustache.render(template, fields_array[index]);
			  $('#fields-table').append(row);
			}
			
		  }
		  catch(e)
		  {
		    console.log("no valid definition");
		  }
		};
		Collisterator.initListTypeForm= function()
		{
		  Collisterator.bindShowExampleListItem();
		  Collisterator.bindAddField();
		  Collisterator.bindChangeListTypeType();
		  Collisterator.bindCustomizeButton();
		  Collisterator.updateFieldsTable();
		};
		
		return Collisterator;
	
	}(Collisterator || {}));



