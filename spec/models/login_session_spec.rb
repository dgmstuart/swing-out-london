# frozen_string_literal: true

require 'spec_helper'
require 'app/models/login_session'

RSpec.describe LoginSession do
  describe 'log_in!' do
    it 'sets the session' do
      session = {}
      described_class.new(session).log_in!

      expect(session[:logged_in]).to eq true
    end
  end

  describe '#logged_in?' do
    context 'when the session has been set' do
      it 'is true' do
        session = { logged_in: true }

        expect(described_class.new(session).logged_in?).to eq true
      end
    end

    context 'when the session has not been set' do
      it 'is false' do
        expect(described_class.new({}).logged_in?).to eq false
      end
    end
  end
end
