# frozen_string_literal: true

class ExternalEventsController < CmsBaseController
  layout "organiser"

  def edit
    @event = find_event
    @form = OrganiserEditEventForm.from_event(@event)
    @status = EventStatus.new(@event)
  end

  def update
    @event = find_event
    @form = OrganiserEditEventForm.new(event_params(@event))
    if @form.valid?
      EventUpdater.new(@event).update!(@form.to_h)
      flash[:notice] = t("flash.success", model: "Event", action: "updated")
      redirect_to edit_external_event_path(@event.organiser_token)
    else
      @status = EventStatus.new(@event)
      render action: "edit"
    end
  end

  private

  def find_event
    Event.find_by!(organiser_token: params[:id])
  end

  def authenticate
    organiser_token = params[:id]
    Event.find_by!(organiser_token:)

    @current_user = OrganiserUser.new(organiser_token)
  end

  def event_params(event)
    params.require(:event).permit(
      %i[
        venue_id
        dates
        cancellations
        last_date
      ]
    ).merge(frequency: event.frequency)
  end
end
