class ChangeListType < ActiveRecord::Migration
  def change
	add_column :list_types, :can_be_root, :boolean
	add_column :list_types, :children_list_type_id, :integer
  end
end
