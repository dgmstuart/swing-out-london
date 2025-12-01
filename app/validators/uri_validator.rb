# frozen_string_literal: true

class URIValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if value =~ /\A\s*#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}/

    record.errors.add attribute, (options[:message] || "is not a valid URI")
  end
end
