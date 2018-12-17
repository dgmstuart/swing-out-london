# frozen_string_literal: true

class EventsController < CMSBaseController
  def index
    @current_events = Event.current.includes(:venue, :social_organiser, :class_organiser).order('frequency, updated_at')
    @gigs = Event.gigs.includes(:venue, :social_organiser, :class_organiser).order('title')
    @archived_events = Event.archived.includes(:venue, :social_organiser, :class_organiser).order('title')
  end

  def show
    @event = Event.find(params[:id])
    @last_update = LastUpdate.new(@event)

    if !@event.has_class? && !@event.has_social?
      @warning = if @event.has_taster?
                   "This event has a taster but no class or social, so it won't show up in the listings"
                 else
                   "This event doesn't have class or social, so it won't show up in the listings"
                 end
    end
  end

  def new
    venue = Venue.find_by(id: params[:venue_id])
    @event = Event.new(venue: venue)
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect_to(@event)
    else
      render action: 'new'
    end
  end

  def update
    @event = Event.find(params[:id])

    result = UpdateEvent.new.update(@event, event_params)
    if result.success?
      flash[:notice] = 'Event was successfully updated.'
      redirect_to(result.updated_event)
    else
      render action: 'edit'
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
      :title,
      :venue_id,
      :social_organiser_id,
      :class_organiser_id,
      :event_type,
      :has_taster,
      :has_class,
      :has_social,
      :class_style,
      :course_length,
      :day,
      :frequency,
      :date_array,
      :cancellation_array,
      :first_date,
      :expected_date,
      :last_date,
      :url
    )
  end
end
