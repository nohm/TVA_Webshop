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

ActiveRecord::Schema.define(version: 20160308142002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "part_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "amount"
    t.boolean  "purchased",  default: false
  end

  create_table "categories", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "cimg_file_name"
    t.string   "cimg_content_type"
    t.integer  "cimg_file_size"
    t.datetime "cimg_updated_at"
    t.integer  "device_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
  end

  create_table "partdescriptions", force: :cascade do |t|
    t.integer "part_id"
    t.string  "title"
    t.string  "value"
  end

  create_table "partimages", force: :cascade do |t|
    t.integer  "part_id"
    t.string   "pimg_file_name"
    t.string   "pimg_content_type"
    t.integer  "pimg_file_size"
    t.datetime "pimg_updated_at"
  end

  create_table "parts", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "condition"
    t.string   "warranty"
    t.integer  "stock"
    t.decimal  "price_ex",                   precision: 10, scale: 2
    t.string   "partimagefull_file_name"
    t.string   "partimagefull_content_type"
    t.integer  "partimagefull_file_size"
    t.datetime "partimagefull_updated_at"
    t.integer  "device_id"
    t.string   "brand"
  end

  create_table "products", force: :cascade do |t|
    t.string   "brand"
    t.string   "type_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "device_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.integer  "role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
