# frozen_string_literal: true

class Venue < ApplicationRecord
  geocoded_by :postcode,
              latitude: :lat,
              longitude: :lng
  audited

  has_many :events, dependent: :restrict_with_exception

  scope :all_with_classes_listed, -> { where(id: Event.listing_classes.select('distinct venue_id')) }
  scope :all_with_classes_listed_on_day, ->(day) { where(id: Event.listing_classes_on_day(day).select('distinct venue_id')) }

  validates :address, presence: true
  validates :area, presence: true
  validates :name, presence: true
  validates :website, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  before_validation do
    if (lat.nil? || lng.nil?) && !geocode
      errors.add :lat, "The address information could not be geocoded.
          Please check the address information or manually enter
          latitude and longitude"
    end
  end
  UNKNOWN_POSTCODE = '???'

  def outward_postcode
    return UNKNOWN_POSTCODE if postcode.blank?

    # Match the first part of the postcode:
    regexp = /[A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]?/
    regexp.match(postcode.upcase)[0]
  end

  def name_and_area
    "#{name} - #{area}"
  end

  # Are there any active events associated with this venue?
  def all_events_out_of_date?
    events.all?(&:out_of_date)
  end

  def all_events_nearly_out_of_date?
    events.all?(&:near_out_of_date)
  end

  # Map-related methods:
  def position
    [lat, lng] unless lat.nil? || lng.nil?
  end

  def coordinates
    "[ #{lat}, #{lng} ]"
  end

  def can_delete?
    events.empty?
  end
end
