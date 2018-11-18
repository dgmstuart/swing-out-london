# frozen_string_literal: true

require 'spec_helper'
require 'app/models/editor'

RSpec.describe Editor do
  describe 'name' do
    it 'returns the user name from the audit record' do
      audit = instance_double('Audit', username: { 'name' => 'Leon James' })

      expect(described_class.build(audit).name).to eq 'Leon James'
    end

    context 'when there are no audits' do
      it 'returns a default' do
        expect(described_class.build(nil).name).to eq 'Unknown name'
      end
    end

    context 'when there is no user stored on the audit' do
      it 'returns a default' do
        audit = instance_double('Audit', username: nil)

        expect(described_class.build(audit).name).to eq 'Missing name'
      end
    end
  end

  describe 'auth_id' do
    it 'returns the user id from the audit record' do
      audit = instance_double('Audit', username: { 'auth_id' => 12345678901234567 })

      expect(described_class.build(audit).auth_id).to eq 12345678901234567
    end

    context 'when there are no audits' do
      it 'returns a default' do
        expect(described_class.build(nil).auth_id).to eq 'Unknown auth id'
      end
    end

    context 'when there is no user stored on the audit' do
      it 'returns a default' do
        audit = instance_double('Audit', username: nil)

        expect(described_class.build(audit).auth_id).to eq 'Missing auth id'
      end
    end
  end
end
