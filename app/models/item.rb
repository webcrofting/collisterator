class Item < ActiveRecord::Base
	acts_as_tree
	has_many :list_types
	
	def as_json(options = nil)
	
		item_to_json_hash(self)
	
	end
	
	def has_children?
		if self.children.empty?
			return false 
		end
		return true
	end

	def item_to_json_hash(item)
		
		data = {:item_id => item.id, :data => item.data }
		
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
