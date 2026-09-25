# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users can see legal policy pages" do
  it "Shows a privacy policy page" do
    visit "privacy"

    expect(page).to have_text("Privacy Policy")
  end
end
