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

ActiveRecord::Schema.define(:version => 20131005150929) do

  create_table "cache_party_facebook_applications", :force => true do |t|
    t.string   "app_id"
    t.string   "app_secret"
    t.string   "app_scope"
    t.string   "oauth_token"
    t.string   "wall_post_domain"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "cache_party_facebook_page_stats", :force => true do |t|
    t.integer  "facebook_page_id"
    t.integer  "likes"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "cache_party_facebook_page_stats", ["created_at"], :name => "index_mcp_ext_facebook_page_stats_on_created_at"
  add_index "cache_party_facebook_page_stats", ["facebook_page_id"], :name => "index_mcp_ext_facebook_page_stats_on_facebook_page_id"

  create_table "cache_party_facebook_pages", :force => true do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type"
    t.string   "url"
    t.string   "facebook_id"
    t.string   "about"
    t.string   "category"
    t.string   "link"
    t.string   "name"
    t.string   "phone"
    t.string   "cover_source"
    t.string   "picture"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "cache_party_facebook_posts", :force => true do |t|
    t.integer  "contentable_id"
    t.string   "contentable_type"
    t.integer  "postable_id"
    t.string   "postable_type"
    t.integer  "authorizable_id"
    t.string   "authorizable_type"
    t.datetime "attempted_at"
    t.string   "response"
    t.boolean  "attach_post_id_to_content"
    t.boolean  "posted"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "cache_party_facebook_posts", ["authorizable_id"], :name => "index_mcp_ext_facebook_posts_on_authorizable_id"
  add_index "cache_party_facebook_posts", ["contentable_id"], :name => "index_mcp_ext_facebook_posts_on_contentable_id"
  add_index "cache_party_facebook_posts", ["postable_id"], :name => "index_mcp_ext_facebook_posts_on_postable_id"

  create_table "cache_party_facebook_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cacheable_id"
    t.string   "cacheable_type"
    t.string   "name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "locale"
    t.string   "link"
    t.string   "email"
    t.string   "username"
    t.string   "picture"
    t.boolean  "verified"
    t.datetime "updated_time"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "facebook_id"
  end

  add_index "cache_party_facebook_users", ["cacheable_id"], :name => "index_mcp_ext_facebook_users_on_cacheable_id"
  add_index "cache_party_facebook_users", ["cacheable_type"], :name => "index_mcp_ext_facebook_users_on_cacheable_type"
  add_index "cache_party_facebook_users", ["user_id"], :name => "index_mcp_ext_facebook_users_on_user_id"

  create_table "mcp_auth_auth_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "mcp_auth_auth_profiles", ["user_id"], :name => "index_mcp_auth_auth_profiles_on_user_id"

  create_table "mcp_auth_users", :force => true do |t|
    t.string   "email",                :default => "", :null => false
    t.string   "username",             :default => "", :null => false
    t.string   "encrypted_password",   :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "locale"
    t.string   "time_zone"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "mcp_auth_users", ["authentication_token"], :name => "index_mcp_auth_users_on_authentication_token", :unique => true
  add_index "mcp_auth_users", ["email"], :name => "index_mcp_auth_users_on_email", :unique => true
  add_index "mcp_auth_users", ["username"], :name => "index_mcp_auth_users_on_username", :unique => true

  create_table "mcp_auth_users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "mcp_auth_users_roles", ["user_id", "role_id"], :name => "index_mcp_auth_users_roles_on_user_id_and_role_id"

  create_table "mcp_common_app_configs", :force => true do |t|
    t.string   "environment"
    t.text     "settings"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "mcp_common_contacts", :force => true do |t|
    t.string   "value"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "mcp_common_locations", :force => true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "address4"
    t.string   "locality"
    t.string   "region"
    t.string   "postal_code"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "mcp_common_people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "personable_id"
    t.string   "personable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "mcp_common_users", :force => true do |t|
    t.integer  "mcp_auth_user_id"
    t.string   "locale"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "mcp_common_users", ["mcp_auth_user_id"], :name => "index_mcp_common_users_on_mcp_auth_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

end
