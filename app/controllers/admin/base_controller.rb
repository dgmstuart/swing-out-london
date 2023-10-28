# frozen_string_literal: true

module Admin
  class BaseController < CmsBaseController
    before_action :check_admin

    private

    def check_admin
      return if current_user.admin?

      flash.alert = "You are not authorised to view this page."
      redirect_to events_path
    end
  end
end
