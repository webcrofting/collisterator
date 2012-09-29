class Item < ActiveRecord::Base
	
	acts_as_tree
	
	def as_json 
	
		item_to_json_hash(this)
	
	end
	
	def has_children?
		if self.children.empty?
			return false 
		end
		return true
	end
end
