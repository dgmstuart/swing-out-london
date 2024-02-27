# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can clear the cache" do
  it "clears the cache and redirects to the events list" do
    enable_cache
    stub_login(admin: true)
    Rails.cache.write("a_cache_key", "a value")
    expect(Rails.cache.read("a_cache_key")).to eq("a value")

    visit "/login"
    click_on "Log in"

    click_on "Cache"
    click_on "Clear"

    expect(page).to have_content("Events")
    expect(Rails.cache.read("a_cache_key")).to be_nil
  end

  context "when logged in as a non-admin" do
    it "does not allow access" do
      stub_login(admin: false)

      visit "/login"
      click_on "Log in"

      expect(page).to have_no_content("Cache")

      visit "/admin/cache"

      expect(page).to have_content("You are not authorised to view this page")
    end
  end

  def enable_cache
    allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
  end
end
