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

ActiveRecord::Schema.define(:version => 20120516130548) do

  create_table "events", :force => true do |t|
    t.string    "title"
    t.string    "day"
    t.string    "event_type"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "venue_id"
    t.integer   "organiser_id"
    t.integer   "frequency"
    t.string    "url"
    t.string    "date_array"
    t.string    "cancellation_array"
    t.date      "first_date"
    t.date      "last_date"
    t.string    "shortname"
    t.text      "class_style"
    t.integer   "course_length"
    t.boolean   "has_taster"
    t.boolean   "has_class"
    t.boolean   "has_social"
  end

  add_index "events", ["event_type"], :name => "index_events_on_event_type"
  add_index "events", ["frequency", "day", "has_class"], :name => "index_events_on_frequency_and_day_and_has_class"
  add_index "events", ["frequency", "day", "has_social"], :name => "index_events_on_frequency_and_day_and_has_social"
  add_index "events", ["frequency", "has_class"], :name => "index_events_on_frequency_and_has_class"
  add_index "events", ["last_date", "event_type"], :name => "index_events_on_last_date_and_event_type"
  add_index "events", ["last_date", "frequency", "has_class"], :name => "index_events_on_last_date_and_frequency_and_has_class"
  add_index "events", ["organiser_id"], :name => "index_events_on_organiser_id"
  add_index "events", ["venue_id"], :name => "index_events_on_venue_id"

  create_table "events_swing_cancellations", :id => false, :force => true do |t|
    t.integer "swing_date_id", :null => false
    t.integer "event_id",      :null => false
  end

  add_index "events_swing_cancellations", ["swing_date_id", "event_id"], :name => "index_events_swing_cancellations_on_swing_date_id_and_event_id", :unique => true

  create_table "events_swing_dates", :id => false, :force => true do |t|
    t.integer "swing_date_id", :null => false
    t.integer "event_id",      :null => false
  end

  add_index "events_swing_dates", ["swing_date_id", "event_id"], :name => "index_events_swing_dates_on_swing_date_id_and_event_id", :unique => true

  create_table "organisers", :force => true do |t|
    t.string    "name"
    t.string    "website"
    t.text      "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "shortname"
  end

  create_table "swing_dates", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.date      "date"
  end

  create_table "venues", :force => true do |t|
    t.string    "name"
    t.text      "address"
    t.string    "postcode"
    t.string    "nearest_tube"
    t.string    "website"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "area"
    t.string    "compass"
    t.decimal   "lat"
    t.decimal   "lng"
  end

end
