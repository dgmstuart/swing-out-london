# frozen_string_literal: true

class OrganiserEditEventForm
  include ActiveModel::Model
  include ActiveModel::Attributes

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

  def self.model_name
    Event.model_name
  end

  validates :venue_id, presence: true

  def to_h
    attributes.merge(
      "dates" => DatesStringParser.new.parse(dates),
      "cancellations" => DatesStringParser.new.parse(cancellations)
    )
  end

  def persisted?
    true
  end
end
