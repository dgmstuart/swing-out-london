# frozen_string_literal: true

class EventInstance < ApplicationRecord
  belongs_to :event, touch: true

  validates :date, uniqueness: { scope: :event_id }

  scope :cancelled, -> { where(cancelled: true) }
  scope :not_cancelled, -> { where(cancelled: false) }
end
