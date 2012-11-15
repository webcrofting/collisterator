# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121115002331) do

  create_table "item_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id",   :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations",   :null => false
  end

  add_index "item_hierarchies", ["ancestor_id", "descendant_id"], :name => "index_item_hierarchies_on_ancestor_id_and_descendant_id", :unique => true
  add_index "item_hierarchies", ["descendant_id"], :name => "index_item_hierarchies_on_descendant_id"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "status"
    t.integer  "parent_id"
  end

  create_table "list_types", :force => true do |t|
    t.string   "name"
    t.string   "template"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
