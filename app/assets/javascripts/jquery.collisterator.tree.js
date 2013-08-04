
var Collisterator = (function(Collisterator) 
  {
    Collisterator.list_types = new Array();
    
    Collisterator.statusOptions = "[{value: 0, text: '❓'}, {value: 1, text: '✔'}, {value: 1, text: '✘'}]";
    
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
    Collisterator.bindFieldTypeSelector = function()
    {
      $(document).on("change", "#new-field-type-selector", function()
      {
        var type = $("#new-field-type-selector").val();
        var $new_field_form_default = $("#new-field-form-default");
        console.log(type);
        $new_field_form_default.editable('destroy');
        $new_field_form_default.editable({
          type: type,
          source: Collisterator.statusOptions,
          autotext: "always",
          mode: "inline"
          });
      });
    };
    Collisterator.bindAddField = function()
    {
      var fieldTemplate = 
        "{{=[[ ]]=}}\n" +
        "<td>\n" + 
        "  <span data-name='[[name]]' data-type='[[type]]' class='editable'>\n" +
        "    {{data.[[name]]}}\n" +
        "  </span>\n" +
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
          data["default"] = $("#new-field-form-default").text().trim();
          
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
    Collisterator.bindExpandCollapse = function()
    {
      $(document).on("click", ".collisterator-expander", function() 
      {
        var parent_id = $(this).attr("data-tree-id");
        $("[data-tree-parent-id=" + parent_id + "]").show();
        $(this).removeClass("collisterator-expander icon-plus-sign");
        $(this).addClass("collisterator-collapser icon-minus-sign");
      });
      $(document).on("click", ".collisterator-collapser", function() 
      {
        var parent_id = $(this).attr("data-tree-id");
        $("[data-tree-parent-id=" + parent_id + "]").hide();
        $(this).addClass("collisterator-expander icon-plus-sign");
        $(this).removeClass("collisterator-collapser icon-minus-sign");
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
      console.log(JSON.stringify(data));
    
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
        var itemID = $(this).closest('tr').attr('id');
        var itemURL = "/items/" + itemID;
        $('#' + itemID).remove();
        
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
      
      if (template && template.can_have_children) {
        if (!node.children || node.children.length == 0) {
          $listItem.append('<td><a href="#" class="add_item" data-parent-id="' + node.token + '"><i class="icon-plus"></i></a></td>');
        } else {
          var dummy ='<tr data-parent-id="' + node.token + '"><td><a href="#" class="add_item"><i class="icon-plus"></i></a></td></tr>';
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
      var leaf_indent = 1;
      if(node.children && node.children.length > 0)
      {
        $first_column.prepend("<span style='width:2em; display: inline-block; text-align: right; padding-right:0.5em'><i data-tree-id=" + node.token + " class='icon-plus-sign collisterator-expander'/>");
        leaf_indent = 0;
      }
      for(var i = 0; i < depth + leaf_indent; i++)
      {
        $first_column.prepend("<span style='width:2em; display: inline-block'>&nbsp;</span>");
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
      Collisterator.bindShowExampleListItem();
      Collisterator.bindAddField();
      Collisterator.bindChangeListTypeType();
      Collisterator.bindCustomizeButton();
      Collisterator.bindFieldTypeSelector();
      Collisterator.updateFieldsTable();
    };
    
    return Collisterator;
  
  }(Collisterator || {}));



