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

ActiveRecord::Schema.define(version: 20160614083251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_grants", force: :cascade do |t|
    t.string   "code"
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "access_token_expires_at"
    t.integer  "user_id"
    t.integer  "client_id"
    t.string   "state"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at", precision: 6
    t.datetime "created_at",       precision: 6, null: false
    t.datetime "updated_at",       precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "order",                     default: 0
    t.integer  "category_id"
    t.string   "image_url"
    t.string   "number"
    t.datetime "created_at",  precision: 6,             null: false
    t.datetime "updated_at",  precision: 6,             null: false
    t.string   "image"
  end

  add_index "categories", ["category_id"], name: "index_categories_on_category_id", using: :btree
  add_index "categories", ["number"], name: "index_categories_on_number", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "app_id"
    t.string   "app_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ebooks", force: :cascade do |t|
    t.string   "image"
    t.string   "file"
    t.string   "author"
    t.string   "title"
    t.text     "description"
    t.string   "ean"
    t.string   "isbn"
    t.integer  "number_of_pages"
    t.date     "publication_date"
    t.string   "publisher_name"
    t.string   "record_reference"
    t.datetime "created_at",       precision: 6, null: false
    t.datetime "updated_at",       precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "media_id"
    t.string   "title",       limit: 55
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "stream_url",  limit: 255
    t.integer  "product_id"
    t.integer  "price"
  end

  create_table "favorite_media", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "media_number"
    t.datetime "created_at",   precision: 6, null: false
    t.datetime "updated_at",   precision: 6, null: false
  end

  add_index "favorite_media", ["media_number"], name: "index_favorite_media_on_media_number", using: :btree
  add_index "favorite_media", ["user_id"], name: "index_favorite_media_on_user_id", using: :btree

  create_table "genres", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lineups", force: :cascade do |t|
    t.string   "l_id"
    t.string   "lineup_name"
    t.string   "lineup_type"
    t.string   "provider_id"
    t.string   "provider_name"
    t.string   "service_area"
    t.string   "country"
    t.datetime "created_at",    precision: 6, null: false
    t.datetime "updated_at",    precision: 6, null: false
  end

  create_table "lineups_stations", id: false, force: :cascade do |t|
    t.integer "lineup_id"
    t.integer "station_id"
  end

  add_index "lineups_stations", ["lineup_id", "station_id"], name: "index_lineups_stations_on_lineup_id_and_station_id", using: :btree

  create_table "listings", force: :cascade do |t|
    t.string   "s_number"
    t.integer  "channel_number"
    t.integer  "sub_channel_number"
    t.integer  "s_id"
    t.string   "callsign"
    t.string   "logo_file_name"
    t.datetime "list_date_time",     precision: 6
    t.integer  "duration"
    t.integer  "show_id"
    t.integer  "series_id"
    t.string   "show_name"
    t.string   "episode_title"
    t.boolean  "repeat"
    t.boolean  "new"
    t.boolean  "live"
    t.boolean  "hd"
    t.boolean  "descriptive_video"
    t.boolean  "in_progress"
    t.string   "show_type"
    t.integer  "star_rating"
    t.text     "description"
    t.string   "league"
    t.string   "team1"
    t.string   "team2"
    t.string   "show_picture"
    t.string   "web_link"
    t.string   "name"
    t.string   "station_type"
    t.integer  "listing_id"
    t.string   "episode_number"
    t.integer  "parts"
    t.integer  "part_num"
    t.boolean  "series_premiere"
    t.boolean  "season_premiere"
    t.boolean  "series_finale"
    t.boolean  "season_finale"
    t.string   "rating"
    t.string   "guest"
    t.string   "director"
    t.string   "location"
    t.string   "l_id"
    t.datetime "updated_date",       precision: 6
    t.datetime "created_at",         precision: 6, null: false
    t.datetime "updated_at",         precision: 6, null: false
  end

  create_table "media", force: :cascade do |t|
    t.integer  "admin_user_id"
    t.string   "title"
    t.text     "description"
    t.string   "number"
    t.string   "image_url"
    t.string   "source_url"
    t.text     "extra_sources"
    t.string   "language"
    t.integer  "rating",                        default: 0
    t.integer  "order",                         default: 0
    t.text     "embedded_code"
    t.text     "text"
    t.text     "overlay_code"
    t.datetime "created_at",      precision: 6,                 null: false
    t.datetime "updated_at",      precision: 6,                 null: false
    t.string   "image"
    t.integer  "pricing_plan_id"
    t.boolean  "is_a_game",                     default: false
    t.integer  "medium_id"
  end

  add_index "media", ["number"], name: "index_media_on_number", using: :btree

  create_table "media_categories", force: :cascade do |t|
    t.integer  "medium_id"
    t.integer  "category_id"
    t.datetime "created_at",  precision: 6, null: false
    t.datetime "updated_at",  precision: 6, null: false
  end

  add_index "media_categories", ["category_id"], name: "index_media_categories_on_category_id", using: :btree
  add_index "media_categories", ["medium_id"], name: "index_media_categories_on_medium_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "product_id",                      null: false
    t.integer  "order_id",                        null: false
    t.decimal  "price"
    t.string   "subscription_unit"
    t.datetime "created_at",        precision: 6, null: false
    t.datetime "updated_at",        precision: 6, null: false
  end

  add_index "order_items", ["order_id", "product_id"], name: "index_order_items_on_order_id_and_product_id", unique: true, using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",                  null: false
    t.string   "mpxid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "payment_details", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "card_number"
    t.string   "card_type"
    t.string   "stripe_customer_id"
    t.datetime "created_at",         precision: 6, null: false
    t.datetime "updated_at",         precision: 6, null: false
  end

  create_table "preferences", force: :cascade do |t|
    t.string   "initial_time"
    t.string   "station_filter"
    t.integer  "time_span"
    t.integer  "grid_height"
    t.integer  "user_id"
    t.datetime "created_at",     precision: 6, null: false
    t.datetime "updated_at",     precision: 6, null: false
  end

  create_table "pricing_plans", force: :cascade do |t|
    t.string   "title"
    t.integer  "price",                           default: 99
    t.string   "interval",                        default: "month"
    t.integer  "interval_count",                  default: 1
    t.integer  "trial_period_days",               default: 0
    t.string   "unique_key"
    t.string   "stripe_id"
    t.datetime "created_at",        precision: 6,                   null: false
    t.datetime "updated_at",        precision: 6,                   null: false
  end

  create_table "product_items", force: :cascade do |t|
    t.integer  "product_id",               null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer  "item_id"
    t.string   "item_type"
  end

  add_index "product_items", ["product_id"], name: "index_product_items_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "mpxid"
    t.string   "title"
    t.string   "description"
    t.string   "images",                        default: [],                array: true
    t.datetime "created_at",      precision: 6,                null: false
    t.datetime "updated_at",      precision: 6,                null: false
    t.json     "pricing_plan"
    t.boolean  "available",                     default: true, null: false
    t.string   "image"
    t.integer  "pricing_plan_id"
  end

  add_index "products", ["mpxid"], name: "index_products_on_mpxid", using: :btree

  create_table "stations", force: :cascade do |t|
    t.string   "s_number"
    t.integer  "channel_number"
    t.integer  "sub_channel_number"
    t.integer  "s_id"
    t.string   "name"
    t.string   "callsign"
    t.string   "network"
    t.string   "station_type"
    t.integer  "ntsc_tsid"
    t.integer  "dtv_tsid"
    t.string   "twitter"
    t.string   "weblink"
    t.string   "logo_file_name"
    t.boolean  "station_hd"
    t.datetime "created_at",         precision: 6, null: false
    t.datetime "updated_at",         precision: 6, null: false
  end

  create_table "subscription_items", force: :cascade do |t|
    t.integer  "subscription_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at",      precision: 6, null: false
    t.datetime "updated_at",      precision: 6, null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "billing_period"
    t.integer  "product_id"
    t.string   "payment_detail_id"
    t.string   "stripe_id"
    t.string   "stripe_plan_id"
    t.datetime "created_at",        precision: 6, null: false
    t.datetime "updated_at",        precision: 6, null: false
    t.integer  "pricing_plan_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                              default: "",        null: false
    t.string   "encrypted_password",                                 default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at",               precision: 6
    t.datetime "remember_created_at",                  precision: 6
    t.integer  "sign_in_count",                                      default: 0,         null: false
    t.datetime "current_sign_in_at",                   precision: 6
    t.datetime "last_sign_in_at",                      precision: 6
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                           precision: 6,                     null: false
    t.datetime "updated_at",                           precision: 6,                     null: false
    t.string   "mpx_token"
    t.string   "mpx_user_id"
    t.json     "billing_address"
    t.string   "name"
    t.text     "recently_viewed_media_ids",                          default: [],                     array: true
    t.string   "avatar"
    t.integer  "avatar_option",                                      default: 0
    t.string   "authentication_token",      limit: 30
    t.string   "default_language",                                   default: "English"
    t.string   "role",                                               default: "user"
    t.datetime "start_trial_date",                     precision: 6
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_genres", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "genre_id"
  end

  add_index "users_genres", ["user_id", "genre_id"], name: "index_users_genres_on_user_id_and_genre_id", using: :btree

  create_table "users_stations", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "station_id"
  end

  add_index "users_stations", ["user_id", "station_id"], name: "index_users_stations_on_user_id_and_station_id", using: :btree

end
