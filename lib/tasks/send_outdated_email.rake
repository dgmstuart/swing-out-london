# frozen_string_literal: true

task send_outdated_email: :environment do
  AdminMailer.outdated.deliver
end
