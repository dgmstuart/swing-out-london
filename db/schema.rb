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

ActiveRecord::Schema.define(:version => 20110805155304) do

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "day"
    t.string   "event_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "venue_id"
    t.integer  "organiser_id"
    t.integer  "frequency"
    t.string   "url"
    t.string   "date_array"
    t.string   "cancellation_array"
    t.date     "first_date"
    t.date     "last_date"
  end

  create_table "organisers", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "postcode"
    t.string   "nearest_tube"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "area"
    t.string   "compass"
  end

end
