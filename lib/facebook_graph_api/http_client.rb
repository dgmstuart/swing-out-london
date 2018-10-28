# frozen_string_literal: true

module FacebookGraphApi
  class HttpClient
    def initialize(
      base_url: Rails.configuration.x.facebook.api_base!,
      auth_token:
    )
      @base_url = base_url
      @client = HTTP.auth("Bearer #{auth_token}")
    end

    def delete(path)
      client.delete(uri(path))
    end

    private

    attr_reader :base_url, :client

    def uri(path)
      URI.join(base_url, path).to_s
    end
  end
end
