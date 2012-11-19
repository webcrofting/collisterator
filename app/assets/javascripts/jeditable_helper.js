$('.editable').editable('/items/1', {
			method: "PUT",
			submit: 'OK',
			name: 'item[data]'
});
Helper = 
	{
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
	
