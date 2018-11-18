# frozen_string_literal: true

class EventParamsCommenter
  def comment(event, update_params)
    return {} if update_params.empty?

    comment = {}

    if changed_dates(event, update_params)
      audit_comment = comment_template('Updated dates', event.print_dates, update_params[:date_array])
      comment.merge!(audit_comment)
    end

    if changed_cancellations(event, update_params)
      audit_comment = comment_template('Updated cancellations', event.print_cancellations, update_params[:cancellation_array])
      comment.merge!(audit_comment) { |_key, comment1, comment2| comment1 + comment2 }
    end

    comment
  end

  private

  def changed_dates(event, update_params)
    (event.print_dates != update_params[:date_array])
  end

  def changed_cancellations(event, update_params)
    (event.print_cancellations != update_params[:cancellation_array])
  end

  def comment_template(message, old, new)
    { audit_comment: "#{message}: (old: #{old}) (new: #{new})" }
  end
end
