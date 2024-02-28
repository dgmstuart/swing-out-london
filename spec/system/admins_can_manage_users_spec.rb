# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can manage users" do
  it "viewing a list of users", :vcr do
    stub_facebook_config(
      editor_user_ids: [12345678901234567],
      admin_user_ids: [98765987659876598],
      app_secret!: "super-secret-secret"
    )
    stub_auth_hash(id: 98765987659876598)

    visit "/login"
    click_on "Log in"

    VCR.use_cassette("fetch_facebook_names") do
      click_on "Users"
    end

    expect(page).to have_content("Dawn Hampton")
    expect(page).to have_content("Herbert White (Admin)")
  end

  context "when logged in as a non-admin" do
    it "does not allow access" do
      stub_facebook_config(editor_user_ids: [12345678901234567], admin_user_ids: [98765987659876598])
      stub_auth_hash(id: 12345678901234567)

      visit "/login"
      click_on "Log in"

      expect(page).to have_no_content("Users")

      visit "/admin/users"

      expect(page).to have_content("You are not authorised to view this page")
    end
  end

  def enable_cache
    allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
  end
end
