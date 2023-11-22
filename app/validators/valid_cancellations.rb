# frozen_string_literal: true

class ValidCancellations < ActiveModel::Validator
  def validate(event)
    return if event.weekly?

    cancellations_not_in_dates = event.parsed_cancellations - event.parsed_dates

    return if cancellations_not_in_dates.empty?

    print_cancellations = date_printer.print(cancellations_not_in_dates)
    event.errors.add(:cancellations, "contained dates which are not in the list of upcoming dates: #{print_cancellations}")
  end

  private

  def date_printer
    DatePrinter.new(separator: ", ")
  end
end
