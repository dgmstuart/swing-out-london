# frozen_string_literal: true

class Organiser < ApplicationRecord
  audited

  has_many :classes, class_name: 'Event', foreign_key: 'class_organiser_id'
  has_many :socials, class_name: 'Event', foreign_key: 'social_organiser_id'

  default_scope -> { order(name: :asc) } # sets default search order

  validates :name, presence: true

  validates :shortname, length: { maximum: 20 }
  validates :shortname, uniqueness: { allow_nil: true, allow_blank: true }

  def events
    classes + socials
  end

  # Are there any active events associated with this organiser?
  def all_events_out_of_date?
    events.each do |event|
      # not out of date means there is at least one event which has current dates...
      return false unless event.out_of_date
    end

    true
  end

  def all_events_nearly_out_of_date?
    events.each do |event|
      # not out of date means there is at least one event which has current dates...
      return false unless event.near_out_of_date
    end

    true
  end
end
