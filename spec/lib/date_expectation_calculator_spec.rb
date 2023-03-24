# frozen_string_literal: true

require 'spec_helper'
require 'lib/date_expectation_calculator'
require 'active_support/core_ext/integer/time'

RSpec.describe DateExpectationCalculator do
  describe '#expecting_a_date?' do
    context 'when the subject is infrequent' do
      context 'and there is no expected date' do
        let(:calculator) { described_class.new(true, nil, Time.now.utc) }

        specify { expect(calculator.expecting_a_date?).to be false }
      end

      context 'and the expected date is less than 3 months after the comparison date' do
        let(:calculator) { described_class.new(true, Time.now.utc + 1.month, Time.now.utc) }

        specify { expect(calculator.expecting_a_date?).to be true }
      end

      context 'and the expected date is more than 3 months after the comparison date' do
        let(:calculator) { described_class.new(true, Time.now.utc + 4.months, Time.now.utc) }

        specify { expect(calculator.expecting_a_date?).to be false }
      end
    end

    context 'when the subject is frequent' do
      context 'and there is no expected date' do
        let(:calculator) { described_class.new(false, nil, Time.now.utc) }

        specify { expect(calculator.expecting_a_date?).to be true }
      end

      context 'and the expected date is less than 3 months after the comparison date' do
        let(:calculator) { described_class.new(false, Time.now.utc + 1.month, Time.now.utc) }

        specify { expect(calculator.expecting_a_date?).to be true }
      end

      context 'and the expected date is more than 3 months after the comparison date' do
        let(:calculator) { described_class.new(false, Time.now.utc + 4.months, Time.now.utc) }

        specify { expect(calculator.expecting_a_date?).to be true }
      end
    end
  end
end
