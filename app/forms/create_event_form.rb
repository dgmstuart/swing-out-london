# frozen_string_literal: true

class CreateEventForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :url, :string
  attribute :venue_id, :integer

  attribute :has_social, :boolean
  attribute :social_organiser_id, :integer

  attribute :has_class, :boolean
  attribute :has_taster, :boolean
  attribute :class_style, :string
  attribute :course_length, :string
  attribute :class_organiser_id, :integer

  attribute :frequency, :integer
  attribute :day, :string
  attribute :dates, :string
  attribute :cancellations, :string
  attribute :first_date, :string
  attribute :last_date, :string

  def self.model_name
    Event.model_name
  end

  validates :url, presence: true, uri: true
  validates :venue_id, presence: true
  validates :frequency, presence: true
  validates :course_length, numericality: { only_integer: true, greater_than: 0, allow_blank: true }

  validates_with ValidSocialOrClass
  validates_with ValidWeeklyEvent

  def action
    "Create"
  end

  def weekly?
    frequency == 1
  end

  def infrequent?
    return false if frequency.nil?

    frequency.zero? || frequency >= 4
  end

  def has_social? # rubocop:disable Naming/PredicateName
    !!has_social
  end

  def has_class? # rubocop:disable Naming/PredicateName
    !!has_class
  end

  def to_h
    attributes.merge(
      "dates" => DatesStringParser.new.parse(dates),
      "cancellations" => DatesStringParser.new.parse(cancellations)
    )
  end
end
