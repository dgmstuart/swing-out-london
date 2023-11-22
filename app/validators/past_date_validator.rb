# frozen_string_literal: true

class PastDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if value >= Date.current

    record.errors.add(attribute, :past)
  end
end
