# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 27) do

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
    t.integer "cash_discount_treshold", default: 50
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
    t.integer "cash_discount_treshold", default: 0
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "identifier"
    t.boolean "track_stock", default: false
    t.integer "stock_quantity", default: 0
    t.integer "inventory_threshold_notice"
    t.integer "inventory_threshold_warn"
  end

end
