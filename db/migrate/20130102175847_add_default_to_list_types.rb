class AddDefaultToListTypes < ActiveRecord::Migration
  def change
	add_column :list_types, :default, :integer
  end
end
