# frozen_string_literal: true

class EditEventForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Frequency

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
      new(EditableEvent.new(event).attributes)
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
  validates :first_date, date_string: true
  validates :last_date, date_string: true

  validates_with ValidSocialOrClass
  validates_with ValidWeeklyEvent
  validates_with Form::ValidEventWithDates
  validates_with ValidCancellations

  def action
    "Update"
  end

  def persisted?
    true
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
    attributes.symbolize_keys.merge(
      dates: parsed_dates,
      cancellations: parsed_cancellations,
      has_class: has_weekly_class?,
      has_taster: has_occasional_class?,
      course_length: (course_length.to_i if course_length.present?)
    ).except(
      :social_has_class
    )
  end

  # has_class? and has_social? are only used in validations - not ideal
  def has_social? # rubocop:disable Naming/PredicateName
    type_is_social_dance?
  end

  def has_class? # rubocop:disable Naming/PredicateName
    type_is_weekly_class? || !!social_has_class
  end

  def parsed_dates
    date_parser.parse(dates)
  end

  def parsed_cancellations
    date_parser.parse(cancellations)
  end

  def type_is_weekly_class?
    event_type == "weekly_class"
  end

  private

  def type_is_social_dance?
    event_type == "social_dance"
  end

  def has_weekly_class? # rubocop:disable Naming/PredicateName
    type_is_weekly_class? || (type_is_social_dance? && social_has_class && weekly?)
  end

  def has_occasional_class? # rubocop:disable Naming/PredicateName
    infrequent? && social_has_class
  end

  def date_parser
    DatesStringParser.new
  end

  class EditableEvent
    def initialize(event)
      @event = event
    end

    delegate(
      :title,
      :url,
      :venue_id,
      :social_organiser_id,
      :social_organiser_id,
      :class_style,
      :course_length,
      :class_organiser_id,
      :frequency,
      :day,
      to: :event
    )

    def event_type
      event.has_social? ? "social_dance" : "weekly_class"
    end

    def social_has_class
      event.has_social? && (event.has_class? || event.has_taster?)
    end

    def dates
      date_printable_event.print_dates
    end

    def cancellations
      date_printable_event.print_cancellations
    end

    def first_date
      format_date(event.first_date)
    end

    def last_date
      format_date(event.last_date)
    end

    def attributes
      {
        title:,
        url:,
        venue_id:,
        event_type:,

        social_organiser_id:,
        social_has_class:,

        class_style:,
        course_length:,
        class_organiser_id:,

        frequency:,
        day:,
        dates:,
        cancellations:,
        first_date:,
        last_date:
      }
    end

    private

    attr_reader :event

    def format_date(date)
      date&.to_fs(:db)
    end

    def date_printable_event
      DatePrintableEvent.new(event)
    end
  end
end
