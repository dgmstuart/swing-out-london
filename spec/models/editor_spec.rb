# frozen_string_literal: true

require 'spec_helper'
require 'app/models/editor'

RSpec.describe Editor do
  describe 'name' do
    it 'returns the user name from the version record' do
      version = instance_double('PaperTrail::Version', user_name: 'Leon James')

      expect(described_class.build(version).name).to eq 'Leon James'
    end

    context 'when there are no versions' do
      it 'returns a default' do
        expect(described_class.build(nil).name).to eq 'Unknown name'
      end
    end
  end

  describe 'auth_id' do
    it 'returns the user id from the version record' do
      version = instance_double('PaperTrail::Version', whodunnit: '12345678901234567')

      expect(described_class.build(version).auth_id).to eq '12345678901234567'
    end

    context 'when there are no versions' do
      it 'returns a default' do
        expect(described_class.build(nil).auth_id).to eq 'Unknown auth id'
      end
    end
  end
end
