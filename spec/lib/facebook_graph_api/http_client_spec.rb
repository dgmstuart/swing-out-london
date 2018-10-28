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
  end
end
