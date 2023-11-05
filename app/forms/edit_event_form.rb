# frozen_string_literal: true

class EditEventForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :url, :string
  attribute :venue_id, :integer

  attribute :title, :string
  attribute :social_organiser_id, :integer
  attribute :social_has_class, :boolean

  attribute :class_style, :string
  attribute :course_length, :string
  attribute :class_organiser_id, :integer

  attribute :frequency, :integer
  attribute :day, :string
  attribute :dates, :string
  attribute :cancellations, :string
  attribute :first_date, :string
  attribute :last_date, :string

  attr_accessor :event_type

  class << self
    def from_event(event)
      date_printable_event = DatePrintableEvent.new(event)

      new(
        {
          title: event.title,
          url: event.url,
          venue_id: event.venue_id,
          # TODO: it's not necessarily true that it's only one or the other: legacy events might be neither...
          event_type: (event.has_social? ? "social_dance" : "weekly_class"),

          social_organiser_id: event.social_organiser_id,
          social_has_class: event.has_social? && (event.has_class? || event.has_taster?),

          class_style: event.class_style, course_length: event.course_length, class_organiser_id: event.class_organiser_id,

          frequency: event.frequency,
          day: event.day,
          dates: date_printable_event.print_dates,
          cancellations: date_printable_event.print_cancellations,
          first_date: event.first_date&.to_fs,
          last_date: event.last_date&.to_fs
        }
      )
    end

    def model_name
      Event.model_name
    end
  end

  validates :url, presence: true, uri: true
  validates :venue_id, presence: true
  validates :frequency, presence: true, inclusion: { in: [0, 1], allow_blank: true }
  validates :course_length, numericality: { only_integer: true, greater_than: 0, allow_blank: true }

  validates :dates, dates_string: { allow_past: true }
  validates :cancellations, dates_string: { allow_past: true }

  validates_with ValidSocialOrClass
  validates_with ValidWeeklyEvent
  validates_with Form::ValidEventWithDates

  def action
    "Update"
  end

  def persisted?
    true
  end

  def weekly?
    frequency == 1
  end

  def infrequent?
    return false if frequency.nil?

    frequency.zero? || frequency >= 4
  end

  def show_social_details?
    type_is_social_dance?
  end

  def show_class_details?
    type_is_weekly_class? || social_has_class
  end

  def show_when?
    !event_type.nil?
  end

  def to_h
    attributes.merge(
      "dates" => DatesStringParser.new.parse(dates),
      "cancellations" => DatesStringParser.new.parse(cancellations),
      "has_class" => has_weekly_class?,
      "has_taster" => has_occasional_class?
    ).except(
      "social_has_class"
    )
  end

  # has_class? and has_social? are only used in validations - not ideal
  def has_social? # rubocop:disable Naming/PredicateName
    type_is_social_dance?
  end

  def has_class? # rubocop:disable Naming/PredicateName
    type_is_weekly_class? || !!social_has_class
  end

  private

  def type_is_social_dance?
    event_type == "social_dance"
  end

  def type_is_weekly_class?
    event_type == "weekly_class"
  end

  def has_weekly_class? # rubocop:disable Naming/PredicateName
    type_is_weekly_class? || (type_is_social_dance? && social_has_class && weekly?)
  end

  def has_occasional_class? # rubocop:disable Naming/PredicateName
    infrequent? && social_has_class
  end
end
