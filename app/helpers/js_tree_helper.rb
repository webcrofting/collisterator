module MyJSTreeHelper

	def get_children_for_root(all_items) 
		node_output = {} 
		
		node_output = add_children(1, all_items)
		
		return node_output
	end

	def add_children(parent_id, all_items) 
	
		data = {:data(get_item_data(parent_id))}
		data[:children] = children = []
		
		all_items.each_with_index do |item, index| 
			if (parent_id == item.Parent_ID)
				children << add_children(item.id, all_items)
			end
		
		end
	
		if children.empty?
			data.delete(:children)
		end
		return data
	end
	def 
end 