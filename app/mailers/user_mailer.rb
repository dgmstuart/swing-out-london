# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def test_email
    mail(to: "dgmstuart+soldn@gmail.com", subject: "Testing1")
  end
end
