# frozen_string_literal: true

require 'rails_helper'
require 'support/shoulda_matchers'

RSpec.describe Organiser do
  describe 'Associations' do
    it { is_expected.to have_many(:classes).dependent(:restrict_with_exception) }
    it { is_expected.to have_many(:socials).dependent(:restrict_with_exception) }
  end

  describe 'can_delete?' do
    it 'is true if there are no associated events' do
      organiser = FactoryBot.build(:organiser)

      expect(organiser.can_delete?).to eq true
    end

    it 'is false if there are associated events' do
      organiser = FactoryBot.create(:organiser)
      FactoryBot.create(:event, social_organiser: organiser)

      expect(organiser.can_delete?).to eq false
    end
  end
end
