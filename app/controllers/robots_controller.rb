# frozen_string_literal: true

class RobotsController < ActionController::Base # rubocop:disable Rails/ApplicationController
  def index
    respond_to :text
    expires_in 6.hours, public: true

    canonical_sitemap_url = sitemap_url(host: ENV.fetch("CANONICAL_HOST"), protocol: "https")

    render "index", locals: { canonical_sitemap_url: }
  end

  def no_content
    head :no_content
  end

  def empty_json
    render json: {}
  end
end
