# frozen_string_literal: true

# Base class for all mailers
class ApplicationMailer < ActionMailer::Base
  include CityHelper

  default from: -> { tc("email_address") }
  layout "mailer"
end
