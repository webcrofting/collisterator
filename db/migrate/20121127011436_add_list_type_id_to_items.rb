class AddListTypeIdToItems < ActiveRecord::Migration
  def change
		add_column :items, :list_type_id, :integer
  end
end
