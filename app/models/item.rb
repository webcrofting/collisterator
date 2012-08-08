class Item < ActiveRecord::Base
	belongs_to :parent, class_name: "Item", foreign_key: "parent_id"
	has_many :children, class_name: "Item", foreign_key: "parent_id"
end
