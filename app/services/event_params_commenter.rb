# frozen_string_literal: true

class EventParamsCommenter
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

  def updated_dates_comment(event, dates)
    comment_text("Updated dates", event.print_dates, dates)
  end

  def updated_cancellations_comment(event, cancellations)
    comment_text("Updated cancellations", event.print_cancellations, cancellations)
  end

  def changed_dates?(event, dates)
    return false if dates.nil?

    event.print_dates != dates
  end

  def changed_cancellations?(event, cancellations)
    return false if cancellations.nil?

    event.print_cancellations != cancellations
  end

  def comment_text(message, old, new)
    "#{message}: (old: #{old}) (new: #{new})"
  end
end
