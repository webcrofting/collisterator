class RemoveDefaultFromListTypes < ActiveRecord::Migration
  def up
	remove_column :list_types, :default
	add_column :list_types, :default_data, :string
  end

  def down
	add_column :list_types, :default, :integer
	remove_column :list_types, :default_data
  end
end
