class RenameDescription < ActiveRecord::Migration
  def change 
	rename_column :items, :description, :data
  end

  
end
