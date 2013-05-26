class AddUserIdToListTypes < ActiveRecord::Migration
  def change
    add_column :list_types, :user_id, :integer	  
  end
end
