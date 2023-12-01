# frozen_string_literal: true

require "dates_string_parser"

class OrganiserEditEventForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Frequency

  class << self
    def from_event(event)
      date_printable_event = DatePrintableEvent.new(event)
      new(
        {
          venue_id: event.venue_id,
          dates: date_printable_event.print_dates,
          cancellations: date_printable_event.print_cancellations,
          last_date: event.last_date&.to_fs
        }
      )
    end
  end

  attribute :venue_id, :integer
  attribute :dates, :string
  attribute :cancellations, :string
  attribute :last_date, :string
  attribute :frequency, :integer # frequency is only used to decide what validations should be done - not persisted.

  def self.model_name
    Event.model_name
  end

  validates :venue_id, presence: true
  validates :dates, dates_string: { allow_past: true }
  validates :cancellations, dates_string: { allow_past: true }
  validates :last_date, date_string: true

  validates_with ValidCancellations

  def to_h
    attributes.symbolize_keys.merge(
      dates: parsed_dates,
      cancellations: parsed_cancellations
    ).except(:frequency)
  end

  def persisted?
    true
  end

  def parsed_dates
    date_parser.parse(dates)
  end

  def parsed_cancellations
    date_parser.parse(cancellations)
  end

  # define #day= to allow us to use the ValidCancellations validator
  def day=(_); end

  private

  def date_parser
    DatesStringParser.new
  end
end
