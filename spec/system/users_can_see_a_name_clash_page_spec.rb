# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users can see a name clash page" do
  it "displays a list of social names" do
    create(:social, title: "my awesome spectacular")

    visit "/name_clash"

    expect(page).to have_text("my awesome spectacular")
  end
end
