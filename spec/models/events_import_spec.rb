# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EventsImport do
  describe '#persisted?' do
    it 'is false' do
      expect(described_class.new.persisted?).to eq false
    end
  end
end
