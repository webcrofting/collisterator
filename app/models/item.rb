class Item < ActiveRecord::Base
	
	acts_as_tree
	
	def has_children?
		if self.children.empty?
			return false 
		end
		return true
	end
end
