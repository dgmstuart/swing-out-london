# frozen_string_literal: true

class SwingDate < ApplicationRecord
  has_and_belongs_to_many :events, -> { distinct(true) }
  has_and_belongs_to_many :cancelled_events, -> { distinct(true) }, class_name: "Event", join_table: "events_swing_cancellations" # rubocop:disable Layout/LineLength

  validates :date, uniqueness: true

  scope :listing_dates, ->(start_date, end_date) { where("date >= ? AND date <= ?", start_date, end_date).order("Date ASC") }
end
