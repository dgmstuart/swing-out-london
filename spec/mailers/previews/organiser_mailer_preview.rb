# frozen_string_literal: true

class OrganiserMailerPreview < ActionMailer::Preview
  def reminder_email
    event = Event.new(title: "Ladies Night")
    OrganiserMailer.reminder_email(to: "dawn@hampton.nyc", event:)
  end
end
