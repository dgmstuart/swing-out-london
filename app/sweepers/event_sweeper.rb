class EventSweeper < ActionController::Caching::Sweeper
  observe Event, Venue, Organiser
  
  def after_save(record)
    expire_cache
  end
  
  def after_destroy(record)
    expire_cache
  end
  
  private
  
  def expire_cache
    expire_fragment :controller => 'events', :action => 'index'
    expire_action :controller => 'website', :action => 'index'
  end
end