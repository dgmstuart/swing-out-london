# frozen_string_literal: true

class EventSweeper < ActionController::Caching::Sweeper
  observe Event, Venue, Organiser

  def after_save(_record)
    expire_cache
  end

  def after_destroy(_record)
    expire_cache
  end

  private

  def expire_cache
    @controller ||= ActionController::Base.new
    expire_fragment('website#index')
  end
end
