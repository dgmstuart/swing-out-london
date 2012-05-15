class EventsController < ApplicationController
  
  before_filter :authenticate
  
  # GET /events
  # GET /events.xml
  def index    
    @current_events = Event.current :order => "frequency, updated_at"
    @gigs = Event.gigs :order => "title"
    @archived_events = Event.archived :order => "title"
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.findevent(params[:id])
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    @event.venue = Venue.find(params[:venueid])unless params[:venueid].nil?
    @event.organiser = Organiser.find(params[:organiserid])unless params[:organiserid].nil?
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

  
  protected
  
  def authenticate
    @cms_page=true
    
    @authenticated = authenticate_or_request_with_http_basic do |username, password|
      LOGINS[username] == Digest::MD5.hexdigest(password)
    end
  end
  
end
