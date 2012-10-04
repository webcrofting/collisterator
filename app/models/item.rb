class Item < ActiveRecord::Base
	
	acts_as_tree
	
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
		
		data = {:item_id => item.id, :data => html_for_item_data(item)}
		
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
	
	def html_for_item_data(item)
		return %Q|<table style='display: inline-block'><tr><td>#{item.data}</td><td><a href="/items/new?parent_id=#{item.id}">New Child of Item</a></td></tr></table>|
	end
	

end
