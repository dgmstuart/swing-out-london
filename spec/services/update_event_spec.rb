# frozen_string_literal: true

require 'spec_helper'
require 'app/services/update_event'

RSpec.describe UpdateEvent do
  describe '#update' do
    it 'returns a successful result' do
      event = instance_double('Event', update!: true)

      result = described_class.new(fake_commenter).update(event, {})

      expect(result.success?).to eq true
    end

    it 'updates the event with the given parameters' do
      event = instance_double('Event', update!: true)
      update_params = { title: 'Swing Pit' }

      described_class.new(fake_commenter).update(event, update_params)

      expect(event).to have_received(:update!).with(a_hash_including(update_params))
    end

    it 'returns a result with the updated event' do
      event = instance_double('Event', update!: true)

      result = described_class.new(fake_commenter).update(event, {})

      expect(result.updated_event).to eq event
    end

    context 'when the update failed' do
      it 'returns an unsuccessful result' do
        event = instance_double('Event', update!: false)

        result = described_class.new(fake_commenter).update(event, {})

        expect(result.success?).to eq false
      end
    end

    context 'when the parameters require an audit comment' do
      it 'adds an audit comment' do
        event = instance_double('Event', update!: true)
        params_commenter = instance_double('EventParamsCommenter')
        allow(params_commenter).to receive(:comment)
          .with(event, {})
          .and_return(audit_comment: 'Updated dates')

        described_class.new(params_commenter).update(event, {})

        expect(event).to have_received(:update!).with(audit_comment: 'Updated dates')
      end
    end

    context 'when there was no change to the associated dates or cancellations' do
      it 'does not add an audit comment' do
        event = instance_double('Event', update!: true)
        params_commenter = instance_double('EventParamsCommenter')
        allow(params_commenter).to receive(:comment)
          .with(event, {})
          .and_return({})

        described_class.new(params_commenter).update(event, {})

        expect(event).to have_received(:update!).with({})
      end
    end

    def fake_commenter
      instance_double('EventParamsCommenter', comment: {})
    end
  end
end
