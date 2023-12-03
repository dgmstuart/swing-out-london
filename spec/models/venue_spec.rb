# frozen_string_literal: true

require "rails_helper"
require "support/shoulda_matchers"
require "spec/support/shared_examples/venues/validates_postcode_is_postcode_like"

RSpec.describe Venue do
  describe "Associations" do
    it { is_expected.to have_many(:events).dependent(:restrict_with_exception) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:area) }
    it { is_expected.to validate_presence_of(:name) }

    it_behaves_like "validates postcode is postcode-like", :venue
  end

  describe "#name" do
    it "strips whitespace before saving" do
      venue = build(:venue, name: " \tThe Alhambra ")

      venue.valid?

      expect(venue.name).to eq("The Alhambra")
    end
  end

  describe "#area" do
    it "strips whitespace before saving" do
      venue = build(:venue, area: " \tNewington Green ")

      venue.valid?

      expect(venue.area).to eq("Newington Green")
    end
  end

  describe "#postcode" do
    it "strips whitespace before saving" do
      venue = build(:venue, postcode: " \tN16 9RZ ")

      venue.valid?

      expect(venue.postcode).to eq("N16 9RZ")
    end
  end

  describe "#website" do
    it "strips whitespace before saving" do
      venue = build(:venue, website: " \thttps://alhambra.com ")

      venue.valid?

      expect(venue.website).to eq("https://alhambra.com")
    end
  end

  describe "can_delete?" do
    it "is true if there are no associated events" do
      venue = create(:venue)

      expect(venue.can_delete?).to be true
    end

    it "is false if there are associated events" do
      venue = create(:venue)
      create(:event, venue:)

      expect(venue.can_delete?).to be false
    end

    it "raises an exception if the venue is not persisted yet)" do
      venue = build(:venue)

      expect { venue.can_delete? }.to raise_error(
        RuntimeError, "Can't delete a Venue which is not persisted"
      )
    end
  end

  describe "#coordinates" do
    it "returns coordinates as a string" do
      venue = build(:venue, lat: 1.23, lng: 4.56)
      expect(venue.coordinates).to eq "[ 1.23, 4.56 ]"
    end

    context "when lat is nil" do
      it "is nil" do
        venue = build(:venue, lat: nil)

        expect(venue.coordinates).to be_nil
      end
    end

    context "when lng is nil" do
      it "is nil" do
        venue = build(:venue, lng: nil)

        expect(venue.coordinates).to be_nil
      end
    end
  end
end
