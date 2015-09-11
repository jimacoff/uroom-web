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

ActiveRecord::Schema.define(version: 20150910235356) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",     default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["unlock_token"], name: "index_admins_on_unlock_token", unique: true, using: :btree

  create_table "chats", force: :cascade do |t|
    t.integer  "crew_id"
    t.boolean  "includes_landlord", default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "chats", ["crew_id"], name: "index_chats_on_crew_id", using: :btree

  create_table "crew_approval_requests", force: :cascade do |t|
    t.integer  "crew_id",                     null: false
    t.integer  "listing_id",                  null: false
    t.integer  "landlord_id",                 null: false
    t.boolean  "accepted",    default: false
    t.boolean  "rejected",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "crew_approval_requests", ["crew_id"], name: "index_crew_approval_requests_on_crew_id", using: :btree
  add_index "crew_approval_requests", ["landlord_id"], name: "index_crew_approval_requests_on_landlord_id", using: :btree
  add_index "crew_approval_requests", ["listing_id"], name: "index_crew_approval_requests_on_listing_id", using: :btree

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
    t.integer  "lease_length"
    t.integer  "size"
    t.boolean  "ready_to_land", default: false
    t.boolean  "approved",      default: false
    t.boolean  "landed",        default: false
    t.integer  "listing_id"
    t.integer  "crew_admin_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "crews", ["crew_admin_id"], name: "index_crews_on_crew_admin_id", using: :btree
  add_index "crews", ["listing_id"], name: "index_crews_on_listing_id", using: :btree

  create_table "lease_transactions", force: :cascade do |t|
    t.string   "description",                                             null: false
    t.decimal  "amount",          precision: 8, scale: 2,                 null: false
    t.date     "applicable_date"
    t.date     "due_date"
    t.integer  "listing_id"
    t.text     "unit_address",                                            null: false
    t.integer  "user_id"
    t.text     "tenant_name",                                             null: false
    t.text     "tenant_email",                                            null: false
    t.integer  "landlord_id"
    t.text     "landlord_name",                                           null: false
    t.text     "landlord_email",                                          null: false
    t.boolean  "paid",                                    default: false
    t.text     "payment_method"
    t.date     "paid_date"
    t.text     "street_address"
    t.text     "locality"
    t.text     "region"
    t.integer  "postal_code"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "lease_transactions", ["landlord_id"], name: "index_lease_transactions_on_landlord_id", using: :btree
  add_index "lease_transactions", ["listing_id"], name: "index_lease_transactions_on_listing_id", using: :btree
  add_index "lease_transactions", ["user_id"], name: "index_lease_transactions_on_user_id", using: :btree

  create_table "listings", force: :cascade do |t|
    t.string   "title"
    t.integer  "owner_id"
    t.decimal  "price",               precision: 15, scale: 2
    t.decimal  "security_deposit",    precision: 15, scale: 2
    t.boolean  "active",                                       default: false
    t.string   "description"
    t.string   "policy"
    t.boolean  "furnished",                                    default: false
    t.integer  "accommodates"
    t.integer  "bedrooms"
    t.float    "bathrooms"
    t.text     "images",                                       default: [],                          array: true
    t.text     "included_appliances",                          default: "None"
    t.text     "pet_policy",                                   default: "Allowed"
    t.text     "utility_notes",                                default: ""
    t.text     "parking_notes",                                default: "Not included"
    t.text     "address",                                      default: ""
    t.text     "address_2",                                    default: ""
    t.text     "city"
    t.text     "state"
    t.integer  "zipcode"
    t.text     "country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  add_index "listings", ["active"], name: "index_listings_on_active", using: :btree
  add_index "listings", ["owner_id"], name: "index_listings_on_owner_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "text",       default: ""
    t.integer  "chat_id"
    t.integer  "sender_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "messages", ["chat_id"], name: "index_messages_on_chat_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "orbits", force: :cascade do |t|
    t.integer  "listing_id"
    t.integer  "user_id"
    t.integer  "crew_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "number_of_roommates"
    t.boolean  "has_crew",            default: false
    t.boolean  "ready_to_land",       default: false
    t.boolean  "landed",              default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "orbits", ["crew_id"], name: "index_orbits_on_crew_id", using: :btree
  add_index "orbits", ["end_date"], name: "index_orbits_on_end_date", using: :btree
  add_index "orbits", ["has_crew"], name: "index_orbits_on_has_crew", using: :btree
  add_index "orbits", ["listing_id"], name: "index_orbits_on_listing_id", using: :btree
  add_index "orbits", ["number_of_roommates"], name: "index_orbits_on_number_of_roommates", using: :btree
  add_index "orbits", ["start_date"], name: "index_orbits_on_start_date", using: :btree
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
    t.string   "username",                               null: false
    t.string   "first_name",                             null: false
    t.string   "last_name",                              null: false
    t.boolean  "landlord",               default: false
    t.boolean  "regular_user",           default: false
    t.text     "about",                  default: ""
    t.string   "merchant_account_id"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
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
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
