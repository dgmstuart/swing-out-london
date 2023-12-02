# frozen_string_literal: true

require "spec_helper"
require "spec/support/time_formats_helper"
require "lib/date_string_parser"

RSpec.describe DateStringParser do
  it "is nil with a non-date string" do
    result = described_class.new.parse("foo")
    expect(result).to be false
  end

  it "is parses valid date strings" do
    result = described_class.new.parse("30/06/2012")
    expect(result).to eq Date.new(2012, 6, 30)
  end

  it "is nil with a date which doesn't exist" do
    result = described_class.new.parse("31/06/2012")
    expect(result).to be false
  end

  it "is nil with two dates separated by a space" do
    result = described_class.new.parse("30/12/2012 30/06/2012")
    expect(result).to be false
  end

  it "is nil if it has extra stuff in it" do
    result = described_class.new.parse("30/12/2012foo")
    expect(result).to be false
  end
end
