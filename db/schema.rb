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

ActiveRecord::Schema.define(:version => 20120111112828) do

  create_table "friendships", :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
  end

  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id"

  create_table "octodata", :force => true do |t|
    t.string  "login"
    t.integer "data_type"
    t.text    "content"
  end

  create_table "post_tags", :force => true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  add_index "post_tags", ["post_id", "tag_id"], :name => "index_post_tags_on_post_id_and_tag_id"

  create_table "posts", :force => true do |t|
    t.string   "text",                :limit => 560
    t.integer  "in_reply_to_post_id"
    t.integer  "in_reply_to_user_id"
    t.integer  "user_id",                                                           :null => false
    t.string   "name",                :limit => 80
    t.string   "nickname",            :limit => 30
    t.string   "avatar_url",          :limit => 140
    t.decimal  "geo_lat",                            :precision => 10, :scale => 5
    t.decimal  "geo_long",                           :precision => 10, :scale => 5
    t.text     "entities"
    t.datetime "created_at"
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "rapns_feedback", :force => true do |t|
    t.string   "device_token", :limit => 64, :null => false
    t.datetime "failed_at",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rapns_feedback", ["device_token"], :name => "index_rapns_feedback_on_device_token"

  create_table "rapns_notifications", :force => true do |t|
    t.integer  "badge"
    t.string   "device_token",          :limit => 64,                       :null => false
    t.string   "sound",                               :default => "1.aiff"
    t.string   "alert"
    t.text     "attributes_for_device"
    t.integer  "expiry",                              :default => 86400,    :null => false
    t.boolean  "delivered",                           :default => false,    :null => false
    t.datetime "delivered_at"
    t.boolean  "failed",                              :default => false,    :null => false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.string   "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rapns_notifications", ["delivered", "failed", "deliver_after"], :name => "index_rapns_notifications_on_delivered_failed_deliver_after"

  create_table "tags", :force => true do |t|
    t.string "name", :limit => 40
  end

  create_table "tagships", :force => true do |t|
    t.integer "user_id"
    t.integer "tag_id"
  end

  add_index "tagships", ["user_id", "tag_id"], :name => "index_tagships_on_user_id_and_tag_id"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name",             :limit => 80
    t.string   "nickname",         :limit => 30
    t.string   "email"
    t.string   "location",         :limit => 30
    t.string   "bio",              :limit => 640
    t.string   "avatar_url",       :limit => 140
    t.string   "html_url",         :limit => 100
    t.string   "token"
    t.integer  "followers_count",                 :default => 0
    t.integer  "friends_count",                   :default => 0
    t.integer  "favourites_count",                :default => 0
    t.integer  "posts_count",                     :default => 0
    t.datetime "created_at"
  end

  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid"

end
