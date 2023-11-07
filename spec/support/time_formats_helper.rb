# frozen_string_literal: true

# All the parts of Rails required to load and use time formats in isolated specs
require "active_support"
require "active_support/core_ext/date/conversions"
require "active_support/core_ext/time/conversions"
require "active_support/core_ext/integer/inflections"
require "config/initializers/time_formats"
