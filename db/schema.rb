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

ActiveRecord::Schema.define(version: 20150823192001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crew_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "crew_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "crew_requests", ["crew_id"], name: "index_crew_requests_on_crew_id", using: :btree
  add_index "crew_requests", ["user_id"], name: "index_crew_requests_on_user_id", using: :btree

  create_table "crews", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "size"
    t.integer  "listing_id"
    t.integer  "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "crews", ["admin_id"], name: "index_crews_on_admin_id", using: :btree
  add_index "crews", ["listing_id"], name: "index_crews_on_listing_id", using: :btree

  create_table "listings", force: :cascade do |t|
    t.string   "title"
    t.integer  "owner_id"
    t.integer  "price"
    t.string   "description"
    t.string   "policy"
    t.integer  "accommodates"
    t.integer  "bedrooms"
    t.float    "bathrooms"
    t.string   "images",       default: [],              array: true
    t.string   "amenities",                              array: true
    t.text     "address",      default: ""
    t.text     "address_2",    default: ""
    t.text     "city"
    t.text     "state"
    t.integer  "zipcode"
    t.text     "country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "listings", ["owner_id"], name: "index_listings_on_owner_id", using: :btree

  create_table "orbits", force: :cascade do |t|
    t.integer  "listing_id"
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "has_crew",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "orbits", ["listing_id"], name: "index_orbits_on_listing_id", using: :btree
  add_index "orbits", ["user_id", "listing_id"], name: "index_orbits_on_user_id_and_listing_id", unique: true, using: :btree
  add_index "orbits", ["user_id"], name: "index_orbits_on_user_id", using: :btree

  create_table "user_crew_memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "crew_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_crew_memberships", ["crew_id"], name: "index_user_crew_memberships_on_crew_id", using: :btree
  add_index "user_crew_memberships", ["user_id"], name: "index_user_crew_memberships_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",                            null: false
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
