# frozen_string_literal: true

require "rails_helper"
require "spec/support/system/clipboard_helper"

RSpec.describe "Editors can copy an organiser link" do
  include System::ClipboardHelper

  context "when an organiser token exists", :js do
    it "shows a url which will allow an organiser to edit an event, and allows the editor to change the link" do
      event = create(:event, organiser_token: "abc123")
      grant_clipboard_permissions

      skip_login("/events/#{event.id}/edit")

      url = URI.join(page.server_url, "/external_events/abc123/edit").to_s
      expect(page).to have_field("Organiser edit link", with: url)

      click_on "Copy"

      expect(page).to have_content("Copied")
      expect(clipboard_text).to eq(url)

      allow(SecureRandom).to receive(:hex).and_return("xyz789")

      accept_confirm do
        click_on "revoke this link"
      end

      wait_for_turbo_refresh(turbo_frame_id: "organiser_link")

      new_url = URI.join(page.server_url, "/external_events/xyz789/edit").to_s
      expect(page).to have_field("Organiser edit link", with: new_url)
      expect(page).to have_no_field("Organiser edit link", with: url)

      event.reload
      expect(event.organiser_token).not_to eq "abc123"
      new_url = URI.join(page.server_url, "/external_events/#{event.organiser_token}/edit").to_s
      expect(page).to have_field("Organiser edit link", with: new_url)
    end
  end

  context "when an organiser token does not exist", :js do
    it "allows one to be generated" do
      event = create(:event, organiser_token: nil)
      grant_clipboard_permissions
      allow(SecureRandom).to receive(:hex).and_return("abc123")

      skip_login("/events/#{event.id}/edit")

      expect(page).to have_content("No organiser edit link exists for this event")

      click_on "Generate link"

      wait_for_turbo_refresh(turbo_frame_id: "organiser_link")

      url = URI.join(page.server_url, "/external_events/abc123/edit").to_s
      expect(page).to have_field("Organiser edit link", with: url)
      expect(page).to have_link("revoke this link")
      expect(page).to have_content("Copied")
      expect(clipboard_text).to eq(url)
      expect(page).to have_link("Copy")
    end
  end

  context "when the event fails to save" do
    it "shows an error" do
      create(:event, organiser_token: "abc123")
      allow(SecureRandom).to receive(:hex).and_return("abc123")
      event = create(:event)
      allow(event).to receive(:update).and_return false

      skip_login("/events/#{event.id}/edit")

      click_on "Generate link"

      expect(page).to have_content("Something went wrong")
    end
  end

  def organiser_link_url
    find("#organiser_link input").value
  end

  def wait_for_turbo_refresh(turbo_frame_id:)
    turbo_frame_selector = "turbo-frame##{turbo_frame_id}"
    expect(page).to have_css(turbo_frame_selector) # check: are we correctly referencing the frame
    busy_selector = "#{turbo_frame_selector}[busy]"
    page.has_css?(busy_selector, wait: 0.5) # short, don't hang if we're checking after the busyness has already happened
    expect(page).to have_no_css(busy_selector)
  end
end
