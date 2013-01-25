class RemoveStatusFromItems < ActiveRecord::Migration
  def up
	remove_column :items, :status
  end

  def down
	add_column :items, :status, :string
  end
end
