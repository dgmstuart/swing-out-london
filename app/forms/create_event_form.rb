# frozen_string_literal: true

class CreateEventForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :url, :string
  attribute :venue_id, :integer
  attribute :event_type, :string

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

  class << self
    def model_name
      Event.model_name
    end
  end

  validates :url, presence: true, uri: true
  validates :venue_id, presence: true
  validates :event_type, presence: true, inclusion: { in: %w[social_dance weekly_class], allow_blank: true }
  validates :frequency, presence: true, inclusion: { in: [0, 1], allow_blank: true }
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
      "has_social" => type_is_social_dance?,
      "has_class" => has_weekly_class?,
      "has_taster" => has_occasional_class?
    ).except(
      "event_type",
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
