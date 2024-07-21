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

ActiveRecord::Schema[7.1].define(version: 2024_08_16_131900) do
  create_schema "heroku_ext"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
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
    t.datetime "created_at", precision: nil
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "event_instances", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "cancelled", default: false, null: false
    t.index ["date"], name: "index_event_instances_on_date"
    t.index ["event_id", "date"], name: "index_event_instances_on_event_id_and_date", unique: true
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "day", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "venue_id", null: false
    t.integer "frequency", null: false
    t.string "url", limit: 255, null: false
    t.date "first_date"
    t.date "last_date"
    t.text "class_style"
    t.integer "course_length"
    t.boolean "has_taster"
    t.boolean "has_class"
    t.boolean "has_social"
    t.integer "class_organiser_id"
    t.integer "social_organiser_id"
    t.string "organiser_token"
    t.string "reminder_email_address"
    t.index ["frequency", "day", "has_class"], name: "index_events_on_fq_and_day_and_has_class"
    t.index ["frequency", "day", "has_social"], name: "index_events_on_fq_and_day_and_has_social"
    t.index ["frequency", "has_class"], name: "index_events_on_fq_and_has_class"
    t.index ["last_date", "frequency", "has_class"], name: "index_events_on_last_date_and_fq_and_has_class"
    t.index ["organiser_token"], name: "index_events_on_organiser_token", unique: true
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "organisers", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "website", limit: 255
    t.text "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "shortname", limit: 255
    t.index ["shortname"], name: "index_organisers_on_shortname", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "facebook_ref", null: false
    t.string "role", default: "editor", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_ref"], name: "index_roles_on_facebook_ref", unique: true
  end

  create_table "venues", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "address"
    t.string "postcode", limit: 255
    t.string "website", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "area", limit: 255
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lng", precision: 15, scale: 10
  end

  add_foreign_key "event_instances", "events"
end
