var Collisterator = (function(Collisterator) 
  {
    Collisterator.list_types = [];
    
    Collisterator.statusOptions = "[{value: 0, text: '❓'}, {value: 1, text: '✔'}, {value: 1, text: '✘'}]";
    Collisterator.list_type_fields = function() 
    {
      var fields_text = $('#list_type_fields').attr('value');
      if (fields_text) 
      {
        console.log("List Type Fields found. " + fields_text);
        return JSON.parse(fields_text);
      }
      return [];
    };
    Collisterator.renderField = function (field, id) 
    {
      var fieldFormTemplate = 
        '<div class="form-group"><div id="group{{field_id}}">' +
        '<label class= "sr-only" for=field-name{{field_id}}">Field Name: </label>' +
        '<input class="form-control" id="field-name{{field_id}}" type="text"' +
        ' value="{{display_name}}" />' +
        '<label class="sr-only" for="field-data{{field_id}}">Default Data: </label>' +
        '<input class="form-control" value="{{default}}" id="field-data{{field_id}}"' +
        ' type="{{field_type}}" />' +
        '<select onChange="selectChange()" class="field-type form-control"' +
        'id="field-type{{field_id}}">' +
        '<option>text</option><option>number</option><option>date</option>' +
        '</div></div>';


      var data = field;
      data["field_id"] = id;
      var html = Mustache.render(fieldFormTemplate, data);
      $("#fields").append(html);

      Collisterator.updateFieldType(id, data["type"]);
    };
    Collisterator.renderFieldsForListType = function() 
    {
      var fields = Collisterator.list_type_fields();
      $.each(fields, function(i) {
        Collisterator.renderField(fields[i], i);
      });
    };
    Collisterator.bindAddField = function()
    {
      $(".add-field").click(function() {
        var fields = Collisterator.list_type_fields();
        var default_data = {"display_name": "Field Name", "type": "text", "default": "Default Data"};
        fields.push(default_data);
      
        //update hidden field 
        $("#list_type_fields").val(JSON.stringify(fields));
        
        var newField = Collisterator.renderField(default_data, fields.length-1);  
        $("#fields").append(newField);
      });
    };
    Collisterator.bindChangeField = function() 
    {
      $("#fields").on("change", ".form-group", function(event) {
        var fields = Collisterator.list_type_fields();
        
        var new_value = event.target.value;
        var edited_field = event.target.id.replace(/\d+/g, '');
        var id = event.target.id.replace(/\D/g, '');
        
        console.log("Element changed." + edited_field);
        var field = fields[id];
        switch(edited_field) {
          case "field-data":
            field["default"] = new_value;
            break;
          case "field-name":
            field["display_name"] = new_value;
            break;
          case "field-type":
            field["default"] = null;
            field["type"] = new_value;
            updateFieldType(id, new_value);
            break;
          default:
            console.log("calling default");
            break;
        }
        $("#list_type_fields").val(JSON.stringify(fields));  
      });
    };
    Collisterator.updateFieldType = function(id, type) 
    {
      var options = ["text", "number", "date"];
      $.each(options, function(i) {
        if (type === options[i]) {
          $("#field-data-" + id).attr("type", type);
          $("#field-type-" + id).prop('selectedIndex', i);
        }
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
    Collisterator.bindExpandCollapse = function()
    {
      $(document).on("click", ".collisterator-expander", function() 
      {
        Collisterator.expand($(this));
      });
      $(document).on("click", ".collisterator-collapser", function() 
      {
        Collisterator.collapse($(this));
      });
    };
    Collisterator.collapse = function($node)
    {
        var parent_id = $node.attr("data-tree-id");
        $("[data-tree-parent-id=" + parent_id + "]").hide();
        $node.addClass("collisterator-expander icon-plus-sign");
        $node.removeClass("collisterator-collapser icon-minus-sign");
    }
    Collisterator.expand = function($node)
    {
        var parent_id = $node.attr("data-tree-id");
        $("[data-tree-parent-id=" + parent_id + "]").show();
        $node.removeClass("collisterator-expander icon-plus-sign");
        $node.addClass("collisterator-collapser icon-minus-sign");
    }
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
        var depth = parseInt($anchor.attr('data-depth'));
        
        $.post("/items.json", {'item[parent_id]': parentId},
          function(data) {
          $("#" + parentId).add("[data-tree-parent-id=" + parentId +"]").last().after(Collisterator.renderNodeContent(data, parentId, depth + 1));
          $("#" + parentId).removeClass("leaf");
          Collisterator.expand($("#" + parentId + " .tree-control"));
        });
      });
    };
    Collisterator.buildListTree = function(id) 
    {
      var json_url = "/items/" + id + ".json";
      $.getJSON(json_url, function(data)
      {
        Collisterator.buildTree(data, $("#collisterator_tree"));
      });
    };
    Collisterator.buildSampleTree = function(list_type_id)
    {
      Collisterator.getListType(list_type_id, function(list_type){
        Collisterator.createSampleNode(list_type, -1, function(sample_node)
        {
          Collisterator.buildTree(sample_node, $("#collisterator_tree"), true);
        });
      });
    };
    Collisterator.buildTree = function(data, $parent, readonly)
    {
      $parent.append('<table id="tree" class="table table-hover"></table>');
      Collisterator.renderTree([data], null, 0);
      if(!readonly)
      {
        Collisterator.bindNewItem();
        Collisterator.bindDestroyItem();
      }
      $("[data-tree-parent-id]").hide(); // hides all but the root node
      Collisterator.bindExpandCollapse();
    };
    Collisterator.bindDestroyItem = function()
    {
      $(document).on("click", ".remove_item", function() {
        var itemID = $(this).closest('tr').attr('id'); //put id in attributes of link
        var $item = $('#' + itemID);
        var parent_id = $item.attr("data-tree-parent-id");
        var itemURL = "/items/" + itemID;
        
        $item.remove();
        if($("[data-tree-parent-id=" + parent_id + "]").size() == 0)
        {
          $("#" + parent_id).addClass("leaf");
        }
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
          emptytext: '---',
          send: "always",
          source: Collisterator.statusOptions,
          mode: "inline",
          params: function(params) {
            
            newParams = {};
            newParams["item[data][" + $element.attr("data-name") + "]"] = params.value; 
            return newParams;
          } 
      });
      
    };
    Collisterator.renderNodeButtons = function(node, $listItem, depth) 
    {

      var template = Collisterator.list_types[node.list_type_id];
      var indent_string = '';
      for(var i = 0; i < depth + 1; i++)
      {
        indent_string = indent_string + "<span style='width:2em; display: inline-block'>&nbsp;</span>";
      }

      
      var add_cell_string = '<td>' + indent_string + '<a href="#" class="add_item" data-parent-id="' + node.token + '" data-depth="' + depth + '"><i class="icon-plus"></i></a></td>';
      if (template && template.can_have_children) {
        if (true /*!node.children || node.children.length == 0*/ /*Set default for now until there is logic that moves plus button after adding fisrst child*/) {
          $listItem.append(add_cell_string);
        } else {
          var dummy ='<tr>' + add_cell_string + '</tr>';
            $('#tree').append(dummy);
        }
       
      } 
      
      if(depth)
      {
        $listItem.append('<td><a href="#" class="remove_item"><i class="icon-remove"></i></a></td>');
      }
    };
    
    Collisterator.renderNodeContent = function(node, parent_id, depth)
    {
      var $listItem = $('<tr id="' + node.token + '"/>');
      
      if (parent_id) {
        $listItem.attr('data-tree-parent-id', parent_id);
      }
      Collisterator.getListType(node.list_type_id, function(list_type)
      {
        Collisterator.renderNodeContentWithTemplate(node, $listItem, list_type.template, depth);
      });
      return $listItem;
    };
    
    Collisterator.getListType = function(list_type_id, callback /* function that gets the retrieved template as a parameter */)
    {
      if (Collisterator.list_types[list_type_id]===undefined) 
      {
        var template_url = "/list_types/" + list_type_id + ".json";
        $.getJSON(template_url, function(list_type) {
          Collisterator.list_types[list_type_id] = list_type;
          callback(list_type);
        });
        
      }
      else
      {
        var list_type = Collisterator.list_types[list_type_id];
        callback(list_type);
      } 
    }

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

    
    Collisterator.renderNodeContentWithTemplate = function(node, $listItem, template, depth)
    {
      $listItem.append(Mustache.render(template, node));
      var $first_column = $listItem.find("td").first();
      $first_column.prepend("<span class='indent-span'><i data-tree-id=" + node.token + " class='tree-control icon-plus-sign collisterator-expander'/>");
      
      if(!(node.children && node.children.length > 0))
      {
        $listItem.addClass("leaf");
      }
      
      for(var i = 0; i < depth; i++)
      {
        $first_column.prepend("<span class='indent-span'/>");
      }
      $listItem.find(".editable").each(function()
      {
        Collisterator.loadEditable($(this), node.token);
      });
      Collisterator.renderNodeButtons(node, $listItem, depth);
    };
    
    Collisterator.renderTree = function(nodes, parent_id, depth)
    {

        if(! (typeof nodes == 'undefined'))
        {
            for(var i = 0; i < nodes.length; i++)
            {
                var node = nodes[i];
          
                var $listItem = Collisterator.renderNodeContent(node, parent_id, depth);
                
                $('#tree').append($listItem);
                
                Collisterator.renderTree(node.children, node.token, depth + 1);
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
          $("#fields-table").css("display", "table");
          var row = Mustache.render(Collisterator.fields_table_template, fields_array[index]);
          $container.append(row);
        }
      }
      catch(e)
      {
        console.log("no valid definition");
        $("#fields-table").css("display", "none");
      }
    };
    Collisterator.showFieldsTable= function(fields_text) 
    {
      try
      {
      var fields_array = JSON.parse(fields_text);
      for(var index in fields_array) 
      {
        var row = Mustache.render(Collisterator.fields_table_template, fields_array[index]);
        $('#fields-table').append(row);
      }
      
      }
      catch(e)
      {
        console.log("no valid definition");
      }
    };
    Collisterator.createSampleNode = function(list_type, parent_list_type_id, callback)
    {
      var sample_node = {};
      sample_node.token = Math.random().toString(36).substring(2,7);
      sample_node.list_type_id = list_type.id;
      sample_node.data = JSON.parse(list_type.default_data);
      if(list_type.id !== parent_list_type_id && list_type.can_have_children)
      {
        Collisterator.getListType(list_type.children_list_type_id, function(child_list_type)
        {
          Collisterator.createSampleNode(child_list_type, list_type.id, function(child_node)
          {
            sample_node.children = [];
            var child_node_string = JSON.stringify(child_node);
            for(var i = 0; i < 3; i++)
            {
              var child_node_instance = JSON.parse(child_node_string);
              child_node_instance.token = Math.random().toString(36).substring(2,7);
              sample_node.children.push(child_node_instance);
            }
            callback(sample_node);
          });
        });
      }
      else
      {
        callback(sample_node);
      }
    };
    Collisterator.initListTypeForm= function()
    {
      Collisterator.renderFieldsForListType();
      Collisterator.bindAddField();
      Collisterator.bindChangeField();
    };
    
    return Collisterator;
  
  }(Collisterator || {}));



