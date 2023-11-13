# frozen_string_literal: true

class RobotsController < ActionController::Base # rubocop:disable Rails/ApplicationController
  def no_content
    head :no_content
  end

  def empty_json
    render json: {}
  end
end
