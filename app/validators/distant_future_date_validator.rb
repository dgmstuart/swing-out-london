# frozen_string_literal: true

class DistantFutureDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if value < 2.years.from_now

    record.errors.add(attribute, :distant_future)
  end
end
