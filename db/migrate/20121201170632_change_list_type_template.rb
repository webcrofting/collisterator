class ChangeListTypeTemplate < ActiveRecord::Migration
  def up
	change_column :list_types, :template, :text, :limit => nil
  end

  def down
	change_column :list_types, :template, :string
  end
end
