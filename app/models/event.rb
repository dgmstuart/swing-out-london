# frozen_string_literal: true

require "dates_string_parser"

# The main model representing dance classes and social dances
class Event < ApplicationRecord # rubocop:disable Metrics/ClassLength
  audited

  include Frequency

  CONSIDERED_NEW_FOR = 1.month

  belongs_to :venue
  belongs_to :class_organiser, class_name: "Organiser", optional: true
  belongs_to :social_organiser, class_name: "Organiser", optional: true
  has_many :event_instances, dependent: :destroy
  has_many :email_deliveries, dependent: :destroy

  validates :frequency, presence: true
  validates :url, presence: true, uri: true

  validates :course_length, numericality: { only_integer: true, greater_than: 0, allow_nil: true }

  validates :organiser_token, uniqueness: true, allow_nil: true
  validates :reminder_email_address, absence: true, if: -> { organiser_token.blank? }
  validates :reminder_email_address, email: { allow_blank: true }

  validate :has_class_or_social
  validate :must_be_weekly_if_no_social
  validate :cannot_be_weekly_and_have_dates
  validate :cannot_have_dates_after_last_date

  validates_with ValidSocialOrClass
  validates_with ValidWeeklyEvent

  enum(:day, DAYNAMES.index_by { _1 })

  strip_attributes only: %i[title url]

  class << self
    def socials_on_date(date)
      weekly_socials_on(date).includes(:venue) +
        occasional_socials_on(date).includes(:venue)
    end

    def socials_on_date_for_venue(date, venue)
      weekly_socials_on(date).where(venue_id: venue.id) +
        occasional_socials_on(date).where(venue_id: venue.id)
    end

    def weekly_socials_on(date)
      join_sql = Event.sanitize_sql(
        [
          "LEFT OUTER JOIN event_instances ON (event_instances.event_id = events.id AND event_instances.date = :date)",
          { date: }
        ]
      )
      weekly.socials.active_on(date).on_same_day_of_week(date)
            .joins(join_sql)
            .select("events.*", "event_instances.cancelled")
    end

    def occasional_socials_on(date)
      occasional.socials.joins(:event_instances).where(event_instances: { date: })
                .select("events.*", "event_instances.cancelled")
    end
  end

  def has_class_or_social # rubocop:disable Naming/PredicateName
    return true if has_class? || has_social?

    errors.add(:base, "Events must have either a Social or a Class, otherwise they won't be listed")
  end

  def must_be_weekly_if_no_social
    return if has_social? || weekly? || frequency.nil?

    errors.add(:frequency, "must be 1 (weekly) for events without a social")
  end

  def cannot_be_weekly_and_have_dates
    return unless weekly? && event_instances.any? { _1.cancelled == false }

    errors.add(:event_instances, "must all be cancelled for weekly events")
  end

  def cannot_have_dates_after_last_date
    return if latest_date.blank?
    return if last_date.blank?
    return unless latest_date > last_date

    errors.add(:dates, "can't include dates after the last date")
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
  scope :occasional, -> { where(frequency: 0) }

  scope :active, -> { where("last_date IS NULL OR last_date > ?", Date.current) }
  scope :ended, -> { where("last_date IS NOT NULL AND last_date < ?", Date.current) }
  scope :active_on, lambda { |date|
    where(
      "(first_date IS NULL OR first_date <= :date) AND (last_date IS NULL OR last_date >= :date)",
      date:
    )
  }

  scope :listing_classes, -> { active.weekly_or_fortnightly.classes }
  scope :listing_classes_on_day, ->(day) { listing_classes.where(day:) }
  scope :listing_classes_at_venue, ->(venue) { listing_classes.where(venue_id: venue.id) }
  scope :listing_classes_on_day_at_venue, ->(day, venue) { listing_classes_on_day(day).where(venue_id: venue.id) }

  scope :on_same_day_of_week, ->(date) { where(day: I18n.l(date, format: :day_name)) }

  scope :notifiable, -> { where.not(reminder_email_address: nil) }

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
    return [] if weekly?

    Rails.cache.fetch(dates_cache_key) do
      event_instances.order(date: :asc).map(&:date)
    end
  end

  after_save :clear_dates_cache
  def clear_dates_cache
    Rails.cache.delete(dates_cache_key)
  end

  def cancellations
    event_instances.cancelled.map(&:date)
  end

  def future_cancellations
    event_instances.cancelled.where(date: Date.current..).map(&:date)
  end

  # COMPARISON METHODS #

  def future_dates?
    return true if weekly? # Weekly events don't have date arrays but implicitly will be running in the future
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
    return true if first_date.nil?

    first_date < Date.current
  end

  # Has the last instance of the event happened?
  def ended?
    return false if last_date.nil?

    last_date < Date.current
  end

  def latest_date_cache_key
    caching_key("latest_date")
  end

  # What's the Latest date in the date array
  # N.B. Assumes the date array is sorted!
  def latest_date
    Rails.cache.fetch(latest_date_cache_key) do
      event_instances.maximum(:date)
    end
  end

  after_save :clear_latest_dates_cache
  def clear_latest_dates_cache
    Rails.cache.delete(latest_date_cache_key)
  end

  def generate_organiser_token
    update(organiser_token: SecureRandom.hex)
  end

  def last_reminder_delivered_at
    email_deliveries.last&.created_at
  end
end
