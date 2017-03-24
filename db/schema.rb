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

ActiveRecord::Schema.define(version: 20170321224256) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brains", force: :cascade do |t|
    t.string   "text"
    t.integer  "pointsize"
    t.integer  "xpos"
    t.integer  "ypos"
    t.integer  "expanding_brain_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["expanding_brain_id"], name: "index_brains_on_expanding_brain_id", using: :btree
  end

  create_table "expanding_brains", force: :cascade do |t|
    t.string   "Name"
    t.integer  "Type"
    t.string   "Status"
    t.string   "URL"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "brain_id"
    t.index ["brain_id"], name: "index_expanding_brains_on_brain_id", using: :btree
  end

  add_foreign_key "brains", "expanding_brains"
  add_foreign_key "expanding_brains", "brains"
end
