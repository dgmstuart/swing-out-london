# frozen_string_literal: true

class EventsSwingCancellation < ApplicationRecord
  belongs_to :event, touch: true
  belongs_to :swing_date
end
