class AddUsernameToItems < ActiveRecord::Migration
  def change
    add_column :items, :username, :string
  end
end
