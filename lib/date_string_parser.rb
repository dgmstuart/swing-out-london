# frozen_string_literal: true

class DateStringParser
  def parse(date_string)
    # if the string contains extra characters,
    # Date.strptime will parse the part of the string which looks like a date
    # and ignore the rest
    return false unless contains_only_date_characters(date_string)

    Date.strptime(date_string, "%d/%m/%Y")
  rescue Date::Error
    false
  end

  private

  def contains_only_date_characters(string)
    !!string.match(%r{^[0-9/]+$})
  end
end
