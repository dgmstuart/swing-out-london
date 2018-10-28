# frozen_string_literal: true

require 'spec_helper'
require 'app/models/login_session'

RSpec.describe LoginSession do
  describe 'log_in!' do
    it 'sets the session' do
      session = {}
      request = instance_double('ActionDispatch::Request', session: session)
      described_class.new(request).log_in!

      expect(session[:logged_in]).to eq true
    end
  end

  describe 'log_out!' do
    it 'resets the session' do
      request = instance_double('ActionDispatch::Request', reset_session: double)
      described_class.new(request).log_out!

      expect(request).to have_received(:reset_session)
    end
  end

  describe '#logged_in?' do
    context 'when the session has been set' do
      it 'is true' do
        session = { logged_in: true }
        request = instance_double('ActionDispatch::Request', session: session)

        expect(described_class.new(request).logged_in?).to eq true
      end
    end

    context 'when the session has not been set' do
      it 'is false' do
        request = instance_double('ActionDispatch::Request', session: {})

        expect(described_class.new(request).logged_in?).to eq false
      end
    end
  end
end
