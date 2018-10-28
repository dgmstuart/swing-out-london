# frozen_string_literal: true

require 'spec_helper'
require 'lib/facebook_graph_api/http_client'

RSpec.describe FacebookGraphApi::HttpClient do
  describe '#delete' do
    it 'makes an http request' do
      stub_request(:delete, 'https://example.com/path')

      client = described_class.new(
        base_url: 'https://example.com/',
        auth_token: 'super-secret-token'
      )
      client.delete('/path')

      expect(
        a_request(:delete, 'https://example.com/path')
        .with(headers: { 'Authorization' => 'Bearer super-secret-token' })
      ).to have_been_made
    end

    context 'when the response was not successful' do
      it 'raises an error' do
        error_json = {
          'error': {
            'message': 'An access token is required to request this resource.',
            'type': 'OAuthException',
            'code': 104,
            'fbtrace_id': 'HZNbuD4fi8u'
          }
        }.to_json
        stub_request(:delete, 'https://example.com/path')
          .to_return(status: 400, body: error_json)

        client = described_class.new(
          base_url: 'https://example.com/',
          auth_token: 'super-secret-token'
        )

        expect { client.delete('/path') }
          .to raise_error(
            described_class::ResponseError,
            'OAuthException (code: 104) An access token is required to request this resource.'
          )
      end
    end
  end
end
