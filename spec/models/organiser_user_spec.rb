# frozen_string_literal: true

require "spec_helper"
require "app/models/organiser_user"

RSpec.describe OrganiserUser do
  describe "logged_in?" do
    it "is always true" do
      user = described_class.new(double)
      expect(user.logged_in?).to be true
    end
  end

  describe "name" do
    it "is a static string" do
      user = described_class.new(double)
      expect(user.name).to eq("Organiser")
    end
  end

  describe "auth_id" do
    it "is the token" do
      user = described_class.new("xyz")
      expect(user.auth_id).to eq("xyz")
    end
  end
end
