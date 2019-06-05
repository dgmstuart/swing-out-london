# frozen_string_literal: true

require 'rails_helper'
require 'support/shoulda_matchers'

RSpec.describe Venue do
  describe 'Associations' do
    it { is_expected.to have_many(:events).dependent(:restrict_with_exception) }
  end
end
