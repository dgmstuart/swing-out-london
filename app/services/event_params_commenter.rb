# frozen_string_literal: true

class EventParamsCommenter
  def comment(event, update_params)
    return {} if update_params.empty?

    messages = []

    messages << updated_dates_comment(event, update_params) if changed_dates(event, update_params)
    messages << updated_cancellations_comment(event, update_params) if changed_cancellations(event, update_params)

    return {} if messages.empty?

    { audit_comment: messages.join(" ") }
  end

  private

  def updated_dates_comment(event, update_params)
    comment_text("Updated dates", event.print_dates, update_params[:date_array])
  end

  def updated_cancellations_comment(event, update_params)
    comment_text("Updated cancellations", event.print_cancellations, update_params[:cancellation_array])
  end

  def changed_dates(event, update_params)
    (event.print_dates != update_params[:date_array])
  end

  def changed_cancellations(event, update_params)
    (event.print_cancellations != update_params[:cancellation_array])
  end

  def comment_text(message, old, new)
    "#{message}: (old: #{old}) (new: #{new})"
  end
end
