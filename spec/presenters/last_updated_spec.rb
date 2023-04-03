# frozen_string_literal: true

require "spec_helper"
require "spec/support/time_formats_helper"
require "active_support/core_ext/string/zones"
require "active_support/core_ext/module/delegation"
require "app/presenters/last_updated"

RSpec.describe LastUpdated do
  describe "#time_in_words" do
    it "is the time of the last update in words" do
      time = ActiveSupport::TimeZone["UTC"].parse("1987-06-23T19:30:00")
      scope = class_double("Event", last_updated_at: time)

      last_updated = described_class.new(scope)

      expect(last_updated.time_in_words).to eq "at 19:30 on Tuesday 23rd June"
    end

    context "when there are no records" do
      it "is the time of the last update in words" do
        scope = class_double("Event", last_updated_at: nil)

        last_updated = described_class.new(scope)

        expect(last_updated.time_in_words).to eq "never"
      end
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

    context "when there are no records" do
      it "is nil" do
        scope = class_double("Event", last_updated_at: nil)

        last_updated = described_class.new(scope)

        expect(last_updated.iso).to be_nil
      end
    end
  end
end
