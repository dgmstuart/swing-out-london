# frozen_string_literal: true

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
  end
end
