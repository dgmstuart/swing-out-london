# frozen_string_literal: true

module Slack
  class HttpClient
    class ResponseError < RuntimeError; end

    def initialize(auth_token:, base_url: "https://slack.com/api")
      @base_url = base_url
      @client = HTTP.auth("Bearer #{auth_token}")
    end

    def delete(path)
      response = client.delete(uri(path))
      JSON.parse(response.body).symbolize_keys
    end

    private

    attr_reader :base_url, :client

    def uri(path)
      [base_url, path].join.to_s
    end
  end
end
