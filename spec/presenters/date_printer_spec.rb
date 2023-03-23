# frozen_string_literal: true

require 'spec_helper'
require 'app/presenters/date_printer'
require 'spec/support/time_formats_helper'

describe DatePrinter do
  describe '#print' do
    it 'prints out a list of dates as a formatted string' do
      dates = [Date.new(1958, 9, 30), Date.new(1958, 10, 28), Date.new(1958, 11, 25)]

      result = described_class.new.print(dates)

      expect(result).to eq '30/09/1958,28/10/1958,25/11/1958'
    end
  end
end
