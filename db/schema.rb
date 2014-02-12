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

ActiveRecord::Schema.define(version: 20140205191305) do

  create_table "features", force: true do |t|
    t.integer  "product_id"
    t.integer  "order"
    t.string   "title"
    t.string   "description"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fittings", force: true do |t|
    t.text     "description1"
    t.text     "description2"
    t.text     "description3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "type"
    t.string   "vendor"
    t.string   "handle"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "meta_title"
    t.string   "meta_description"
    t.integer  "fitting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products_tags", force: true do |t|
    t.integer "product_id"
    t.integer "tag_id"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variants", force: true do |t|
    t.integer  "product_id"
    t.string   "title"
    t.string   "size"
    t.string   "color"
    t.string   "other"
    t.string   "sku"
    t.integer  "price"
    t.integer  "quantity"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wholesaler_variants", force: true do |t|
    t.integer  "wholesaler_id"
    t.integer  "variant_id"
    t.string   "size"
    t.string   "color"
    t.string   "other"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wholesalers", force: true do |t|
    t.string   "type"
    t.integer  "product_id"
    t.string   "url"
    t.string   "other"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
