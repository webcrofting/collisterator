$('.editable').editable('/items/1', {
			method: "PUT",
			submit: 'OK',
			name: 'item[data]'
});
Helper = 
	{
		getNewNode : function(node_id) 
			{
				return '<a class="add_item" href="#">New Child of Item</a>';
			},
		getDeleteNode: function(node_id)
			{
				return "<input type='button' onclick='Collisterator.destroy(this, " + node_id + ")' />";
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
	}
	
