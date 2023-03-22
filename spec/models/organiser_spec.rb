# frozen_string_literal: true

require 'rails_helper'
require 'support/shoulda_matchers'

RSpec.describe Organiser do
  describe 'Associations' do
    it { is_expected.to have_many(:classes).dependent(:restrict_with_exception) }
    it { is_expected.to have_many(:socials).dependent(:restrict_with_exception) }
  end

  describe 'Validations' do
    it { is_expected.to validate_uniqueness_of(:shortname) }
  end

  describe '#name' do
    it 'strips whitespace before saving' do
      organiser = build(:organiser, name: " \tHerbert White ")

      organiser.valid?

      expect(organiser.name).to eq('Herbert White')
    end
  end

  describe '#website' do
    it 'strips whitespace before saving' do
      organiser = build(:organiser, website: " \thttps://whitey.com ")

      organiser.valid?

      expect(organiser.website).to eq('https://whitey.com')
    end
  end

  describe 'shortname=' do
    context 'when the value was not blank' do
      it 'strips whitespace before saving' do
        organiser = build(:organiser)
        organiser.shortname = ' Whitey '

        organiser.valid?

        expect(organiser.shortname).to eq 'Whitey'
      end
    end

    context 'when the value was nil' do
      it 'sets the value' do
        organiser = build(:organiser)

        organiser.shortname = nil

        expect(organiser.shortname).to be_nil
      end
    end

    context 'when the value was empty' do
      it 'sets the value to nil' do
        organiser = build(:organiser)

        organiser.shortname = ''

        expect(organiser.shortname).to be_nil
      end
    end
  end

  describe 'can_delete?' do
    it 'is true if there are no associated events' do
      organiser = create(:organiser)
      create(:event, social_organiser: nil)

      expect(organiser.can_delete?).to be true
    end

    it 'is false if there are associated events' do
      organiser = create(:organiser)
      create(:event, social_organiser: organiser)

      expect(organiser.can_delete?).to be false
    end

    it 'raises an exception if the organiser id is nil (not persisted yet)' do
      organiser = build(:organiser)
      create(:event, social_organiser: nil)

      expect { organiser.can_delete? }.to raise_error(
        RuntimeError, "Can't delete an Organiser which is not persisted"
      )
    end
  end
end
