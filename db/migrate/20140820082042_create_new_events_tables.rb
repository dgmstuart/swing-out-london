class CreateNewEventsTables < ActiveRecord::Migration
  def change
    # Copied from schema:
    create_table "event_generators", force: true do |t|
      t.integer  "event_seed_id", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "frequency",     null: false
      t.date     "start_date",    null: false
    end

    create_table "event_seeds", force: true do |t|
      t.string   "url"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "event_id",   null: false
      t.integer  "venue_id",   null: false
    end

    create_table "dance_classes", force: true do |t|
      t.string   "day",        null: false
      t.integer  "venue_id",   null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
