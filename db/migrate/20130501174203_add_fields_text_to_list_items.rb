class AddFieldsTextToListItems < ActiveRecord::Migration
  def change
    add_column :list_types, :fields, :text
  end
end
