# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'website'

  def new; end

  def create
    LoginSession.new(session).log_in!
    redirect_to events_path
  end
end
