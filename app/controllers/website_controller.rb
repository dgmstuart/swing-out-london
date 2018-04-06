class WebsiteController < ApplicationController
  layout "info", :except => :index

  caches_action :index, cache_path: 'website#index', :layout => true, :expires_in => 1.hour, :race_condition_ttl => 10
  cache_sweeper :event_sweeper, :only => :index
  before_filter :set_cache_control_on_static_pages, only: [:about, :listings_policy]
  before_filter :assign_last_updated_times

  def index
    # Varnish/users browsers will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'

    @today = today

    @classes = Event.listing_classes.includes(:venue, :class_organiser, :swing_cancellations)
    @socials_dates = Event.socials_dates(@today)
  end

  private

  def set_cache_control_on_static_pages
    # Varnish will cache the page for 43200 seconds = 12 hours:
    response.headers['Cache-Control'] = 'public, max-age=43200'
  end

  def assign_last_updated_times
    @last_updated_datetime = Event.last_updated_datetime
    @last_updated_time = @last_updated_datetime.to_s(:timepart)
    @last_updated_date = @last_updated_datetime.to_s(:listing_date)
  end
end
