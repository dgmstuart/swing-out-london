# frozen_string_literal: true

class DatesStringParser
  def parse(date_string)
    String(date_string).split(',').map { |ds| safe_parse_date(ds) }.compact.uniq
  end

  private

  def safe_parse_date(date_string)
    date_string.to_date
  rescue ArgumentError
    # TODO: Log?
  end
end
