# frozen_string_literal: true

require 'rails_helper'
require 'support/shoulda_matchers'

RSpec.describe Venue do
  describe 'Associations' do
    it { is_expected.to have_many(:events).dependent(:restrict_with_exception) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:area) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#name' do
    it 'strips whitespace before saving' do
      venue = build(:venue, name: " \tThe Alhambra ")

      venue.valid?

      expect(venue.name).to eq('The Alhambra')
    end
  end

  describe '#area' do
    it 'strips whitespace before saving' do
      venue = build(:venue, area: " \tNewington Green ")

      venue.valid?

      expect(venue.area).to eq('Newington Green')
    end
  end

  describe '#postcode' do
    it 'strips whitespace before saving' do
      venue = build(:venue, postcode: " \tN16 9RZ ")

      venue.valid?

      expect(venue.postcode).to eq('N16 9RZ')
    end
  end

  describe '#website' do
    it 'strips whitespace before saving' do
      venue = build(:venue, website: " \thttps://alhambra.com ")

      venue.valid?

      expect(venue.website).to eq('https://alhambra.com')
    end
  end

  describe 'can_delete?' do
    it 'is true if there are no associated events' do
      venue = create(:venue)

      expect(venue.can_delete?).to be true
    end

    it 'is false if there are associated events' do
      venue = create(:venue)
      create(:event, venue: venue)

      expect(venue.can_delete?).to be false
    end

    it 'raises an exception if the venue is not persisted yet)' do
      venue = build(:venue)

      expect { venue.can_delete? }.to raise_error(
        RuntimeError, "Can't delete a Venue which is not persisted"
      )
    end
  end
end
