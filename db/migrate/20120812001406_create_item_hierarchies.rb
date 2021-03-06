class CreateItemHierarchies < ActiveRecord::Migration
  def change
	  create_table :item_hierarchies, :id => false do |t|
		  t.integer :ancestor_id, :null => false 
		  t.integer :descendant_id, :null => false
		  t.integer :generations, :null => false
	  end

	  # For "all progeny of ... " selects:

	  add_index :item_hierarchies, [:ancestor_id, :descendant_id], :unique => true

	  # For "all ancestors of..." selects:

	  add_index :item_hierarchies, [:descendant_id]

  end
end
