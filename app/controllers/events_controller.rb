# frozen_string_literal: true

class EventsController < CmsBaseController
  def index
    @events =
      Event
      .includes(:venue, :social_organiser, :class_organiser)
      .order(has_social: :desc)
      .order("title, updated_at")
      .map { EventListItem.new(_1) }
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
    @form = CreateEventForm.new(create_event_params)

    if @form.valid?
      event = EventCreator.new.create!(@form.to_h)
      flash[:notice] = t("flash.success", model: "Event", action: "created")
      redirect_to(event)
    else
      render action: "new"
    end
  end

  def update
    @event = Event.find(params[:id])

    @form = EditEventForm.from_event(@event)
    @form.assign_attributes(update_event_params)
    if @form.valid?
      EventUpdater.new(@event).update!(@form.to_h)
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
    event = Event.find(params[:id])
    succeeded = EventArchiver.new.archive(event)

    flash.alert = t("flash.archive.failed") unless succeeded

    redirect_to events_path
  end

  private

  def create_event_params
    event_params(CreateEventForm.attribute_names)
  end

  def update_event_params
    event_params(EditEventForm.attribute_names)
  end

  def event_params(attribute_names)
    params.require(:event).permit(attribute_names)
  end
end
