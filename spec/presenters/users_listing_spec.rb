# frozen_string_literal: true

require "spec_helper"
require "app/presenters/users_listing"

RSpec.describe UsersListing do
  describe "#users" do
    it "returns a list of users" do
      roles = [instance_double("Role", facebook_ref: 23, admin?: false)]
      user_name_finder = instance_double("UserName", name_for: "Mildred Pollard")
      listing = described_class.new(roles:, user_name_finder:)

      results = listing.users

      expect(results.first).to have_attributes(
        id: 23,
        admin?: false,
        name: "Mildred Pollard"
      )
    end
  end
end
