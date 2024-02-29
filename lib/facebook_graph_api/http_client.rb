# frozen_string_literal: true

require "facebook_graph_api/appsecret_proof_generator"

module FacebookGraphApi
  class HttpClient
    ResponseError = Class.new(RuntimeError)
    UnauthorizedError = Class.new(ResponseError)

    def initialize(
      auth_token:, base_url: Rails.configuration.x.facebook.api_base!,
      proof_generator: FacebookGraphApi::AppsecretProofGenerator.new
    )
      @base_url = base_url
      @client = HTTP.auth("Bearer #{auth_token}")
      @appsecret_proof = proof_generator.generate(auth_token)
    end

    def get(path)
      response = client.get(
        uri(path),
        params: { appsecret_proof: }
      )
      handle_response(response) { JSON.parse(response.body) }
    end

    def delete(path)
      response = client.delete(
        uri(path),
        params: { appsecret_proof: }
      )
      handle_response(response) { true }
    end

    private

    attr_reader :base_url, :client, :appsecret_proof

    def uri(path)
      URI.join(base_url, path).to_s
    end

    def handle_response(response, &)
      case response.code
      when 200
        yield(response)
      when 401
        raise UnauthorizedError, error_message_for(response)
      else
        raise ResponseError, error_message_for(response)
      end
    end

    def error_message_for(response)
      message = JSON.parse(response.body).fetch("error")
      "#{response.code} #{message.fetch('type')} (code: #{message.fetch('code')}) #{message.fetch('message')}"
    end
  end
end
