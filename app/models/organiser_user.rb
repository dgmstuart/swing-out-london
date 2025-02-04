# frozen_string_literal: true

class OrganiserUser
  def initialize(token)
    @token = token
  end

  def logged_in?
    true
  end

  def name
    "Organiser"
  end

  def auth_id
    token
  end

  private

  attr_reader :token
end
