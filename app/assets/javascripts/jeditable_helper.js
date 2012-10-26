$('.editable').editable('/items/1', {
			method: "PUT",
			submit: 'OK',
			name: 'item[data]'
});
Helper = 
	{
		getNewNode : function(node_id) 
			{
				return '<a href="/items/new?parent_id=' + node_id + '">New Child of Item</a>';
			},
		getDeleteNode: function(node_id)
			{
				return "<form class='button_to' method='post' action='/items/" + node_id + "' data-remote='true' onsubmit='window.location.reload()'><div><input name='_method' value='delete' type='hidden' /><input value='Destroy' type='submit' disable_with='loading...' data-confirm='Are you sure?' /></div></form>";
			},
		loadEditable : function(node_id) 
			{
				var urlForJeditable = '/items/' + node_id;
				$('.editable').editable(urlForJeditable, {
						method: 'PUT',
						submit: 'OK',
						name: 'item[data]'
				});
			},
	}
	