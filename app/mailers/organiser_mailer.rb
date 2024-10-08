# frozen_string_literal: true

# emails targeted at the promoters and teachers who run events
class OrganiserMailer < ApplicationMailer
  def reminder_email(to:, event:)
    @event_name = event.title
    @event_url = UrlHelpers.new.edit_external_event_url(event.organiser_token)
    mail(to:, subject: t("organiser_mailer.reminder_email.subject", site_name: tc("site_name"), event_name: @event_name))
    event.email_deliveries.create!(recipient: to)
  end
end
