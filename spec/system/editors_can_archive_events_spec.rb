# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can archive events" do
  it "with a weekly event" do
    skip_login
    create(:event, frequency: 1, day: "Sunday")

    visit "/events"

    # 8th Jan 2000 was a saturday
    Timecop.freeze(Time.zone.local(2000, 1, 8)) do
      click_on "Archive", match: :first
    end

    click_show

    expect(page).to have_content("Last date: 02/01/2000") # the previous Sunday
  end

  it "with an occasional event" do
    skip_login
    create(:event, frequency: 0, dates: ["02/01/2000".to_date])

    visit "/events"

    Timecop.freeze(Time.zone.local(2000, 1, 8)) do
      click_on "Archive", match: :first
    end

    click_show

    expect(page).to have_content("Last date: 02/01/2000")
  end

  it "with an event with no dates" do
    skip_login
    create(:event, frequency: 0, dates: [])

    visit "/events"

    click_on "Archive", match: :first

    click_show

    expect(page).to have_content("Last date: (archived)")
  end

  context "when the event is already archived" do
    it "succeeds but doesn't update the date" do
      skip_login
      event = create(:event, frequency: 0, dates: ["02/01/2000".to_date])

      visit "/events"

      Timecop.freeze("2000-01-08") do
        event.update!(last_date: "2000-01-02")

        click_on "Archive", match: :first
      end

      click_show

      expect(page).to have_content("Last date: 02/01/2000")
    end
  end

  context "when the event couldn't be saved for some reason" do
    it "raises an error" do
      skip_login
      event = create(:event, frequency: 0, dates: ["02/01/2000".to_date])
      # Set url to an invalid value to simulate failed save
      event.update_attribute(:url, "not-a-url") # rubocop:disable Rails/SkipsModelValidations

      visit "/events"

      Timecop.freeze(Time.zone.local(2000, 1, 8)) do
        click_on "Archive", match: :first
      end

      expect(page).to have_content("This event could not be archived - try editing it first.")
    end
  end

  def click_show
    within ".actions.last", match: :first do
      click_on "Show"
    end
  end
end
