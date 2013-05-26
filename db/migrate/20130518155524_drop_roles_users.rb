class DropRolesUsers < ActiveRecord::Migration
  def up
    drop_table :roles_users
  end

  def down
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
  end
end