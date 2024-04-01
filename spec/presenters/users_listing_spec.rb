# frozen_string_literal: true

require "spec_helper"
require "app/presenters/users_listing"

RSpec.describe UsersListing do
  describe "#users" do
    it "returns a list of users" do
      roles = [instance_double("Role", facebook_ref: 23, admin?: false)]
      user_name_finder = instance_double("UserName", name_for: "Mildred Pollard")
      listing = described_class.new(roles:, current_user_id: 17, user_name_finder:)

      results = listing.users

      expect(results.first).to have_attributes(
        id: 23,
        admin?: false,
        current?: false,
        name: "Mildred Pollard"
      )
    end

    it "identifies the current user" do
      roles = [instance_double("Role", facebook_ref: 17, admin?: true)]
      user_name_finder = instance_double("UserName", name_for: "Freida Washington")
      listing = described_class.new(roles:, current_user_id: 17, user_name_finder:)

      results = listing.users

      expect(results.first).to have_attributes(
        id: 17,
        admin?: true,
        current?: true,
        name: "Freida Washington"
      )
    end
  end
end
