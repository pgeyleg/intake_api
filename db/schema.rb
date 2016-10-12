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

ActiveRecord::Schema.define(version: 20161011205146) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "gender"
    t.string   "ssn"
    t.date     "date_of_birth"
  end

  create_table "person_addresses", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_person_addresses_on_address_id", using: :btree
    t.index ["person_id"], name: "index_person_addresses_on_person_id", using: :btree
  end

  create_table "screening_addresses", force: :cascade do |t|
    t.integer  "screening_id"
    t.integer  "address_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["address_id"], name: "index_screening_addresses_on_address_id", using: :btree
    t.index ["screening_id"], name: "index_screening_addresses_on_screening_id", using: :btree
  end

  create_table "screening_people", force: :cascade do |t|
    t.integer  "screening_id"
    t.integer  "person_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["person_id"], name: "index_screening_people_on_person_id", using: :btree
    t.index ["screening_id"], name: "index_screening_people_on_screening_id", using: :btree
  end

  create_table "screenings", force: :cascade do |t|
    t.string   "reference"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "ended_at"
    t.date     "incident_date"
    t.string   "location_type"
    t.string   "method_of_referral"
    t.string   "name"
    t.datetime "started_at"
    t.string   "response_time"
    t.string   "screening_decision"
    t.string   "incident_county"
    t.text     "narrative"
  end

end
