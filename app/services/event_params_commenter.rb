# frozen_string_literal: true

# Creates a comment to augment an audit log entry for an {Event} with
# information about changes to dates and cancellations
class EventParamsCommenter
  def initialize
    @date_printer = DatePrinter.new
  end

  def comment(event, update_params)
    return {} if update_params.empty?

    dates = update_params[:dates]
    cancellations = update_params[:cancellations]

    messages = []

    messages << updated_dates_comment(event, dates) if changed_dates?(event, dates)
    messages << updated_cancellations_comment(event, cancellations) if changed_cancellations?(event, cancellations)

    return {} if messages.empty?

    { audit_comment: messages.join(" ") }
  end

  private

  attr_reader :date_printer

  def updated_dates_comment(event, dates)
    comment_text("Updated dates", event.dates, dates)
  end

  def updated_cancellations_comment(event, cancellations)
    comment_text("Updated cancellations", event.cancellations, cancellations)
  end

  def changed_dates?(event, dates)
    return false if dates.nil?

    event.dates != dates
  end

  def changed_cancellations?(event, cancellations)
    return false if cancellations.nil?

    event.cancellations != cancellations
  end

  def comment_text(message, old, new)
    "#{message}: (old: #{date_printer.print(old)}) (new: #{date_printer.print(new)})"
  end
end
