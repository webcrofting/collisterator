class CreateItemShares < ActiveRecord::Migration
  def change
    create_table :item_shares do |t|
      t.integer :owner_id
      t.integer :item_id
      t.string :shared_user_email

      t.timestamps
    end
  end
end
