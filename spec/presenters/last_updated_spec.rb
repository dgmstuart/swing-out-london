# frozen_string_literal: true

require "spec_helper"
require "spec/support/time_formats_helper"
require "active_support/core_ext/string/zones"
require "app/presenters/last_updated"

RSpec.describe LastUpdated do
  describe "#time_in_words" do
    it "is the time of the last update in words" do
      time = ActiveSupport::TimeZone["UTC"].parse("1987-06-23T19:30:00")
      scope = class_double("Event", last_updated_at: time)

      last_updated = described_class.new(scope)

      expect(last_updated.time_in_words).to eq "at 19:30 on Tuesday 23rd June"
    end
  end

  describe "#iso" do
    it "is the time of the last update in iso8601 format" do
      time = ActiveSupport::TimeZone["UTC"].parse("1987-06-23T19:30:00")
      scope = class_double("Event", last_updated_at: time)

      last_updated = described_class.new(scope)

      expect(last_updated.iso).to eq "1987-06-23T19:30:00Z"
    end

    it "converts times to UTC" do
      time = ActiveSupport::TimeZone["London"].parse("1987-06-23T19:30:00")
      scope = class_double("Event", last_updated_at: time)

      last_updated = described_class.new(scope)

      expect(last_updated.iso).to eq "1987-06-23T18:30:00Z"
    end
  end
end
