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

ActiveRecord::Schema.define(:version => 20120104083042) do

  create_table "post_tags", :id => false, :force => true do |t|
    t.integer "post_id"
    t.string  "tag",     :limit => 40
  end

  add_index "post_tags", ["post_id", "tag"], :name => "index_post_tags_on_post_id_and_tag"

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

  add_index "users", ["provider"], :name => "index_users_on_provider"
  add_index "users", ["uid"], :name => "index_users_on_uid"

end
