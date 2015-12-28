class ListType < ActiveRecord::Base
  belongs_to :user
  has_many :list_type_fields

  validates :name, presence: true
end
