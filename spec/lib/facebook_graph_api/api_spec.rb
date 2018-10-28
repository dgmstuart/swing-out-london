# frozen_string_literal: true

require 'spec_helper'
require 'lib/facebook_graph_api/api'

RSpec.describe FacebookGraphApi::Api do
  describe '#revoke_login' do
    it "makes a request to revoke the user's login" do
      http_client = instance_double('HTTP::Client', delete: double)

      described_class.new(http_client).revoke_login('1234567')

      expect(http_client).to have_received(:delete).with('/1234567/permissions')
    end
  end
end
