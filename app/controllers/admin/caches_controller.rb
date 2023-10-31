# frozen_string_literal: true

module Admin
  class CachesController < BaseController
    def show; end

    def destroy
      Rails.cache.clear

      redirect_to events_path
    end
  end
end
