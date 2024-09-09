# frozen_string_literal: true

# Responsible for abstracting away how reminders are sent to organisers about an event
class OrganiserReminderSender
  def initialize(mailer: OrganiserMailer)
    @mailer = mailer
  end

  def send!(event)
    return if event.last_reminder_delivered_at&.after?(1.week.ago)

    mailer.reminder_email(to: event.reminder_email_address, event:).deliver_later
  end

  private

  attr_reader :mailer
end
