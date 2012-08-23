class Item < ActiveRecord::Base
	acts_as_tree
	
	def as_json(options={})
		super(:only => :label, :methods => :label, :include => {:children => {:only => :label, :methods => :label}})
	end
	
	def label
		self.data
	end
end
