# frozen_string_literal: true

class ReturnToSession
  RETURN_TO_KEY = :return_to

  def initialize(request)
    @request = request
  end

  def store!(path)
    request.session[:return_to] = sanitise_path(path)
  end

  def path
    sanitise_path(request.session[:return_to])
  end

  private

  attr_reader :request

  def sanitise_path(path)
    return if path.nil?

    URI.parse(path).path
  rescue URI::InvalidURIError
    # just ignore it
  end
end
