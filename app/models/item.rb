class Item < ActiveRecord::Base
  belongs_to :list_type
  belongs_to :user
  belongs_to :parent, class_name: "Item"
  has_many :children, class_name: "Item", foreign_key: "parent_id", dependent: :nullify

  validates :list_type, presence: true

  before_create :generate_token

  serialize :data, JSON

  def as_json(options = nil)
    item_to_json_hash(self)
  end

  def generate_token
    begin
      token = SecureRandom.urlsafe_base64
    end while Item.where(:token => token).exists?
    self.token = token
  end

	def has_children?
		if self.children.empty?
			return false
		end
		return true
	end

	def item_to_json_hash(item)

		hash = {:token => item.token, :list_type_id => item.list_type_id, :data => item.data }

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
