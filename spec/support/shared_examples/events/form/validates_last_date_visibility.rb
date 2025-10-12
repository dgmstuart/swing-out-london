# frozen_string_literal: true

RSpec.shared_examples "validates last date visibility" do |model_name|
  context "when status is ending" do
    subject { build(model_name, status: "ending") }

    it { is_expected.to validate_presence_of(:last_date) }
  end

  context "when status is ongoing" do
    subject { build(model_name, status: "ongoing") }

    it { is_expected.not_to validate_presence_of(:last_date) }
  end

  context "when status is nil" do
    subject { build(model_name, status: nil) }

    it { is_expected.not_to validate_presence_of(:last_date) }
  end
end
