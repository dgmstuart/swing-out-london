# frozen_string_literal: true

class ReturnToSession
  RETURN_TO_KEY = :return_to

  def initialize(request)
    @request = request
  end

  def store!(path)
    request.session[:return_to] = path
  end

  def path
    request.session[:return_to]
  end

  private

  attr_reader :request
end
