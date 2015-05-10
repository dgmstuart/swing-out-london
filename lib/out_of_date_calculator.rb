class OutOfDateCalculator
  def initialize(latest_date, expecting_a_date, comparison_date)
    @latest_date = latest_date || NoLatestDate.new
    @expecting_a_date = expecting_a_date
    @comparison_date = comparison_date
  end

  def out_of_date
    return false if not @expecting_a_date

    @latest_date < @comparison_date
  end

private

  class NoLatestDate
    def <(other_date)
      true
    end
  end
end
