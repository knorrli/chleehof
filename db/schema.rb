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

ActiveRecord::Schema.define(version: 23) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "crypted_password"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "vat_percentage", precision: 8, scale: 2, default: "7.7"
    t.decimal "bulk_discount_percentage", precision: 8, scale: 2, default: "5.0"
    t.integer "bulk_discount_treshold", default: 300
    t.boolean "spring_discount_active", default: false
    t.decimal "spring_discount_percentage", precision: 8, scale: 2, default: "5.0"
    t.decimal "cash_discount_percentage", precision: 8, scale: 2, default: "3.0"
    t.string "vat_number"
    t.string "iban"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "customers", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "address_1"
    t.string "address_2"
    t.string "zip_code"
    t.string "city"
    t.string "phone"
    t.string "email"
    t.boolean "pay_cash"
    t.boolean "pick_up"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company"
  end

  create_table "order_items", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.decimal "price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_name"
    t.string "address_1"
    t.string "address_2"
    t.string "zip_code"
    t.string "city"
    t.string "company"
    t.integer "customer_id"
    t.decimal "vat_percentage", precision: 8, scale: 2
    t.decimal "vat_amount", precision: 8, scale: 2
    t.decimal "bulk_discount", precision: 8, scale: 2, default: "0.0"
    t.decimal "spring_discount", precision: 8, scale: 2, default: "0.0"
    t.decimal "shipping_cost", precision: 8, scale: 2, default: "0.0"
    t.decimal "cash_discount", precision: 8, scale: 2, default: "0.0"
    t.boolean "payed_cash", default: false
    t.integer "bulk_discount_treshold", default: 300
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "identifier"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

end
