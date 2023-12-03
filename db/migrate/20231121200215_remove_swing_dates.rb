# frozen_string_literal: true

class RemoveSwingDates < ActiveRecord::Migration[7.1]
  def up
    drop_table :events_swing_cancellations
    drop_table :events_swing_dates
    drop_table :swing_dates
  end

  def down
    create_table "events_swing_cancellations", force: :cascade do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.integer "swing_date_id", null: false
      t.integer "event_id", null: false
      t.index %w[swing_date_id event_id], name: "index_events_swing_cancellations_on_swing_date_id_and_event_id",
                                          unique: true
    end

    create_table "events_swing_dates", force: :cascade do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.integer "swing_date_id", null: false
      t.integer "event_id", null: false
      t.index %w[swing_date_id event_id], name: "index_events_swing_dates_on_swing_date_id_and_event_id",
                                          unique: true
    end

    create_table "swing_dates", id: :serial, force: :cascade do |t|
      t.datetime "created_at", precision: nil
      t.datetime "updated_at", precision: nil
      t.date "date"
      t.index ["date"], name: "index_swing_dates_on_date", unique: true
    end
  end
end
