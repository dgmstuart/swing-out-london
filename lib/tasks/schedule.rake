# frozen_string_literal: true

# Tasks in this file are expected to run on a schedule

desc "Sends reminder emails for events which don't have any future date"
task send_not_listed_reminders: :environment do
  # Runs every day at 15:00 GMT

  puts "OrganiserRemindersSender.new.send_unlisted started"
  event_count = OrganiserRemindersSender.new.send_unlisted
  puts "Sent emails for #{event_count} #{'event'.pluralize(event_count)}"
  puts "OrganiserRemindersSender.new.send_unlisted ended"
end
