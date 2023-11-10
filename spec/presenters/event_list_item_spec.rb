# frozen_string_literal: true

require "spec_helper"
require "app/presenters/event_list_item"
require "action_view"
require "action_view/helpers" # for String#pluralize

RSpec.describe EventListItem do
  describe "#to_model" do
    it "delegates to the event" do
      model = double
      event = instance_double("Event", to_model: model)

      expect(item_instance(event).to_model).to eq model
    end
  end

  describe "#id" do
    it "delegates to the event" do
      event = instance_double("Event", id: 23)

      expect(item_instance(event).id).to eq 23
    end
  end

  describe "#to_param" do
    it "delegates to the event" do
      event = instance_double("Event", to_param: "23")

      expect(item_instance(event).to_param).to eq "23"
    end
  end

  describe "#url" do
    it "delegates to the event" do
      event = instance_double("Event", url: "https://webb.com")

      expect(item_instance(event).url).to eq "https://webb.com"
    end
  end

  describe "#venue" do
    it "delegates to the event" do
      venue = double
      event = instance_double("Event", venue:)

      expect(item_instance(event).venue).to eq venue
    end
  end

  describe "#venue_name" do
    it "delegates to the event" do
      event = instance_double("Event", venue_name: "Savoy")

      expect(item_instance(event).venue_name).to eq "Savoy"
    end
  end

  describe "#venue_area" do
    it "delegates to the event" do
      event = instance_double("Event", venue_area: "Harlem")

      expect(item_instance(event).venue_area).to eq "Harlem"
    end
  end

  describe "#frequency" do
    it "delegates to the event" do
      event = instance_double("Event", frequency: 1)

      expect(item_instance(event).frequency).to eq 1
    end
  end

  describe "#social_organiser" do
    it "delegates to the event" do
      social_organiser = double
      event = instance_double("Event", social_organiser:)

      expect(item_instance(event).social_organiser).to eq social_organiser
    end
  end

  describe "#class_organiser" do
    it "delegates to the event" do
      class_organiser = double
      event = instance_double("Event", class_organiser:)

      expect(item_instance(event).class_organiser).to eq class_organiser
    end
  end

  describe "#title" do
    it "delegates to the event" do
      event = instance_double("Event", title: "Webb Clubb")

      expect(item_instance(event).title).to eq "Webb Clubb"
    end
  end

  describe "#updated_at" do
    it "delegates to the event" do
      time = double
      event = instance_double("Event", updated_at: time)

      expect(item_instance(event).updated_at).to eq time
    end
  end

  describe "#status_string" do
    context "when the event has ended" do
      it "is inactive" do
        event = instance_double("Event", ended?: true)

        expect(item_instance(event).status_string).to eq "inactive"
      end
    end

    context "when the event has future dates" do
      it "is nil" do
        event = instance_double("Event", ended?: false, future_dates?: true)

        expect(item_instance(event).status_string).to be_nil
      end
    end

    context "when the event has no future dates" do
      it "is no_future_dates" do
        event = instance_double("Event", ended?: false, future_dates?: false)

        expect(item_instance(event).status_string).to eq "no_future_dates"
      end
    end
  end

  describe "#print_dates_rows" do
    context "when the event has ended" do
      it "prints Ended" do
        event = instance_double("Event", ended?: true)

        expect(item_instance(event).print_dates_rows).to eq "Ended"
      end
    end

    context "when the event is weekly" do
      it "prints Weekly" do
        event = instance_double("Event", ended?: false, weekly?: true, day: "Tuesday")

        expect(item_instance(event).print_dates_rows).to eq "Every week on Tuesdays"
      end
    end

    context "when there are no dates" do
      it "prints No dates" do
        event = instance_double("Event", ended?: false, weekly?: false, dates: [])

        expect(item_instance(event).print_dates_rows).to eq "(No dates)"
      end
    end

    context "when the event has dates" do
      it "prints those dates" do
        event = instance_double("Event", ended?: false, weekly?: false, dates: [double])
        printed_dates = double
        date_printer = instance_double("DatePrinter", print: printed_dates)

        item = described_class.new(event, date_printer:)
        expect(item.print_dates_rows).to eq printed_dates
      end

      it "reverses the order of the dates" do
        event = instance_double("Event", ended?: false, weekly?: false, dates: [1, 2])
        date_printer = instance_double("DatePrinter", print: double)

        item = described_class.new(event, date_printer:)
        item.print_dates_rows

        expect(date_printer).to have_received(:print).with([2, 1])
      end
    end
  end

  def item_instance(event)
    described_class.new(event, date_printer: double)
  end
end
