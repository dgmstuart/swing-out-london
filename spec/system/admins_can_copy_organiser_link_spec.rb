# frozen_string_literal: true

require "rails_helper"
require "spec/support/system/clipboard_helper"

RSpec.describe "Admins can copy an organiser link" do
  include System::ClipboardHelper

  context "when an organiser token exists", :js do
    it "shows a url which will allow an organiser to edit an event" do
      event = create(:event, organiser_token: "abc123")
      grant_clipboard_permissions

      skip_login
      visit "/events/#{event.id}/edit"

      url = URI.join(page.server_url, "/external_events/abc123/edit").to_s
      expect(page).to have_content(url)

      click_on "Copy"

      expect(clipboard_text).to eq(url)
    end
  end

  context "when an organiser token does not exist", :js do
    it "allows one to be generated" do
      event = create(:event, organiser_token: nil)
      allow(SecureRandom).to receive(:hex).and_return("abc123".dup)

      skip_login
      visit "/events/#{event.id}/edit"

      expect(page).to have_content("No organiser edit link exists for this event")

      click_on "Generate link"

      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content("/external_events/abc123/edit")
    end
  end
end
