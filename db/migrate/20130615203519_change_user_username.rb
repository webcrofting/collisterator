class ChangeUserUsername < ActiveRecord::Migration
  def up
    remove_index :users, :username
  end

  def down
    add_index :users, :username, :unique => true
  end
end
