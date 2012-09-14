class Item < ActiveRecord::Base
	
	acts_as_tree
	
	
	def as_json(options={})
			recursively_render_items_as_json(self)	
	end
	
	def recursively_render_items_as_json(node)

		result = {}
		result[:data] = node.data
		result[:id] = node.id
		
		children = []
		
		
		if node.has_children?
			c = node.children
			c.each { |child|
				children << recursively_render_items_as_json(child)
			}
		end 
		
		unless children.empty? 
			result[:children] = children	
		end
		
		result
		
	end
	
	
	def has_children?
		if self.children.empty?
			return false 
		end
		return true
	end
end
