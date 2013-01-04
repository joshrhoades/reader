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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121223023300) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "category_entry_mappings", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "clients", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "client_id",  :null => false
    t.string   "channel",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "item_id",                       :null => false
    t.text     "body",                          :null => false
    t.boolean  "edited",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.text     "html"
  end

  add_index "comments", ["id"], :name => "comments_id"
  add_index "comments", ["item_id"], :name => "comments_item_id"

  create_table "entries", :force => true do |t|
    t.string   "guid",              :limit => 4096
    t.integer  "feed_id"
    t.string   "title",             :limit => 4096
    t.string   "url",               :limit => 4096, :null => false
    t.string   "author",            :limit => 4096
    t.string   "summary",           :limit => 4096
    t.text     "content"
    t.datetime "published_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.text     "sanitized_content"
  end

  add_index "entries", ["feed_id"], :name => "index_entries_on_feed_id"
  add_index "entries", ["guid", "feed_id"], :name => "index_entries_on_guid"
  add_index "entries", ["id"], :name => "entries_id"
  add_index "entries", ["url"], :name => "index_entries_on_url"

  create_table "entry_guids", :force => true do |t|
    t.integer "feed_id"
    t.string  "guid",    :limit => 4096
  end

  add_index "entry_guids", ["feed_id", "guid"], :name => "feed_id_guid", :unique => true

  create_table "facebook_authorizations", :force => true do |t|
    t.integer  "user_id"
    t.text     "token"
    t.datetime "token_expires_at"
    t.text     "auth_hash"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "facebook_id"
  end

  create_table "facebook_contacts", :force => true do |t|
    t.integer  "left_user_id"
    t.integer  "right_user_id"
    t.text     "names"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "feed_icons", :force => true do |t|
    t.integer  "feed_id"
    t.string   "uri",        :limit => 4096
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "feed_icon",  :limit => 4096
  end

  create_table "feeds", :force => true do |t|
    t.string   "name",                                               :null => false
    t.integer  "user_id"
    t.string   "feed_url",        :limit => 4096
    t.string   "site_url",        :limit => 4096
    t.text     "description"
    t.boolean  "suggested",                       :default => false
    t.boolean  "private",                         :default => false
    t.datetime "fetched_at"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.boolean  "fetchable",                       :default => true
    t.text     "hub"
    t.text     "topic"
    t.string   "token"
    t.integer  "timeouts",                        :default => 0
    t.integer  "parse_errors",                    :default => 0
    t.boolean  "push_subscribed",                 :default => false
    t.string   "secret_token"
    t.string   "etag"
  end

  add_index "feeds", ["feed_url"], :name => "index_feeds_on_feed_url"
  add_index "feeds", ["id"], :name => "feeds_id"

  create_table "fetch_errors", :force => true do |t|
    t.integer  "feed_id"
    t.string   "http_status"
    t.string   "message"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",                      :null => false
    t.string   "followable_type",                    :null => false
    t.integer  "follower_id",                        :null => false
    t.string   "follower_type",                      :null => false
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "ignored",         :default => false
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "groups", :force => true do |t|
    t.string   "label"
    t.string   "key"
    t.integer  "user_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "open",       :default => true
    t.integer  "weight",     :default => 0
  end

  add_index "groups", ["user_id", "key"], :name => "user_key", :unique => true

  create_table "items", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.integer  "entry_id"
    t.integer  "subscription_id"
    t.boolean  "unread",           :default => true
    t.boolean  "starred",          :default => false
    t.boolean  "shared",           :default => false
    t.boolean  "browsed",          :default => false
    t.boolean  "liked",            :default => false
    t.integer  "parent_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "share_delivered",  :default => false
    t.integer  "from_id"
    t.boolean  "has_new_comments"
    t.boolean  "commented",        :default => false
  end

  add_index "items", ["entry_id"], :name => "index_items_on_entry_id"
  add_index "items", ["subscription_id"], :name => "index_items_on_subscription_id"
  add_index "items", ["unread", "starred", "shared", "has_new_comments"], :name => "items_flags"
  add_index "items", ["user_id", "entry_id"], :name => "item_user_entry", :unique => true
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.integer  "group_id"
    t.string   "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "weight",          :default => 0
    t.integer  "unread_count"
    t.integer  "starred_count"
    t.integer  "shared_count"
    t.integer  "all_count"
    t.integer  "commented_count"
    t.boolean  "deleted",         :default => false
  end

  add_index "subscriptions", ["id"], :name => "subscriptions_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                     :null => false
    t.string   "name",                                      :null => false
    t.string   "encrypted_password",                        :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "last_seen_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "anonymous",              :default => false
    t.string   "websocket_token",                           :null => false
    t.string   "public_token",                              :null => false
    t.integer  "shared_feed_id"
    t.integer  "starred_feed_id"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
