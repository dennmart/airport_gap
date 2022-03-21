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

ActiveRecord::Schema[6.1].define(version: 2019_11_23_072206) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airports", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "country"
    t.string "iata"
    t.string "icao"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "altitude"
    t.string "timezone"
    t.index ["iata"], name: "index_airports_on_iata"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "airport_id"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.index ["token"], name: "index_users_on_token", unique: true
  end

end
