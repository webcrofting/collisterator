class ConvertDataToJson < ActiveRecord::Migration
  def up
    items = Item.find(:all)

    items.each do |i|
       i.data = "{\"text\": \"#{i.data}\"}"
       i.save
    end
  end

  def down
    items = Item.find(:all)

    items.each do |i|
       i.data = i.data.text
       i.save
    end
  end
end
