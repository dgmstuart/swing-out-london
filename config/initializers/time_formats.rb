Date::DATE_FORMATS[:uk_date] = "%d/%m/%Y"
Date::DATE_FORMATS[:uk_time] = "%d/%m/%Y %H:%M"
Date::DATE_FORMATS[:pretty_date] = lambda { |date| date.strftime("#{date.day.ordinalize} %b") }


Time::DATE_FORMATS[:uk_date] = "%d/%m/%Y"
Time::DATE_FORMATS[:uk_time] = "%d/%m/%Y %H:%M"