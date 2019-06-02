# frozen_string_literal: true

require 'spec_helper'
require 'app/services/maps/socials/date_parser'

RSpec.describe Maps::Socials::DateParser do
  it "parses 'today' as today's date" do
    today = Date.new(1934, 4, 1)

    date = described_class.parse('today', today)

    expect(date).to eq(Date.new(1934, 4, 1))
  end

  it "parses 'tomorrow' as tomorrow's date" do
    today = Date.new(1934, 4, 1)

    date = described_class.parse('tomorrow', today)

    expect(date).to eq(Date.new(1934, 4, 2))
  end

  it "parses 'yesterday' as nil" do
    date = described_class.parse('yesterday', double)

    expect(date).to be_nil
  end
end
