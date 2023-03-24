# frozen_string_literal: true

require 'spec_helper'
require 'app/models/soldn_time'
require 'active_support/testing/time_helpers'
require 'active_support/core_ext/string/zones'
require 'active_support/core_ext/numeric/time'
require 'spec/support/time_formats_helper'

RSpec.describe SOLDNTime do
  include ActiveSupport::Testing::TimeHelpers

  describe 'today' do
    context 'when the timezone is UTC' do
      around do |example|
        Time.use_zone('UTC') { example.run }
      end

      context 'when the time is before midnight' do
        it 'is the current date' do
          travel_to(Time.zone.parse('May 11, 1938 19:00'))

          expect(described_class.today.to_s).to eq '11/05/1938'
        end
      end

      context 'when the time is before 4am' do
        it "is the date that this crazy night began (yesterday's date)" do
          travel_to(Time.zone.parse('May 12, 1938 03:59'))

          expect(described_class.today.to_s).to eq '11/05/1938'
        end
      end

      context 'when the time is 4am' do
        it "is time to go to bed (today's date)" do
          travel_to(Time.zone.parse('May 12, 1938 04:00'))

          expect(described_class.today.to_s).to eq '12/05/1938'
        end
      end
    end

    context 'when the timezone is BST' do
      around do |example|
        Time.use_zone('London') { example.run }
      end

      context 'when the time is before 4am' do
        it "is the date that this crazy night began (yesterday's date)" do
          travel_to(Time.zone.parse('May 12, 1938 03:59'))

          expect(described_class.today.to_s).to eq '11/05/1938'
        end
      end

      context 'when the time is 4am' do
        it "is time to go to bed (today's date)" do
          travel_to(Time.zone.parse('May 12, 1938 04:00'))

          expect(described_class.today.to_s).to eq '12/05/1938'
        end
      end

      context 'when the time is 5am' do
        it "is time to go to bed (today's date)" do
          travel_to(Time.zone.parse('May 12, 1938 05:00'))

          expect(described_class.today.to_s).to eq '12/05/1938'
        end
      end
    end
  end
end
