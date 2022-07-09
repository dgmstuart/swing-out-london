# frozen_string_literal: true

class Organiser < ApplicationRecord
  audited

  has_many :classes,
           class_name: 'Event', foreign_key: 'class_organiser_id', inverse_of: :class_organiser, dependent: :restrict_with_exception
  has_many :socials,
           class_name: 'Event', foreign_key: 'social_organiser_id', inverse_of: :social_organiser, dependent: :restrict_with_exception

  default_scope -> { order(name: :asc) } # sets default search order

  validates :name, presence: true

  validates :shortname, length: { maximum: 20 }
  validates :shortname, uniqueness: { allow_blank: true }

  strip_attributes only: %i[name shortname website]

  def shortname=(value)
    if value.blank?
      super(nil)
    else
      super
    end
  end

  def events
    Event
      .where(class_organiser_id: id)
      .or(Event.where(social_organiser_id: id))
  end

  def all_events_out_of_date?
    events.all?(&:out_of_date)
  end

  def all_events_nearly_out_of_date?
    events.all?(&:near_out_of_date)
  end

  def can_delete?
    events.empty?
  end
end
