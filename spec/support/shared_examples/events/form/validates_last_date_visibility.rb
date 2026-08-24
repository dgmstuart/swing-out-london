# frozen_string_literal: true

RSpec.shared_examples "validates last date visibility" do |model_name|
  context "when show_last_date is true" do
    subject { build(model_name, show_last_date: true) }

    it { is_expected.to validate_presence_of(:last_date) }
  end

  context "when show_last_date is false" do
    subject { build(model_name, show_last_date: false) }

    it { is_expected.not_to validate_presence_of(:last_date) }
  end

  context "when show_last_date is nil" do
    subject { build(model_name, show_last_date: nil) }

    it { is_expected.not_to validate_presence_of(:last_date) }
  end
end
