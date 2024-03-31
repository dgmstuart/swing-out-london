# frozen_string_literal: true

Role.create!(facebook_ref: ENV.fetch("DEVELOPMENT_USER_LOGIN_ID"), role: "admin")
