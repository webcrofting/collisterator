class Item < ActiveRecord::Base
	
	acts_as_tree
	
	
	def as_json(options={})
			recursively_render_items_as_json(self)	
	end
	
	def recursively_render_items_as_json(node)

		result = {}
		result[:label] = node.label
		
		children = []
		
		
		if node.has_children?
			c = node.children
			c.each { |child|
				children << recursively_render_items_as_json(child)
			}
		end 
		
		result[:children] = children	
		
		result
		
	end
	
	
	def label
		self.data
	end
	
	def has_children?
		if self.children.empty?
			return false 
		end
		return true
	end
end
