# frozen_string_literal: true

require "rails_helper"

RSpec.describe Audit do
  describe "#editor_name" do
    it "is the name of the person who made the change" do
      audit = build(:audit, username: { "name" => "Alice" })

      expect(audit.editor_name).to eq "Alice"
    end
  end
end
