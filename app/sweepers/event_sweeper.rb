class EventSweeper < ActionController::Caching::Sweeper
  observe Event, Venue, Organiser

  def after_save(record)
    expire_cache
    if record.is_a?(Event)
      expire_fragment(record.index_row_cache_key)
    end
  end

  def after_destroy(record)
    expire_cache
  end

  private

  def expire_cache
    expire_action :controller => 'events', :action => 'index'
    expire_action :controller => 'website', :action => 'index'
  end
end