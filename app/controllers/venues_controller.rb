# frozen_string_literal: true

class VenuesController < CMSBaseController
  def index
    @venues = Venue.order('name ASC').includes(:events)
  end

  def show
    @venue = Venue.find(params[:id])
    @associated_events = @venue.events.map { |event| AssociatedEvent.new(event) }
    @last_update = LastUpdate.new(@venue)
  end

  def new
    @venue = Venue.new
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      flash[:notice] = 'Venue was successfully created.'
      redirect_to(@venue)
    else
      render action: 'new'
    end
  end

  def update
    @venue = Venue.find(params[:id])

    if @venue.update(venue_params)
      flash[:notice] = 'Venue was successfully updated.'
      redirect_to(@venue)
    else
      render action: 'edit'
    end
  end

  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy

    redirect_to(venues_url)
  end

  private

  def venue_params
    params.require(:venue).permit(
      :name,
      :address,
      :postcode,
      :area,
      :lat,
      :lng,
      :website
    )
  end
end
