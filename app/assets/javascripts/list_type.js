$(document).ready(function(){
 // e.preventDefault();
  propagateFields();
  bindAddFieldsToListType();
  bindFieldsChange();
});

var fields = [];
var fieldTemplate = 
        "{{=[[ ]]=}}\n" +
        "<td>\n" + 
        "  <span data-name='[[name]]' data-type='[[type]]' class='editable'>\n" +
        "    {{data.[[name]]}}\n" +
        "  </span>\n" +
        "</td>\n";

var fieldFormTemplate = 
  '<div class="form-group"><div id="group{{field_id}}">' +
  '<label class= "sr-only" for=field-name{{field_id}}">Field Name: </label>' +
  '<input class="form-control" id="field-name{{field_id}}" type="text"' +
  ' value="{{display_name}}" />' +
  '<label class="sr-only" for="field{{field_id}}">Default Data: </label>' +
  '<input class="form-control" value="{{default}}" id="field{{field_id}}"' +
  ' type="{{field_type}}" />' +
  '<select onChange="selectChange()" class="field-type form-control"' +
  'id="field-type{{field_id}}">' +
  '<option>text</option><option>number</option><option>date</option>' +
  '</div></div>';


  
var propagateFields = function () {
  var fields_text = $('#list_type_fields').attr('value');
  if (fields_text) {
    fields = JSON.parse(fields_text);
    for(var i=0; i<fields.length; i++) {
      //console.log(fields[i]);
      renderFieldForm(fields[i], i);
    }   
  } else {
    //initialize 
  }
} 

var bindAddFieldsToListType = function () {
  var next_id = fields.length;
  var default_data = {"display_name": "Field Name", "type": "text", 'default': "Default Data"};
  $(".add-field").click(function(e){
    e.preventDefault();

    fields.push(default_data);
    updateHiddenField();
    var newInput = renderFieldForm(default_data, next_id);
    $("#fields").append(newInput);

    //$("#field" + next).attr('data-source',$(addto).attr('data-source'));
    //$("#count").val(next);  
  });

};

var bindFieldsChange = function() {
  $("#fields").on("change", ".form-group", function(event) {
    var change = event.target.value;
    var field_edit = event.target.id.replace(/\d+/g, '');
    var id = event.target.id.replace(/\D/g, '');
    var field = fields[id];
    console.log("field to change? " + field["type"] + " : " + change);
    switch(field_edit) {
      case "field":
        field["default"] = change;
        break;
      case "field-name":
        field["display_name"] = change;
        break;
      case "field-type":
        field["type"] = change;
        updateFieldType(id, change);
        break;
    };
    updateHiddenField();
  });
}
var updateFieldType = function(id, type) {
  var options = ["text", "number", "date"];
  for(var i=0; i<options.length; i++) {
    if (type === options[i]) {
      $("#field" + id).attr("type", type);
      $("#field-type" + id).prop('selectedIndex', i);
    }
  }
}
var updateHiddenField = function () {
  $('#list_type_fields').val(JSON.stringify(fields));
}
var renderFieldForm = function(field_data, id) {
  var field = fieldsHTML(field_data, id);
  $("#fields").append(field);
  updateFieldType(id, field_data["type"]);
}

var fieldsHTML = function(field_data, id) {
  var data = field_data;
  data["field_id"] = id;
  var field = Mustache.render(fieldFormTemplate, data);   
  return field;
};

