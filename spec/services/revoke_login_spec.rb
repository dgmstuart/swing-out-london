# frozen_string_literal: true

require 'spec_helper'
require 'app/services/revoke_login'

RSpec.describe RevokeLogin do
  describe '#revoke!' do
    it 'builds an API client based on the user' do
      http_client = instance_double('FacebookGraphApi::HttpClient')
      http_client_builder = class_double('FacebookGraphApi::HttpClient', new: http_client)
      api = instance_double('FacebookGraphApi::Api', revoke_login: double)
      api_builder = class_double('FacebookGraphApi::Api', new: api)
      auth_token = double
      user = instance_double('LoginSession::User', token: auth_token, auth_id: double)

      service = described_class.new(http_client_builder: http_client_builder, api_builder: api_builder)
      service.revoke!(user)

      expect(http_client_builder).to have_received(:new).with(auth_token: auth_token)
      expect(api_builder).to have_received(:new).with(http_client)
    end

    it 'makes a call to the Facebook API' do
      http_client_builder = class_double('FacebookGraphApi::HttpClient', new: double)
      api = instance_double('FacebookGraphApi::Api', revoke_login: double)
      api_builder = class_double('FacebookGraphApi::Api', new: api)
      auth_id = double
      user = instance_double('LoginSession::User', token: double, auth_id: auth_id)

      service = described_class.new(http_client_builder: http_client_builder, api_builder: api_builder)
      service.revoke!(user)

      expect(api).to have_received(:revoke_login).with(auth_id)
    end
  end
end
