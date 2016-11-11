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

ActiveRecord::Schema.define(version: 20161111085243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.string  "file"
    t.integer "post_id"
    t.index ["post_id"], name: "index_attachments_on_post_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "color"
  end

  create_table "categories_posts", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "post_id",     null: false
    t.index ["category_id", "post_id"], name: "index_categories_posts_on_category_id_and_post_id", using: :btree
    t.index ["post_id", "category_id"], name: "index_categories_posts_on_post_id_and_category_id", using: :btree
  end

  create_table "commontator_comments", force: :cascade do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                     null: false
    t.text     "body",                          null: false
    t.datetime "deleted_at"
    t.integer  "cached_votes_up",   default: 0
    t.integer  "cached_votes_down", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down", using: :btree
    t.index ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up", using: :btree
    t.index ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id", using: :btree
    t.index ["thread_id", "created_at"], name: "index_commontator_comments_on_thread_id_and_created_at", using: :btree
  end

  create_table "commontator_subscriptions", force: :cascade do |t|
    t.string   "subscriber_type", null: false
    t.integer  "subscriber_id",   null: false
    t.integer  "thread_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true, using: :btree
    t.index ["thread_id"], name: "index_commontator_subscriptions_on_thread_id", using: :btree
  end

  create_table "commontator_threads", force: :cascade do |t|
    t.string   "commontable_type"
    t.integer  "commontable_id"
    t.datetime "closed_at"
    t.string   "closer_type"
    t.integer  "closer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commontable_id", "commontable_type"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true, using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "commenter_id"
    t.integer  "post_id"
    t.integer  "comment_id"
    t.index ["commenter_id"], name: "index_notifications_on_commenter_id", using: :btree
    t.index ["post_id"], name: "index_notifications_on_post_id", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "buyer_id"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "category_id"
    t.integer  "price"
    t.index ["buyer_id"], name: "index_posts_on_buyer_id", using: :btree
    t.index ["category_id"], name: "index_posts_on_category_id", using: :btree
  end

  create_table "posts_users", id: false, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "post_id"], name: "index_posts_users_on_user_id_and_post_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "attachments", "posts"
  add_foreign_key "notifications", "posts"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "commenter_id"
  add_foreign_key "posts", "categories"
  add_foreign_key "posts", "users", column: "buyer_id"
end
