# frozen_string_literal: true

class DateForm
  include ActiveModel::Validations

  def initialize(date, allow_past:)
    @date = date
    @allow_past = allow_past
  end

  attr_reader :date

  validates :date, past_date: true, if: -> { !allow_past }
  validates :date, distant_past_date: true, if: -> { allow_past }
  validates :date, distant_future_date: true

  private

  attr_reader :allow_past
end
