# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DateExpectationCalculator do
  describe '#expecting_a_date?' do
    context 'when the subject is infrequent' do
      context 'and there is no expected date' do
        let(:calculator) { described_class.new(true, nil, Time.zone.today) }

        specify { expect(calculator.expecting_a_date?).to be false }
      end

      context 'and the expected date is less than 3 months after the comparison date' do
        let(:calculator) { described_class.new(true, Time.zone.today + 1.month, Time.zone.today) }

        specify { expect(calculator.expecting_a_date?).to be true }
      end

      context 'and the expected date is more than 3 months after the comparison date' do
        let(:calculator) { described_class.new(true, Time.zone.today + 4.months, Time.zone.today) }

        specify { expect(calculator.expecting_a_date?).to be false }
      end
    end

    context 'when the subject is frequent' do
      context 'and there is no expected date' do
        let(:calculator) { described_class.new(false, nil, Time.zone.today) }

        specify { expect(calculator.expecting_a_date?).to be true }
      end

      context 'and the expected date is less than 3 months after the comparison date' do
        let(:calculator) { described_class.new(false, Time.zone.today + 1.month, Time.zone.today) }

        specify { expect(calculator.expecting_a_date?).to be true }
      end

      context 'and the expected date is more than 3 months after the comparison date' do
        let(:calculator) { described_class.new(false, Time.zone.today + 4.months, Time.zone.today) }

        specify { expect(calculator.expecting_a_date?).to be true }
      end
    end
  end
end
