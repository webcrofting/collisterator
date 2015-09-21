class AddRoleIdToUser < ActiveRecord::Migration
  def up
    remove_column :users, :role
    add_column :users, :role_id, :integer
  end

  def down
    add_column :users, :role, :string
  end
end
