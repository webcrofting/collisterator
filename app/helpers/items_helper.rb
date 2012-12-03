module ItemsHelper

	def item_to_json_hash(item)
		
		data = {:item_id => item.id, :list_type_id => item.list_type_id, :data => item.data}
		
		children = []
		
		if (item.has_children?)
			children_collection = item.children
			children_collection.each do |child|
				children << item_to_json_hash(child)
			end
			
			data[:children] = children
		end	
		
		return data
	end
	
	
	
end
