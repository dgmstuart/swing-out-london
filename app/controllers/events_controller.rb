class EventsController < ApplicationController
  layout 'cms'
  before_filter :authenticate
  
  caches_action :index
  cache_sweeper :event_sweeper, :only => [:create, :update, :destroy]
  
  # GET /events
  # GET /events.xml
  def index    
    @current_events = Event.current.includes(:venue, :social_organiser, :class_organiser, :swing_dates).order("frequency, updated_at")
    @gigs = Event.gigs.includes(:venue, :social_organiser, :class_organiser, :swing_dates).order("title")
    @archived_events = Event.archived.includes(:venue, :social_organiser, :class_organiser, :swing_dates).order("title")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  def show
    @event = Event.findevent(params[:id])
    
    if !@event.has_class? && !@event.has_social?
      @warning =  if @event.has_taster? 
                    "This event has a taster but no class or social, so it won't show up in the listings"
                  else
                    "This event doesn't have class or social, so it won't show up in the listings"
                  end
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.findevent(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    
    respond_to do |format|
      if @event.save
        expire_page :controller => :website, :action => :index
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        expire_page :controller => :website, :action => :index
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    
    redirect_to events_path
  end
  
  def archive
    @event = Event.find(params[:id])
    @event.archive!
    #TODO: handle case where save fails or already archived (archive = false)
    
    redirect_to events_path
  end

end