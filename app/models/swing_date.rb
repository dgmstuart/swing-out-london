class SwingDate < ActiveRecord::Base
  has_and_belongs_to_many :events, :uniq => true
  has_and_belongs_to_many :cancelled_events, :class_name => "Event", :join_table => "events_swing_cancellations", :uniq => true

  validates_uniqueness_of :date

  scope :listing_dates, -> (start_date, end_date) { where("date >= ? AND date <= ?", start_date, end_date).order( "Date ASC") }
end
