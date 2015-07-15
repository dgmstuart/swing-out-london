class DateExpectationCalculator
  def initialize(infrequent, expected_date, comparison_date)
    @infrequent = infrequent
    @expected_date = expected_date || NoExpectedDate.new
    @comparison_date = comparison_date
  end

  def expecting_a_date?
    # For really infrequent events we're not expecting to have a date
    # until closer to the time:
    not(@infrequent) || expected_date_is_soon?
  end

private

  # Is the next expected date more than 6 weeks away?
  def expected_date_is_soon?
    @expected_date < @comparison_date + 6.weeks
  end
end

# Null Object
class NoExpectedDate
  include Comparable
  def to_s(format=:default)
    "Unknown"
  end
  def <=>(other)
    1 # Treat it as after every other date
  end
  def coerce(other)
    [other, Float::INFINITY]
  end
end
