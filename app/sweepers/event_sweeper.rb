class EventSweeper < ActionController::Caching::Sweeper
  observe Event, Venue, Organiser

  def initialize
    @base = ActionController::Base.new
  end

  def after_save(record)
    expire_cache
    if record.is_a?(Event)
      @base.expire_fragment(record.index_row_cache_key)
    end
  end

  def after_destroy(record)
    expire_cache
  end

  private

  def expire_cache
    @base.expire_fragment('events#index')
    @base.expire_fragment('website#index')
  end
end
