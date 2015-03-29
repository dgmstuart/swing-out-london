task :send_outdated_email => :environment do
  AdminMailer.outdated.deliver
end
