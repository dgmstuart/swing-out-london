# frozen_string_literal: true

# Responsible for working out which events need reminder emails
# (because the event doesn't have any future dates)
# and getting them sent
class OrganiserRemindersSender
  def initialize(
    email_sender: OrganiserReminderSender.new,
    event_finder: Event,
    event_status_calculator: EventStatus.new
  )
    @email_sender = email_sender
    @event_finder = event_finder
    @event_status_calculator = event_status_calculator
  end

  def send_unlisted
    event_finder.notifiable.each do |event|
      status = event_status_calculator.status_for(event)
      email_sender.send!(event) if status == :not_listed
    end
  end

  private

  attr_reader :email_sender, :event_finder, :event_status_calculator
end
