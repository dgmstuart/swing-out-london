# frozen_string_literal: true

# All the parts of Rails required to load and use time formats in isolated specs
require "active_support"
require "active_support/core_ext/date/conversions"
require "active_support/core_ext/time/conversions"
require "active_support/core_ext/integer/inflections"

# Allow reference to translations in isolated specs:
%w[en.yml en.rb].each do |locale_file|
  I18n.load_path.push(
    File.expand_path(locale_file, File.expand_path("../../config/locales", __dir__))
  )
end
