# frozen_string_literal: true

class DistantPastDateValidator < ActiveModel::EachValidator
  SOLDN_START_DATE = Date.parse("2010-08-16")

  def validate_each(record, attribute, value)
    return if value.blank?
    return if value >= SOLDN_START_DATE

    record.errors.add(attribute, :distant_past)
  end
end
