class ListTypeField < ActiveRecord::Base
  enum field_type: [:text, :number, :date]

  belongs_to :list_type
  validates :list_type, presence: true

end
