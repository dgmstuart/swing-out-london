# frozen_string_literal: true

class EventInstance < ApplicationRecord
  belongs_to :event

  validates :date, uniqueness: { scope: :event_id }
end
