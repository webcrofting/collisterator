module ListTypesHelper
	def list_by_list_type(list_id)
		
		@items = Item.roots
		@list_items = @items.select{ |item| item.list_type_id == list_id}
		
	end
	def new_list_html_attrs(list_id)
		{:href => '#', :class => 'new_list', :id => list_id}
	end
end
