# frozen_string_literal: true

Rails.application.configure do
  config.x.admin.user_emails = ENV.fetch("ADMIN_USER_EMAILS", "").split(",")
end
