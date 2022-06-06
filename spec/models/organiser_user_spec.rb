# frozen_string_literal: true

require 'spec_helper'
require 'app/models/organiser_user'

describe OrganiserUser do
  describe 'logged_in?' do
    it 'is always true' do
      user = described_class.new(double)
      expect(user.logged_in?).to be true
    end
  end

  describe 'name' do
    it 'includes the token' do
      user = described_class.new('xyz')
      expect(user.name).to eq('Organiser (xyz)')
    end
  end

  describe 'auth_id' do
    it 'is the token' do
      user = described_class.new('xyz')
      expect(user.auth_id).to eq('xyz')
    end
  end
end
