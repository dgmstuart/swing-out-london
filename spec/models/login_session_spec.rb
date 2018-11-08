# frozen_string_literal: true

require 'spec_helper'
require 'app/models/login_session'
require 'active_support/core_ext/object/blank'

RSpec.describe LoginSession do
  describe 'log_in!' do
    it 'sets an identifier for the user in the session' do
      session = {}
      request = instance_double('ActionDispatch::Request', session: session)
      described_class.new(request).log_in!(auth_id: 12345678901234567, name: 'Willa Mae Ricker')

      expect(session[:user]['auth_id']).to eq 12345678901234567
      expect(session[:user]['name']).to eq 'Willa Mae Ricker'
    end
  end

  describe 'log_out!' do
    it 'resets the session' do
      request = instance_double('ActionDispatch::Request', reset_session: double)
      described_class.new(request).log_out!

      expect(request).to have_received(:reset_session)
    end
  end

  describe '#user.logged_in' do
    context 'when the session has been set' do
      it 'is true' do
        session = { user: { auth_id: 12345678901234567 } }
        request = instance_double('ActionDispatch::Request', session: session)

        expect(described_class.new(request).user.logged_in?).to eq true
      end
    end

    context 'when the session has not been set' do
      it 'is false' do
        request = instance_double('ActionDispatch::Request', session: {})

        expect(described_class.new(request).user.logged_in?).to eq false
      end
    end
  end

  describe '#user.name' do
    context 'when the session has been set' do
      it 'is the name from the session' do
        session = { user: { 'name' => 'Leon James' } }
        request = instance_double('ActionDispatch::Request', session: session)

        expect(described_class.new(request).user.name).to eq 'Leon James'
      end
    end

    context 'when the session has not been set' do
      it 'is guest' do
        request = instance_double('ActionDispatch::Request', session: {})

        expect(described_class.new(request).user.name).to eq 'Guest'
      end
    end
  end
end
