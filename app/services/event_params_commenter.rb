# frozen_string_literal: true

class EventParamsCommenter
  def comment(event, update_params)
    return {} if update_params.empty?

    if changed_dates(event, update_params)
      { audit_comment: 'Updated dates' }
    else
      {}
    end
  end

  def changed_dates(event, update_params)
    (event.print_dates != update_params[:date_array]) ||
      (event.print_cancellations != update_params[:cancellation_array])
  end
end
