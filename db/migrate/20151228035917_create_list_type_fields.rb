class CreateListTypeFields < ActiveRecord::Migration

  def change
    create_table :list_type_fields do |t|
      t.references :list_type
      t.string :name
      t.string :default_data
      t.integer :field_type
      t.integer :order

      t.timestamps null: false
    end
  end

end
