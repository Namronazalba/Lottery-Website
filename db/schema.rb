# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_09_13_045047) do

  create_table "add_bet_id_to_winners", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "addresses", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "street_address"
    t.string "phone_number"
    t.string "remark"
    t.boolean "is_default"
    t.bigint "region_id"
    t.bigint "province_id"
    t.bigint "city_id"
    t.bigint "barangay_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "genre"
    t.index ["barangay_id"], name: "index_addresses_on_barangay_id"
    t.index ["city_id"], name: "index_addresses_on_city_id"
    t.index ["province_id"], name: "index_addresses_on_province_id"
    t.index ["region_id"], name: "index_addresses_on_region_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "banners", charset: "utf8mb4", force: :cascade do |t|
    t.string "preview"
    t.datetime "online_at"
    t.datetime "offline_at"
    t.integer "status"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "barangays", charset: "utf8mb4", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "city_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_barangays_on_city_id"
  end

  create_table "bets", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "item_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "batch_count"
    t.integer "coins"
    t.string "state"
    t.string "serial_number"
    t.index ["item_id"], name: "index_bets_on_item_id"
    t.index ["user_id"], name: "index_bets_on_user_id"
  end

  create_table "categories", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
  end

  create_table "cities", charset: "utf8mb4", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "province_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["province_id"], name: "index_cities_on_province_id"
  end

  create_table "items", charset: "utf8mb4", force: :cascade do |t|
    t.string "image"
    t.string "name"
    t.integer "quantity"
    t.integer "minimum_bet"
    t.integer "batch_count", default: 0
    t.timestamp "online_at"
    t.timestamp "offline_at"
    t.timestamp "start_at"
    t.integer "status"
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "state"
    t.datetime "deleted_at"
    t.index ["category_id"], name: "index_items_on_category_id"
  end

  create_table "municipalities", charset: "utf8mb4", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "province_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["province_id"], name: "index_municipalities_on_province_id"
  end

  create_table "newstickers", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "admin_id"
    t.integer "status"
    t.string "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_newstickers_on_admin_id"
  end

  create_table "offers", charset: "utf8mb4", force: :cascade do |t|
    t.string "image"
    t.string "name"
    t.integer "genre"
    t.integer "status"
    t.integer "amount"
    t.integer "coin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "offer_id"
    t.string "serial_number"
    t.string "state"
    t.decimal "amount", precision: 10, default: "0"
    t.integer "coin"
    t.string "remarks"
    t.integer "genre"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["offer_id"], name: "index_orders_on_offer_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "provinces", charset: "utf8mb4", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "region_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["region_id"], name: "index_provinces_on_region_id"
  end

  create_table "regions", charset: "utf8mb4", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "region_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role", default: "client"
    t.string "phone"
    t.integer "coins"
    t.decimal "total_deposit", precision: 10
    t.integer "children_members"
    t.string "username"
    t.string "avatar"
    t.integer "parent_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "winners", charset: "utf8mb4", force: :cascade do |t|
    t.integer "item_id"
    t.integer "user_id"
    t.integer "address_id"
    t.integer "item_batch_count"
    t.string "state"
    t.integer "price"
    t.timestamp "paid_at"
    t.integer "admin_id"
    t.string "picture"
    t.string "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "bet_id"
  end

end
