# frozen_string_literal: true

# Filters sensitive data out of logs.
#
# Rails only handles filtering sensitive _parameters_.
class FilteringLoggerFormatter
  def initialize(base_formatter)
    @base_formatter = base_formatter
  end

  def call(severity, time, progname, message)
    @base_formatter.call(severity, time, progname, filter(message))
  end

  private

  def filter(message)
    message.gsub(/(Authorization: Bearer )\w+/, '\1[FILTERED]')
    message.gsub(/(fb_exchange_token=)\w+/, '\1[FILTERED]')
    message.gsub(/(client_secret=)\w+/, '\1[FILTERED]')
    message.gsub(/(appsecret_proof=)\w+/, '\1[FILTERED]')
  end
end
