# frozen_string_literal: true

class EventsController < CmsBaseController
  def index
    @events = Event.includes(:venue, :social_organiser, :class_organiser).order(has_social: :desc).order("title, updated_at")
  end

  def show
    event = Event.find(params[:id])
    @last_update = LastUpdate.new(event)
    @event = ShowEvent.new(event)
    @warning = @event.warning
  end

  def new
    @form = CreateEventForm.new(venue_id: params[:venue_id])
  end

  def edit
    @event = Event.find(params[:id])
    @form = EditEventForm.from_event(@event)
  end

  def create
    @form = CreateEventForm.new(event_params)

    if @form.valid?
      event = Event.create!(@form.to_h)
      flash[:notice] = t("flash.success", model: "Event", action: "created")
      redirect_to(event)
    else
      render action: "new"
    end
  end

  def update # rubocop:disable Metrics/MethodLength
    @event = Event.find(params[:id])

    @form = EditEventForm.new(event_params)
    if @form.valid?
      audit_comment = EventParamsCommenter.new.comment(@event, event_params)
      update_params = @form.to_h.merge!(audit_comment)
      @event.update!(update_params)
      flash[:notice] = t("flash.success", model: "Event", action: "updated")
      redirect_to(@event)
    else
      render action: "edit"
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to events_path
  end

  def archive
    @event = Event.find(params[:id])
    @event.archive!
    # TODO: handle case where save fails or already archived (archive = false)

    redirect_to events_path
  end

  private

  def event_params
    params.require(:event).permit(
      %i[
        title
        venue_id
        social_organiser_id
        class_organiser_id
        event_type
        has_taster
        has_class
        has_social
        class_style
        course_length
        day
        frequency
        dates
        cancellations
        first_date
        last_date
        url
      ]
    )
  end
end
