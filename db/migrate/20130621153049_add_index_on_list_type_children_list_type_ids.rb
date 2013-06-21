class AddIndexOnListTypeChildrenListTypeIds < ActiveRecord::Migration
  def up
    add_index :list_types, :children_list_type_id
  end

  def down
    remove_index :list_types, :children_list_type_id
  end
end
