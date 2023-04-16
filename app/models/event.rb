# frozen_string_literal: true

require "dates_string_parser"
require "day_names"

class Event < ApplicationRecord
  audited

  CONSIDERED_NEW_FOR = 1.month

  belongs_to :venue
  belongs_to :class_organiser, class_name: "Organiser", optional: true
  belongs_to :social_organiser, class_name: "Organiser", optional: true
  has_many :events_swing_dates, dependent: :destroy
  has_many :swing_dates, -> { distinct(true) }, through: :events_swing_dates
  has_many :events_swing_cancellations, dependent: :destroy
  has_many :swing_cancellations, -> { distinct(true) }, through: :events_swing_cancellations, source: :swing_date

  validates :event_type, presence: true
  validates :frequency, presence: true
  validates :url, presence: true, uri: true

  validates :course_length, numericality: { only_integer: true, greater_than: 0, allow_nil: true }

  validates :organiser_token, uniqueness: true, allow_nil: true

  validates_with ValidSocialOrClass
  validates_with ValidWeeklyEvent

  strip_attributes only: %i[title url]

  # display constants:
  NOTAPPLICABLE = "n/a"
  UNKNOWN_ORGANISER = "Unknown"
  SEE_WEB = "(See Website)"

  class << self
    # Find the datetime of the most recently updated event
    def last_updated_at
      maximum(:updated_at)
    end

    def socials_on_date(date)
      result = weekly_socials_on(date).includes(:venue)
      result += non_weekly_socials_on(date).includes(:venue)
      result
    end

    def socials_on_date_for_venue(date, venue)
      result = weekly_socials_on(date).where(venue_id: venue.id)
      result += non_weekly_socials_on(date).where(venue_id: venue.id)
      result
    end

    def weekly_socials_on(date)
      weekly.socials.active_on(date).on_same_day_of_week(date)
    end

    def non_weekly_socials_on(date)
      swing_date = SwingDate.find_by(date:)
      return none unless swing_date

      swing_date.events.socials
    end

    def less_frequent_socials_on(date)
      swing_date = SwingDate.find_by(date:)
      return none unless swing_date

      swing_date.events.socials.less_frequent
    end

    def cancelled_on_date(date)
      swing_date = SwingDate.find_by(date:)
      return [] unless swing_date

      swing_date.cancelled_events.pluck :id
    end
  end

  # ----- #
  # Venue #
  # ----- #

  delegate :name, to: :venue, prefix: true
  delegate :area, to: :venue, prefix: true
  delegate :postcode, to: :venue, prefix: true
  delegate :coordinates, to: :venue, prefix: true

  # ---------- #
  # Event Type #
  # ---------- #

  # scopes to get different types of event:
  scope :classes, -> { where(has_class: true) }
  scope :socials, -> { where(has_social: true) }
  scope :weekly, -> { where(frequency: 1) }
  scope :weekly_or_fortnightly, -> { where(frequency: [1, 2]) }
  scope :less_frequent, -> { where(frequency: 0).or(where(frequency: 4..52)) }

  scope :non_gigs, -> { where.not(event_type: "gig") }

  scope :active, -> { where("last_date IS NULL OR last_date > ?", Date.current) }
  scope :ended, -> { where("last_date IS NOT NULL AND last_date < ?", Date.current) }
  scope :active_on, ->(date) { where("(first_date IS NULL OR first_date <= ?) AND (last_date IS NULL OR last_date >= ?)", date, date) }

  scope :listing_classes, -> { active.weekly_or_fortnightly.classes }
  scope :listing_classes_on_day, ->(day) { listing_classes.where(day:) }
  scope :listing_classes_at_venue, ->(venue) { listing_classes.where(venue_id: venue.id) }
  scope :listing_classes_on_day_at_venue, ->(day, venue) { listing_classes_on_day(day).where(venue_id: venue.id) }

  scope :on_same_day_of_week, ->(date) { where(day: DayNames.name(date)) }

  def caching_key(suffix)
    "event_#{id}_#{suffix}"
  end

  # ----- #
  # Dates #
  # ----- #

  def dates_cache_key
    caching_key("dates")
  end

  def dates
    Rails.cache.fetch(dates_cache_key) do
      swing_dates.order("date ASC").collect(&:date)
    end
  end

  after_save :clear_dates_cache
  def clear_dates_cache
    Rails.cache.delete(dates_cache_key)
  end

  def add_date(new_date)
    swing_dates << SwingDate.find_or_initialize_by(date: new_date)
  end

  def dates=(array_of_new_dates)
    clear_dates_cache
    self.swing_dates = []
    array_of_new_dates.each { |nd| add_date(nd) }
  end

  def date_array=(date_string)
    self.dates = DatesStringParser.new.parse(date_string)
  end

  def cancellations
    swing_cancellations.collect(&:date)
  end

  def cancellations=(array_of_new_cancellations)
    self.swing_cancellations = []
    array_of_new_cancellations.each { |nc| add_cancellation(nc) }
  end

  def add_cancellation(new_cancellation)
    swing_cancellations << SwingDate.find_or_initialize_by(date: new_cancellation)
  end

  def cancellation_array=(date_string)
    self.cancellations = DatesStringParser.new.parse(date_string)
  end

  def future_cancellations
    filter_future(cancellations)
  end

  # READ METHODS #

  def date_array(future: false)
    return_array_of_dates(dates, future:)
  end

  def cancellation_array(future: false)
    return_array_of_dates(cancellations, future:)
  end

  private

  # Given an array of dates, return an appropriately filtered array
  def return_array_of_dates(input_dates, future:)
    return [] if input_dates.blank?

    input_dates = filter_future(input_dates) if future
    input_dates
  end

  # Given an array of dates, return only those in the future
  def filter_future(input_dates)
    # TODO: - should be able to simply replace this with some variant of ".future?", but need to test
    input_dates.select { |d| d >= Date.current }
  end

  public

  def inactive?
    ended? || (!future_dates? && one_off?)
  end

  # For the event listing tables:
  def status_string
    if inactive?
      "inactive"
    elsif !future_dates?
      "no_future_dates"
    end
  end

  # PRINT METHODS #

  def print_dates
    date_printer.print(dates)
  end

  def print_dates_rows
    if ended?
      "Ended"
    elsif weekly?
      "Every week on #{day.pluralize}"
    elsif dates.empty?
      "(No dates)"
    else
      date_rows_printer.print(dates.reverse)
    end
  end

  def print_cancellations
    date_printer.print(cancellations)
  end

  private

  def date_printer
    DatePrinter.new
  end

  def date_rows_printer
    DatePrinter.new(separator: ", ")
  end

  public

  # COMPARISON METHODS #

  def future_dates?
    return true if weekly? # Weekly events don't have date arrays but implicitly will be running in the future
    return false if last_date
    return false unless latest_date

    latest_date > Date.current
  end

  # Is the event new? (probably only applicable to classes)
  def new?
    return false if first_date.nil?

    first_date > Date.current - CONSIDERED_NEW_FOR
  end

  # Has the first instance of the event happened yet?
  def started?
    return false if first_date.nil?

    first_date < Date.current
  end

  # Has the last instance of the event happened?
  def ended?
    return false if last_date.nil?

    last_date < Date.current
  end

  def one_off?
    frequency.zero? && last_date == latest_date && first_date == latest_date
  end

  def weekly?
    frequency == 1
  end

  def infrequent?
    return false unless frequency

    frequency.zero? || frequency >= 4
  end

  def latest_date_cache_key
    caching_key("latest_date")
  end

  # What's the Latest date in the date array
  # N.B. Assumes the date array is sorted!
  def latest_date
    Rails.cache.fetch(latest_date_cache_key) do
      swing_dates.maximum(:date)
    end
  end

  after_save :clear_latest_dates_cache
  def clear_latest_dates_cache
    Rails.cache.delete(latest_date_cache_key)
  end

  ###########
  # ACTIONS #
  ###########

  def archive!
    return false if !last_date.nil? && last_date < Date.current

    # If there's already a last_date in the past, then the event should already be archived!

    self[:last_date] = if weekly?
                         Date.current.prev_occurring(day.downcase.to_sym)
                       elsif dates.nil?
                         Date.new # Earliest possible ruby date
                       else
                         latest_date
                       end

    return true if save!
  end
end
