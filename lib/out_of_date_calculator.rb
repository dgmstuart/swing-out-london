class OutOfDateCalculator
  def initialize(dates, latest_date, frequency)
    @dates = dates
    @latest_date = latest_date
    @frequency = frequency
  end

  def out_of_date
    out_of_date_test(Date.local_today)
  end

  def near_out_of_date
    out_of_date_test(Date.local_today + INITIAL_SOCIALS)
  end

private

  # Helper function for comparing event dates to a reference date
  def out_of_date_test(comparison_date)
    return false if @frequency==1 # Weekly events shouldn't have date arrays...
    return false if infrequent_in_date # Really infrequent events shouldn't be considered out of date until they are nearly due.

    return true if @dates.blank?
    return false if @latest_date >= comparison_date
    true
  end

  # For infrequent events (6 months or less), is the next expected date (based on the last known date)
  # more than 3 months away?
  def infrequent_in_date
    return false if @dates.blank?
    return false if @frequency < 26

    expected_date = @latest_date + @frequency.weeks #Belt and Braces: the date array should already be sorted.
    expected_date > Date.local_today + 3.months
  end
end
