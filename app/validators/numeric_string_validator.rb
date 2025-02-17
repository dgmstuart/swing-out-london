# frozen_string_literal: true

class NumericStringValidator < ActiveModel::Validations::FormatValidator
  def initialize(options)
    options = options.dup
    options[:with]    ||= /\A\d+\z/
    options[:message] ||= "must contain only digits"
    super
  end
end
