class OutOfDateCalculator
  def initialize(latest_date, comparison_date)
    @latest_date = latest_date || NoLatestDate.new
    @comparison_date = comparison_date
  end

  def out_of_date?
    @latest_date < @comparison_date
  end

private

  class NoLatestDate
    def <(other_date)
      true
    end
  end
end
