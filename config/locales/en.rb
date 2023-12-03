# frozen_string_literal: true

def ordinal_day(date)
  ActiveSupport::Inflector.ordinalize(date.day)
end

def human_date(date)
  "%A #{ordinal_day(date)} %B"
end

{
  en: {
    time: {
      formats: {
        audit_timestamp: lambda { |date|
          date.strftime("on #{human_date(date)} %Y at %H:%M:%S") # on Tuesday 5th December 2017 at 13:08:28
        },
        last_updated: lambda { |date|
          date.strftime("at %H:%M on #{human_date(date)}") # at 01:04 on Saturday 2nd December
        }
      }
    },
    date: {
      formats: {
        short: lambda { |date|
          date.strftime("#{ordinal_day(date)} %b")
        },
        listing_date: lambda { |date|
          date.strftime(human_date(date)) # Monday 4th December
        }
      }
    }
  }
}
