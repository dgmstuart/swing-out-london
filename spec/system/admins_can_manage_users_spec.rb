# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can manage users" do
  it "viewing a list of users", :vcr do
    stub_facebook_config(app_secret!: "super-secret-secret")
    stub_auth_hash(id: 98765987659876598)
    create(:editor, facebook_ref: 12345678901234567)
    create(:admin, facebook_ref: 98765987659876598)

    visit "/login"
    click_on "Log in"

    VCR.use_cassette("fetch_facebook_names") do
      click_on "Users"
    end

    expect(page).to have_content("Dawn Hampton")
    expect(page).to have_content("Herbert White (Admin)")
  end

  it "adding a role", :js, :vcr do
    stub_facebook_config(app_secret!: "super-secret-secret")
    stub_auth_hash(id: 98765987659876598)
    create(:admin, facebook_ref: 98765987659876598)

    visit "/login"
    click_on "Log in"

    VCR.use_cassette("fetch_facebook_names") do
      click_on "Users"

      expect(page).to have_no_content("Dawn Hampton")
    end

    fill_in "Facebook ID", with: 12345678901234567
    select "Editor", from: "Role"

    VCR.use_cassette("fetch_facebook_names") do
      click_on "Add user"

      expect(page).to have_content("Dawn Hampton")
    end
  end

  it "removing a role", :js, :vcr do
    stub_facebook_config(app_secret!: "super-secret-secret")
    create(:editor, facebook_ref: 12345678901234567)
    create(:admin, facebook_ref: 98765987659876598)

    Capybara.using_session("editor_session") do
      stub_auth_hash(id: "12345678901234567")
      visit "/login"
      click_on "Log in"

      expect(page).to have_content("Events")
    end

    Capybara.using_session("admin_session") do
      stub_auth_hash(id: "98765987659876598")
      visit "/login"
      click_on "Log in"

      VCR.use_cassette("fetch_facebook_names") do
        click_on "Users"
      end

      expect(page).to have_content("Dawn Hampton")
      expect(page).to have_content("Herbert White (Admin)")

      expect(user_row("Herbert White")).to have_no_content("Delete") # You shouldn't be able to delete yourself!

      within(user_row("Dawn Hampton")) do
        accept_alert { click_on("Delete") }
      end

      VCR.use_cassette("fetch_facebook_names") do
        # We need the cassette here because the page gets reloaded after clicking the button
        expect(page).to have_no_content("Dawn Hampton")
        expect(page).to have_content("Herbert White (Admin)")
      end
    end

    Capybara.using_session("editor_session") do
      click_on "Events"

      expect(page).to have_content("Editor Login")
    end
  end

  context "when logged in as a non-admin" do
    it "does not allow access" do
      stub_auth_hash(id: 12345678901234567)
      create(:editor, facebook_ref: 12345678901234567)

      visit "/login"
      click_on "Log in"

      expect(page).to have_no_content("Users")

      visit "/admin/users"

      expect(page).to have_content("You are not authorised to view this page")
    end
  end

  def user_row(user_name)
    find("li.user", text: user_name)
  end
end
