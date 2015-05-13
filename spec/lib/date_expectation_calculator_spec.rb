require 'spec_helper'

RSpec.describe DateExpectationCalculator do
  describe "#expecting_a_date?" do
    context 'when the subject is infrequent' do
      context 'and there is no expected date' do
        let(:calculator) { DateExpectationCalculator.new(true, nil, Date.today) }
        specify { expect(calculator.expecting_a_date?).to eq false }
      end
      context 'and the expected date is less than 3 months after the comparison date' do
        let(:calculator) { DateExpectationCalculator.new(true, Date.today + 1.month, Date.today) }
        specify { expect(calculator.expecting_a_date?).to eq true }
      end
      context 'and the expected date is more than 3 months after the comparison date' do
        let(:calculator) { DateExpectationCalculator.new(true, Date.today + 4.months, Date.today) }
        specify { expect(calculator.expecting_a_date?).to eq false }
      end
    end

    context 'when the subject is frequent' do
      context 'and there is no expected date' do
        let(:calculator) { DateExpectationCalculator.new(false, nil, Date.today) }
        specify { expect(calculator.expecting_a_date?).to eq true }
      end
      context 'and the expected date is less than 3 months after the comparison date' do
        let(:calculator) { DateExpectationCalculator.new(false, Date.today + 1.month, Date.today) }
        specify { expect(calculator.expecting_a_date?).to eq true }
      end
      context 'and the expected date is more than 3 months after the comparison date' do
        let(:calculator) { DateExpectationCalculator.new(false, Date.today + 4.months, Date.today) }
        specify { expect(calculator.expecting_a_date?).to eq true }
      end
    end
  end
end
