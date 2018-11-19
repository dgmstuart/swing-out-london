# frozen_string_literal: true

class EventsController < CMSBaseController
  def index
    @current_events = Event.current.includes(:venue, :social_organiser, :class_organiser).order('frequency, updated_at')
    @gigs = Event.gigs.includes(:venue, :social_organiser, :class_organiser).order('title')
    @archived_events = Event.archived.includes(:venue, :social_organiser, :class_organiser).order('title')
  end

  def show
    event = Event.find(params[:id])
    @last_update = LastUpdate.new(event)
    @event = ShowEvent.new(event)
    @warning = @event.warning
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

    audit_comment = EventParamsCommenter.new.comment(@event, event_params)
    update_params = event_params.merge!(audit_comment)

    if @event.update(update_params)
      flash[:notice] = 'Event was successfully updated.'
      redirect_to(@event)
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
