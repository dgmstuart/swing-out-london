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

ActiveRecord::Schema.define(version: 2018_11_11_203111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "day"
    t.string "event_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "venue_id"
    t.integer "frequency"
    t.string "url"
    t.string "date_array"
    t.string "cancellation_array"
    t.date "first_date"
    t.date "last_date"
    t.string "shortname"
    t.text "class_style"
    t.integer "course_length"
    t.boolean "has_taster"
    t.boolean "has_class"
    t.boolean "has_social"
    t.integer "class_organiser_id"
    t.integer "social_organiser_id"
    t.date "expected_date"
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["frequency", "day", "has_class"], name: "index_events_on_fq_and_day_and_has_class"
    t.index ["frequency", "day", "has_social"], name: "index_events_on_fq_and_day_and_has_social"
    t.index ["frequency", "has_class"], name: "index_events_on_fq_and_has_class"
    t.index ["last_date", "event_type"], name: "index_events_on_last_date_and_event_type"
    t.index ["last_date", "frequency", "has_class"], name: "index_events_on_last_date_and_fq_and_has_class"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "events_swing_cancellations", id: false, force: :cascade do |t|
    t.integer "swing_date_id", null: false
    t.integer "event_id", null: false
    t.index ["swing_date_id", "event_id"], name: "index_events_swing_cancellations_on_swing_date_id_and_event_id", unique: true
  end

  create_table "events_swing_dates", id: false, force: :cascade do |t|
    t.integer "swing_date_id", null: false
    t.integer "event_id", null: false
    t.index ["swing_date_id", "event_id"], name: "index_events_swing_dates_on_swing_date_id_and_event_id", unique: true
  end

  create_table "organisers", force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "shortname"
  end

  create_table "swing_dates", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "date"
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "postcode"
    t.string "nearest_tube"
    t.string "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "area"
    t.string "compass"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lng", precision: 15, scale: 10
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.string "user_name"
    t.string "dates"
    t.string "cancellations"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
