# frozen_string_literal: true

class EventsSwingDate < ApplicationRecord
  belongs_to :event, touch: true
  belongs_to :swing_date
end
