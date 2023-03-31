# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext/module/delegation"
require "spec/support/time_formats_helper"
require "app/presenters/show_event"

RSpec.describe ShowEvent do
  describe "#anchor" do
    it "includes the ID of the event" do
      event = instance_double("Event", id: 123)

      expect(described_class.new(event).anchor).to eq "event_123"
    end
  end

  describe "#cancellations" do
    it "prints out a list of dates" do
      event = instance_double("Event", cancellations: [Date.new(2011, 5, 14), Date.new(2015, 6, 24)])

      expect(described_class.new(event).cancellations).to eq "14/05/2011, 24/06/2015"
    end

    context "when there are no dates" do
      it "displays a default string" do
        event = instance_double("Event", cancellations: [])

        expect(described_class.new(event).cancellations).to eq "None"
      end
    end
  end

  describe "#course_length" do
    it "delegates to the event" do
      event = instance_double("Event", course_length: 6)

      expect(described_class.new(event).course_length).to eq 6
    end
  end

  describe "#class_style" do
    it "delegates to the event" do
      event = instance_double("Event", class_style: "Balboa")

      expect(described_class.new(event).class_style).to eq "Balboa"
    end
  end

  describe "#dates" do
    it "prints out a list of dates" do
      event = instance_double("Event", dates: [Date.new(2011, 5, 14), Date.new(2015, 6, 24)], weekly?: false)

      expect(described_class.new(event).dates).to eq "14/05/2011, 24/06/2015"
    end

    context "when there are no dates" do
      it "displays a default string" do
        event = instance_double("Event", dates: [], weekly?: false)

        expect(described_class.new(event).dates).to eq "Unknown"
      end
    end

    context "when the event is weekly?" do
      it "displays a default string" do
        event = instance_double("Event", dates: [], weekly?: true)

        expect(described_class.new(event).dates).to eq "Weekly"
      end
    end
  end

  describe "#day" do
    it "delegates to the event" do
      event = instance_double("Event", day: "Monday")

      expect(described_class.new(event).day).to eq "Monday"
    end
  end

  describe "#class_organiser" do
    it "delegates to the event" do
      class_organiser = double
      event = instance_double("Event", class_organiser:)

      expect(described_class.new(event).class_organiser).to eq class_organiser
    end
  end

  describe "#social_organiser" do
    it "delegates to the event" do
      social_organiser = double
      event = instance_double("Event", social_organiser:)

      expect(described_class.new(event).social_organiser).to eq social_organiser
    end
  end

  describe "#event_type" do
    context "when the event is a class" do
      it "combines event type and class" do
        event = instance_double("Event", event_type: "school", has_social?: false, has_taster?: false, has_class?: true)

        expect(described_class.new(event).event_type).to eq "School, with class"
      end
    end

    context "when the event is a club with a taster" do
      it "combines event type, social and taster" do
        event = instance_double(
          "Event", event_type: "dance_club", has_social?: true, has_taster?: true, has_class?: false
        )

        expect(described_class.new(event).event_type).to eq "Dance club, with social and taster"
      end
    end
  end

  describe "#expected_date" do
    it "formats the date" do
      event = instance_double("Event", expected_date: Date.new(2011, 5, 14))

      expect(described_class.new(event).expected_date).to eq "Saturday 14th May"
    end

    context "when there is no expected date" do
      it "is nil" do
        event = instance_double("Event", expected_date: nil)

        expect(described_class.new(event).expected_date).to be_nil
      end
    end
  end

  describe "#first_date" do
    it "formats the date" do
      event = instance_double("Event", first_date: Date.new(2011, 5, 14))

      expect(described_class.new(event).first_date).to eq "Saturday 14th May"
    end

    context "when there is no first date" do
      it "is nil" do
        event = instance_double("Event", first_date: nil)

        expect(described_class.new(event).first_date).to be_nil
      end
    end
  end

  describe "#frequency" do
    examples = [
      { frequency: nil, text: "Unknown" },
      { frequency: 0, text: "One-off or intermittent" },
      { frequency: 1, text: "Weekly" },
      { frequency: 2, text: "Fortnightly" },
      { frequency: 4, text: "Monthly" },
      { frequency: 4, text: "Monthly" },
      { frequency: 8, text: "Bi-Monthly" },
      { frequency: 26, text: "Twice-yearly" },
      { frequency: 52, text: "Yearly" },
      { frequency: 6, text: "Every 6 weeks" },
      { frequency: 12, text: "Every 12 weeks" }
    ]
    examples.each do |example|
      it "is a human readable version of the frequency" do
        event = instance_double("Event", frequency: example[:frequency])

        expect(described_class.new(event).frequency).to eq example[:text]
      end
    end
  end

  describe "#last_date" do
    it "formats the date" do
      event = instance_double("Event", last_date: Date.new(2011, 5, 14))

      expect(described_class.new(event).last_date).to eq "Saturday 14th May"
    end

    context "when there is no last date" do
      it "is nil" do
        event = instance_double("Event", last_date: nil)

        expect(described_class.new(event).last_date).to be_nil
      end
    end
  end

  describe "#title" do
    it "delegates to the event" do
      event = instance_double("Event", title: "Black Cotton")

      expect(described_class.new(event).title).to eq "Black Cotton"
    end
  end

  describe "#to_model" do
    it "returns the given event" do
      event = instance_double("Event")

      expect(described_class.new(event).to_model).to eq event
    end
  end

  describe "#to_param" do
    it "delegates to the event" do
      event = instance_double("Event", to_param: "123")

      expect(described_class.new(event).to_param).to eq "123"
    end
  end

  describe "#url" do
    it "delegates to the event" do
      event = instance_double("Event", url: "https://www.blackcotton.com")

      expect(described_class.new(event).url).to eq "https://www.blackcotton.com"
    end
  end

  describe "#venue" do
    it "delegates to the event" do
      venue = double
      event = instance_double("Event", venue:)

      expect(described_class.new(event).venue).to eq venue
    end
  end

  describe "#warning" do
    it "returns nothing by default" do
      event = instance_double("Event", has_class?: true, has_social?: false, has_taster?: false)

      expect(described_class.new(event).warning).to be_nil
    end

    context "when the event has neither class nor social, and no taster" do
      it "returns a warning message" do
        event = instance_double("Event", has_class?: false, has_social?: false, has_taster?: false)

        expect(described_class.new(event).warning)
          .to eq "This event doesn't have class or social, so it won't show up in the listings"
      end
    end

    context "when the event has a taster, but neither class nor social" do
      it "returns a warning message" do
        event = instance_double("Event", has_class?: false, has_social?: false, has_taster?: true)

        expect(described_class.new(event).warning)
          .to eq "This event has a taster but no class or social, so it won't show up in the listings"
      end
    end
  end

  describe "#weekly?" do
    it "delegates to the event" do
      event = instance_double("Event", weekly?: false)

      expect(described_class.new(event).weekly?).to be false
    end
  end
end
