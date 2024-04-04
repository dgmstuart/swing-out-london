# frozen_string_literal: true

# Form object to ensure that we catch dates which are valid, but probably typos
# because they're unrealistically far in the past or future.
#
# Not a form object in the same sense as the others - it doesn't back an HTML
# form and only deals with validations.
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
