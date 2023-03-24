# frozen_string_literal: true

class InfoController < ApplicationController
  before_action :set_cache_control_on_static_pages, only: %i[about listings_policy privacy]

  def about; end
  def listings_policy; end
  def privacy; end

  private

  def set_cache_control_on_static_pages
    # Varnish will cache the page for 43200 seconds = 12 hours:
    response.headers['Cache-Control'] = 'public, max-age=43200'
  end
end
