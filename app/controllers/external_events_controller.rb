# frozen_string_literal: true

class ExternalEventsController < CmsBaseController
  layout "organiser"

  def edit
    @event = Event.find_by!(organiser_token: params[:id])
  end

  def update
    @event = Event.find_by!(organiser_token: params[:id])

    audit_comment = EventParamsCommenter.new.comment(@event, event_params)
    update_params = event_params.merge!(audit_comment)

    if @event.update(update_params)
      flash[:success] = t("flash.success", model: "Event", action: "updated")
      redirect_to edit_external_event_path(@event.organiser_token)
    else
      render action: "edit"
    end
  end

  private

  def authenticate
    organiser_token = params[:id]
    if Event.where(organiser_token:).load.exists?
      @current_user = OrganiserUser.new(organiser_token)
    else
      redirect_to root_path
    end
  end

  def event_params
    params.require(:event).permit(
      %i[
        venue_id
        date_array
        cancellation_array
        last_date
      ]
    )
  end
end
