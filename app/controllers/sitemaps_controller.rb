# frozen_string_literal: true

class SitemapsController < ApplicationController
  def index
    respond_to do |format|
      format.xml
    end
  rescue ActionController::UnknownFormat
    head :not_found
  end

  private

  def default_url_options
    { protocol: "https", host: ENV.fetch("CANONICAL_HOST") }
  end
end
