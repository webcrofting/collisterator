class AddFeaturedToListTypes < ActiveRecord::Migration
  def change
    add_column :list_types, :featured, :boolean, :default => false
  end
end
