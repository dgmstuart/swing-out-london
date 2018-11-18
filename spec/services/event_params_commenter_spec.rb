# frozen_string_literal: true

require 'spec_helper'
require 'app/services/event_params_commenter'

RSpec.describe EventParamsCommenter do
  describe '#comment' do
    context 'when there are changes to the dates' do
      it 'returns an audit comment' do
        event = instance_double('Event', print_dates: '12/04/2011', print_cancellations: nil)
        update_params = { date_array: '11/04/2011' }
        comment = described_class.new.comment(event, update_params)

        expect(comment).to eq(audit_comment: 'Updated dates: (old: 12/04/2011) (new: 11/04/2011)')
      end
    end

    context 'when there are no changes to the dates' do
      it 'returns an empty hash' do
        event = instance_double('Event', print_dates: '12/04/2011', print_cancellations: nil)
        update_params = { date_array: '12/04/2011' }
        comment = described_class.new.comment(event, update_params)

        expect(comment).to eq({})
      end
    end

    context 'when there are changes to the cancellations' do
      it 'returns an audit comment' do
        event = instance_double('Event', print_dates: nil, print_cancellations: '12/04/2011')
        update_params = { cancellation_array: '11/04/2011' }
        comment = described_class.new.comment(event, update_params)

        expect(comment).to eq(audit_comment: 'Updated cancellations: (old: 12/04/2011) (new: 11/04/2011)')
      end
    end

    context 'when there are changes to both dates and cancellations' do
      it 'returns an audit comment' do
        event = instance_double('Event', print_dates: '12/04/2011', print_cancellations: '12/04/2011')
        update_params = { date_array: '11/04/2011', cancellation_array: '11/04/2011' }
        comment = described_class.new.comment(event, update_params)

        expect(comment).to eq(
          audit_comment:
          'Updated dates: (old: 12/04/2011) (new: 11/04/2011)' \
          'Updated cancellations: (old: 12/04/2011) (new: 11/04/2011)'
        )
      end
    end

    context 'when there is no comment to be made' do
      it 'returns an empty hash' do
        comment = described_class.new.comment(double, {})

        expect(comment).to eq({})
      end
    end
  end
end
