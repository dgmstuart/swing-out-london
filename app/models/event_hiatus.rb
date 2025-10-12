# frozen_string_literal: true

class EventHiatus < ApplicationRecord
  belongs_to :event

  validates :start_date, {
    presence: true,
    distant_past_date: true
  }
  validates :return_date, {
    presence: true,
    distant_past_date: true,
    comparison: { greater_than: :start_date, if: :start_date }
  }
end
