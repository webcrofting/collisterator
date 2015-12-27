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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150921112911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "item_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "item_hierarchies", ["ancestor_id", "descendant_id"], name: "index_item_hierarchies_on_ancestor_id_and_descendant_id", unique: true, using: :btree
  add_index "item_hierarchies", ["descendant_id"], name: "index_item_hierarchies_on_descendant_id", using: :btree

  create_table "item_shares", force: :cascade do |t|
    t.integer  "owner_id"
    t.integer  "item_id"
    t.string   "shared_user_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.string   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "list_type_id"
    t.string   "token"
    t.integer  "user_id"
  end

  create_table "list_types", force: :cascade do |t|
    t.string   "name"
    t.text     "template"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "can_be_root"
    t.integer  "children_list_type_id"
    t.string   "default_data"
    t.boolean  "can_have_children"
    t.text     "fields"
    t.integer  "user_id"
    t.boolean  "featured",              default: false
  end

  add_index "list_types", ["children_list_type_id"], name: "index_list_types_on_children_list_type_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.integer  "role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
