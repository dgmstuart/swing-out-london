# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_03_28_083046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.jsonb "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.text "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "day", limit: 255
    t.string "event_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "venue_id", null: false
    t.integer "frequency"
    t.string "url", limit: 255, null: false
    t.string "date_array", limit: 255
    t.string "cancellation_array", limit: 255
    t.date "first_date"
    t.date "last_date"
    t.text "class_style"
    t.integer "course_length"
    t.boolean "has_taster"
    t.boolean "has_class"
    t.boolean "has_social"
    t.integer "class_organiser_id"
    t.integer "social_organiser_id"
    t.date "expected_date"
    t.string "organiser_token"
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["frequency", "day", "has_class"], name: "index_events_on_fq_and_day_and_has_class"
    t.index ["frequency", "day", "has_social"], name: "index_events_on_fq_and_day_and_has_social"
    t.index ["frequency", "has_class"], name: "index_events_on_fq_and_has_class"
    t.index ["last_date", "event_type"], name: "index_events_on_last_date_and_event_type"
    t.index ["last_date", "frequency", "has_class"], name: "index_events_on_last_date_and_fq_and_has_class"
    t.index ["organiser_token"], name: "index_events_on_organiser_token", unique: true
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "events_swing_cancellations", force: :cascade do |t|
    t.integer "swing_date_id", null: false
    t.integer "event_id", null: false
    t.index ["swing_date_id", "event_id"], name: "index_events_swing_cancellations_on_swing_date_id_and_event_id", unique: true
  end

  create_table "events_swing_dates", force: :cascade do |t|
    t.integer "swing_date_id", null: false
    t.integer "event_id", null: false
    t.index ["swing_date_id", "event_id"], name: "index_events_swing_dates_on_swing_date_id_and_event_id", unique: true
  end

  create_table "organisers", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "website", limit: 255
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "shortname", limit: 255
    t.index ["shortname"], name: "index_organisers_on_shortname", unique: true
  end

  create_table "swing_dates", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "date"
    t.index ["date"], name: "index_swing_dates_on_date", unique: true
  end

  create_table "venues", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "address"
    t.string "postcode", limit: 255
    t.string "website", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "area", limit: 255
    t.string "compass", limit: 255
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lng", precision: 15, scale: 10
  end

end
