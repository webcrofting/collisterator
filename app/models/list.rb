class List < ActiveRecord::Base
	attr_accessible :name, :description, :creator

	validates :name, :presence => true
	validates :creator, :presence => true
end
