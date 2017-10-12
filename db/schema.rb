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

ActiveRecord::Schema.define(version: 20171010065613) do

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.string   "member_name",                null: false
    t.integer  "board_id",                   null: false
    t.integer  "member_id",                  null: false
    t.boolean  "active",      default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "attendence_lists", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "user_name"
    t.integer  "code"
    t.string   "name",       null: false
    t.datetime "start",      null: false
    t.datetime "end",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendences", force: :cascade do |t|
    t.integer  "attendence_list_id"
    t.integer  "user_id"
    t.string   "user_name",          null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "boards", force: :cascade do |t|
    t.string   "route",                        null: false
    t.string   "name",                         null: false
    t.integer  "category_id",                  null: false
    t.string   "template"
    t.boolean  "show_last",    default: false
    t.boolean  "show_comment", default: true
    t.integer  "read_level",   default: 0,     null: false
    t.integer  "write_level",  default: 100,   null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "route",                  null: false
    t.string   "name",                   null: false
    t.string   "default"
    t.integer  "read_level", default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "member_id",        null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["member_id"], name: "index_comments_on_member_id"

  create_table "kakao_chat_logins", force: :cascade do |t|
    t.string   "user_key"
    t.integer  "member_id"
    t.string   "state",      default: ""
    t.boolean  "active",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "majors", force: :cascade do |t|
    t.string "name",       null: false
    t.string "department", null: false
  end

  create_table "members", force: :cascade do |t|
    t.string   "email",                  default: "",                        null: false
    t.string   "username",               default: "",                        null: false
    t.integer  "senior_number",          default: 1,                         null: false
    t.string   "tel",                    default: "미입력",                     null: false
    t.integer  "major_id",               default: 0,                         null: false
    t.string   "image_url",              default: "/images/default_img.png", null: false
    t.string   "encrypted_password",     default: "",                        null: false
    t.boolean  "admin",                  default: false,                     null: false
    t.boolean  "staff",                  default: false,                     null: false
    t.integer  "role",                   default: 0,                         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true

  create_table "points", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.integer  "point",      default: 5000, null: false
    t.integer  "win",        default: 0,    null: false
    t.integer  "lose",       default: 0,    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "statistics", force: :cascade do |t|
    t.string  "name",         null: false
    t.integer "member_id",    null: false
    t.string  "target_model"
    t.integer "target_id"
    t.date    "created_at",   null: false
  end

  create_table "uploadfiles", force: :cascade do |t|
    t.integer  "article_id",    null: false
    t.string   "public_id"
    t.string   "format"
    t.string   "resource_type"
    t.string   "url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "wiki_page_versions", force: :cascade do |t|
    t.integer  "page_id",                      null: false
    t.integer  "updator_id"
    t.integer  "number"
    t.string   "comment"
    t.string   "path"
    t.string   "title"
    t.text     "content",    limit: 268435456
    t.datetime "updated_at"
  end

  add_index "wiki_page_versions", ["page_id"], name: "index_wiki_page_versions_on_page_id"
  add_index "wiki_page_versions", ["updator_id"], name: "index_wiki_page_versions_on_updator_id"

  create_table "wiki_pages", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "updator_id"
    t.string   "path"
    t.string   "title"
    t.text     "content",    limit: 268435456
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wiki_pages", ["creator_id"], name: "index_wiki_pages_on_creator_id"
  add_index "wiki_pages", ["path"], name: "index_wiki_pages_on_path", unique: true

end
