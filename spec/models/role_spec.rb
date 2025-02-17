# frozen_string_literal: true

require "rails_helper"
require "support/shoulda_matchers"

RSpec.describe Role do
  describe "Validations" do
    subject { build(:role) }

    it { is_expected.to validate_uniqueness_of(:facebook_ref).case_insensitive }
    it { is_expected.to validate_presence_of(:facebook_ref) }
    it { is_expected.to allow_value("123456789").for(:facebook_ref) }
    it { is_expected.not_to allow_value("abc123").for(:facebook_ref) }
    it { is_expected.not_to allow_value("12345abc").for(:facebook_ref) }
    it { is_expected.to validate_presence_of(:role) }
  end

  describe "#role" do
    it "is an enum" do
      expect(described_class.new).to define_enum_for(:role)
        .with_values("admin" => "admin", "editor" => "editor")
        .backed_by_column_of_type(:string)
    end
  end
end
