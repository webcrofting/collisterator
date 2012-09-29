module ItemsHelper
	def item_to_json_hash()
		all_roots = Item.roots
		item_arr = []
		
		all_roots.each_with_index do |item, index|
			if (item.has_children?)
				c = item.children
				item_arr << add_children(item.id, c)
			else
				item_arr << add_children(item.id, nil)
			end
		end
			
		return item_arr
		
	end
	
	
	def add_children(parent_id, all_children) 
	
		data = {:item_id => parent_id, :data => get_item_data(parent_id)}
		
		children = []
		
		unless all_children.nil?
			
				all_children.each_with_index do |item, index|
				if (item.has_children?)
					c = item.children
					children << add_children(item.id, c)
				else
					children << add_children(item.id, nil)
				end
			end
			
			data[:children] = children
		
		end
		
		
		
		return data
	end
	
	def get_item_data(id)
		@item = Item.find(id)
		return @item.data
	end
end
