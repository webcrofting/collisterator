class Item < ActiveRecord::Base
	acts_as_tree
	
	attr_accessible :data, :list_type_id
	
	serialize :data, JSON
	
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
		
		hash = {:item_id => item.id, :list_type_id => item.list_type_id, :data => item.data }
		
		children = []
		
		if (item.has_children?)
			children_collection = item.children
			children_collection.each do |child|
				children << item_to_json_hash(child)
			end
			
			hash[:children] = children
		end	
		
		return hash
	end
		

end
