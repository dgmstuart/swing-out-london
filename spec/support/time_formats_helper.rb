# frozen_string_literal: true

# All the parts of Rails required to load and use time formats in isolated specs
require "active_support"
require "active_support/core_ext/date/conversions"
require "active_support/core_ext/time/conversions"
require "active_support/core_ext/integer/inflections"

locale_files = %w[en.yml en.rb].map do |locale_file|
  File.expand_path(locale_file, File.expand_path("../../config/locales", __dir__))
end

# Allow reference to translations in isolated specs,
# but only load the files if they're not already in the load path
locale_files.each do |file|
  I18n.load_path.push(file) unless I18n.load_path.include?(file)
end
