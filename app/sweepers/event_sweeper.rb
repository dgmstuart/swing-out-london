class EventSweeper < ActionController::Caching::Sweeper
  observe Event
  
  def after_save(event)
    expire_cache(event)
  end
  
  def after_destroy(event)
    expire_cache(event)
  end
  
  private
  
  def expire_cache(event)
    expire_action :controller => 'events', :action => 'index'
    expire_action :controller => 'website', :action => 'index'
  end
end