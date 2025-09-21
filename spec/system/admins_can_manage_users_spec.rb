# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can manage users" do
  around do |example|
    VCR.use_cassette("fetch_facebook_names", allow_playback_repeats: true) do
      example.run
    end
  end

  it "viewing a list of users", :vcr do
    stub_facebook_config(app_secret!: "super-secret-secret")
    stub_auth_hash(id: 98765987659876598)
    create(:editor, facebook_ref: 12345678901234567)
    create(:admin, facebook_ref: 98765987659876598)

    visit "/login"
    click_on "Log in"

    click_on "Users"
    wait_for_user_page_load

    expect(page).to have_content("Dawn Hampton")
    expect(page).to have_content("Herbert White (Admin)")
  end

  it "adding a role", :js, :vcr do
    stub_facebook_config(app_secret!: "super-secret-secret")
    stub_auth_hash(id: 98765987659876598)
    create(:admin, facebook_ref: 98765987659876598)

    visit "/admin/users"

    click_on "Log in"
    wait_for_user_page_load

    expect(page).to have_no_content("Dawn Hampton")

    fill_in "Facebook ID", with: 12345678901234567
    select "Editor", from: "Role"

    click_on "Add user"

    expect(page).to have_content("Dawn Hampton")
  end

  context "when the facebook ref is the wrong format" do
    it "shows a validation error", :js, :vcr do
      stub_facebook_config(app_secret!: "super-secret-secret")
      stub_auth_hash(id: 98765987659876598)
      create(:admin, facebook_ref: 98765987659876598)

      visit "/admin/users"

      click_on "Log in"
      wait_for_user_page_load

      fill_in "Facebook ID", with: "dawn.hampton"
      select "Editor", from: "Role"

      click_on "Add user"

      expect(page).to have_content("Facebook ID must contain only digits")
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
      visit "/admin/users"

      click_on "Log in"
      wait_for_user_page_load

      expect(page).to have_content("Dawn Hampton")
      expect(page).to have_content("Herbert White (Admin)")

      expect(user_row("Herbert White")).to have_no_content("Delete") # You shouldn't be able to delete yourself!

      within(user_row("Dawn Hampton")) do
        accept_alert { click_on("Delete") }
      end

      expect(page).to have_content("Herbert White (Admin)")
      expect(page).to have_no_content("Dawn Hampton")
    end

    Capybara.using_session("editor_session") do
      open_menu
      click_on "Events"

      expect(page).to have_content("Editor Login")
    end
  end

  it "promoting an editor to an admin", :js, :vcr do
    stub_facebook_config(app_secret!: "super-secret-secret")
    create(:editor, facebook_ref: 12345678901234567)

    skip_login("/admin/users", admin: true)
    expect(page).to have_content("Dawn Hampton")

    within(user_row("Dawn Hampton")) do
      accept_alert { click_on("Make admin") }
    end

    expect(page).to have_content("Dawn Hampton (Admin)")
    expect(user_row("Dawn Hampton")).to have_no_content("Make admin")
    expect(user_row("Dawn Hampton")).to have_link("Remove admin")
  end

  it "removing admin privileges from a user", :js, :vcr do
    stub_facebook_config(app_secret!: "super-secret-secret")
    create(:admin, facebook_ref: 12345678901234567)

    skip_login("/admin/users", admin: true)
    expect(page).to have_content("Dawn Hampton (Admin)")

    within(user_row("Dawn Hampton")) do
      click_on("Remove admin")
    end

    wait_for_turbo_preview

    within(user_row("Dawn Hampton")) do
      expect(page).to have_link("Make admin")
      expect(page).to have_no_content("(Admin)")
      expect(page).to have_no_content("Remove admin")
    end
  end

  it "does not show the facebook test user", :vcr do
    test_user_app_id = "12345678901234567"
    stub_facebook_config(test_user_app_id:, app_secret!: "super-secret-secret")
    create(:editor, facebook_ref: test_user_app_id)

    skip_login("/admin/users", admin: true)
    wait_for_user_page_load

    expect(page).to have_no_content(test_user_app_id)
  end

  context "when logged in as a non-admin", :ignore_cassettes do
    it "does not allow access" do
      skip_login(admin: false)

      expect(page).to have_no_content("Users")

      visit "/admin/users"

      expect(page).to have_content("You are not authorised to view this page")
    end
  end

  def user_row(user_name)
    find("li.user", text: user_name)
  end

  def wait_for_user_page_load
    expect(page).to have_button("Add user")
  end

  def wait_for_turbo_preview
    turbo_preview_window_selector = "html[data-turbo-preview]"
    page.has_css?(turbo_preview_window_selector, wait: 0.5) # don't hang if we already missed it
    expect(page).to have_no_css(turbo_preview_window_selector)
  end
end
