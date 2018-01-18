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

ActiveRecord::Schema.define(version: 20180118162734) do

  create_table "bands", force: true do |t|
    t.string   "bn_head"
    t.string   "novelty"
    t.datetime "bn_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bn_url"
  end

  add_index "bands", ["bn_date"], name: "index_bands_on_bn_date"
  add_index "bands", ["created_at"], name: "index_bands_on_created_at"

  create_table "bitcoins", force: true do |t|
    t.datetime "btc_date"
    t.string   "btc_head"
    t.string   "btc_novelty"
    t.string   "btc_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facts", force: true do |t|
    t.string   "fc_range"
    t.string   "fc_fact"
    t.string   "fc_myurl"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fc_date"
    t.string   "fc_isxurl"
  end

  create_table "overlooks", force: true do |t|
    t.date     "lk_date"
    t.string   "lk_file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lk_btcfile"
  end

  create_table "reviews", force: true do |t|
    t.date     "rw_date"
    t.string   "rw_file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "rw_article"
    t.string   "rw_title"
  end

end
