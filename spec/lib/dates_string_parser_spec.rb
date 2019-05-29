# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatesStringParser do
  describe '#parse' do
    def parse(string)
      DatesStringParser.new.parse(string)
    end

    it 'returns an empty string when the string is empty' do
      [
        '',
        nil
      ].each do |string|
        expect(parse(string)).to eq []
      end
    end

    it 'returns a correct date when given a string with one date' do
      expect(parse('1/2/2015')).to eq [Date.new(2015, 2, 1)]
    end

    it 'returns an array of correct dates when given a comma-separated string with multiple dates' do
      expect(parse('01/12/2015, 11/07/2015,05/12/2015')).to eq [
        Date.new(2015, 12, 1), Date.new(2015, 7, 11), Date.new(2015, 12, 0o5)
      ]
    end

    it 'BUG: Ignores non-comma separated dates' do
      expect(parse('5/2/2014 06/10/2012')).to eq [Date.new(2014, 2, 5)]
    end

    it 'BUG: Accepts duplicated dates' do
      expect(parse('5/6/2014, 05/06/2014')).to eq [Date.new(2014, 6, 5), Date.new(2014, 6, 5)]
      expect(parse('05/06/2014, 05/06/2014')).to eq [Date.new(2014, 6, 5), Date.new(2014, 6, 5)]
    end

    it 'returns an empty string when the string is not parseable as a date' do
      [
        'foo',
        '13/13/2015',
        '-1975'
      ].each do |string|
        expect(parse(string)). to eq []
      end
    end
  end
end

describe Event do
  # describe DateStringParser do
  describe '#parse_date_string' do
    it 'returns an empty string when the string is empty' do
      [
        '',
        nil,
        'Unknown',
        'Weekly'
      ].each do |string|
        expect(described_class.parse_date_string(string)). to eq []
      end
    end

    it 'returns a correct date when given a string with one date' do
      expect(described_class.parse_date_string('1/2/2015')). to eq [Date.new(2015, 2, 1)]
    end

    it 'returns an array of correct dates when given a comma-separated string with multiple dates' do
      expect(described_class.parse_date_string('01/12/2015, 11/07/2015,05/12/2015')). to eq [
        Date.new(2015, 12, 1), Date.new(2015, 7, 11), Date.new(2015, 12, 0o5)
      ]
    end

    it 'BUG: Ignores non-comma separated dates' do
      expect(described_class.parse_date_string('5/2/2014 06/10/2012')). to eq [Date.new(2014, 2, 5)]
    end

    it 'BUG: Accepts duplicated dates' do
      expect(described_class.parse_date_string('5/6/2014, 05/06/2014')). to eq [Date.new(2014, 6, 5), Date.new(2014, 6, 5)]
      expect(described_class.parse_date_string('05/06/2014, 05/06/2014')). to eq [Date.new(2014, 6, 5), Date.new(2014, 6, 5)]
    end

    it 'returns an empty string when the string is not parseable as a date' do
      [
        'foo',
        '13/13/2015',
        '-1975'
      ].each do |string|
        expect(described_class.parse_date_string(string)). to eq []
      end
    end
  end
end
