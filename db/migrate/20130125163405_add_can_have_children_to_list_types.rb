class AddCanHaveChildrenToListTypes < ActiveRecord::Migration
  def change
	add_column :list_types, :can_have_children, :boolean
  end
end
