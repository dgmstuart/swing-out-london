# frozen_string_literal: true

class ExternalEventsController < CmsBaseController
  layout "organiser"

  def edit
    @event = Event.find_by!(organiser_token: params[:id])
    @form = OrganiserEditEventForm.from_event(@event)
  end

  def update # rubocop:disable Metrics/MethodLength
    @event = Event.find_by!(organiser_token: params[:id])

    @form = OrganiserEditEventForm.new(event_params)
    if @form.valid?
      audit_comment = EventParamsCommenter.new.comment(@event, event_params)
      update_params = @form.to_h.merge!(audit_comment)
      @event.update!(update_params)
      flash[:success] = t("flash.success", model: "Event", action: "updated")
      redirect_to edit_external_event_path(@event.organiser_token)
    else
      render action: "edit"
    end
  end

  private

  def authenticate
    organiser_token = params[:id]
    Event.find_by!(organiser_token:)

    @current_user = OrganiserUser.new(organiser_token)
  end

  def event_params
    params.require(:event).permit(
      %i[
        venue_id
        dates
        cancellations
        last_date
      ]
    )
  end
end
