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

  # Is the next expected date more than 3 months away?
  def expected_date_is_soon?
    @expected_date < @comparison_date + 3.months
  end

  class NoExpectedDate
    def <(other_date)
      false
    end
  end
end
