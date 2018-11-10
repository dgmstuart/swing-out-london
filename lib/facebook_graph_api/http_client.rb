# frozen_string_literal: true

require 'facebook_graph_api/appsecret_proof_generator'

module FacebookGraphApi
  class HttpClient
    class ResponseError < RuntimeError; end

    def initialize(
      base_url: Rails.configuration.x.facebook.api_base!,
      auth_token:,
      proof_generator: FacebookGraphApi::AppsecretProofGenerator.new
    )
      @base_url = base_url
      @client = HTTP.auth("Bearer #{auth_token}")
      @appsecret_proof = proof_generator.generate(auth_token)
    end

    def delete(path)
      response = client.delete(
        uri(path),
        params: { appsecret_proof: appsecret_proof }
      )
      case response.code
      when 200
        true
      else
        raise ResponseError, error_message_for(response.body)
      end
    end

    private

    attr_reader :base_url, :client, :appsecret_proof

    def uri(path)
      URI.join(base_url, path).to_s
    end

    def error_message_for(json)
      message = JSON.parse(json).fetch('error')
      "#{message.fetch('type')} (code: #{message.fetch('code')}) #{message.fetch('message')}"
    end
  end
end
