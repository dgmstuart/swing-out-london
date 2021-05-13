# frozen_string_literal: true

class EventSweeper < ActionController::Caching::Sweeper
  observe Event, Venue, Organiser

  def after_save(record)
    expire_cache
    expire_fragment(record.index_row_cache_key) if record.is_a?(Event)
  end

  def after_destroy(_record)
    expire_cache
  end

  private

  def expire_cache
    @controller ||= ActionController::Base.new
    expire_fragment('events#index')
    expire_fragment('website#index')
  end
end
