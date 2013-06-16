class RemoveUsernameFromItems < ActiveRecord::Migration
  def up
    remove_column :items, :username
  end

  def down
    add_column :items, :username, :string
  end
end
