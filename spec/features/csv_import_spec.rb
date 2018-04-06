require 'rails_helper'

RSpec.feature "csv import" do
  scenario "with valid csv" do
    FactoryBot.create(:event, title: "Boogaloo Bounce", url: "http://www.swingpatrol.co.uk/boogaloo-bounce/")
    FactoryBot.create(:event, title: "Book Club Blues", url: "http://www.swingpatrol.co.uk/book-club-blues/")

    login
    visit "/events/imports/new"
    fill_in "events_import_csv", with: csv_data
    click_on "Import"

    expect(page)
      .to have_content("Boogaloo Bounce")
      .and have_content("Saturday 9 Jan 2016")
      .and have_content("Book Club Blues")
      .and have_content("Sunday 10 Jan 2016")

    expect(Event.find_by_url("http://www.swingpatrol.co.uk/boogaloo-bounce/").swing_dates.count).to eq 0
    expect(Event.find_by_url("http://www.swingpatrol.co.uk/book-club-blues/").swing_dates.count).to eq 0

    click_on "Save"

    boogaloo_bounce = Event.find_by_url("http://www.swingpatrol.co.uk/boogaloo-bounce/")
    expect(boogaloo_bounce.swing_dates.count).to eq 24

    book_club_blues = Event.find_by_url("http://www.swingpatrol.co.uk/book-club-blues/")
    expect(book_club_blues.swing_dates.count).to eq 11

    expect(page).to have_content "New Venue" # i.e. on the admin homepage
  end

  scenario "with a url which doesn't match anything in the database" do
    login
    visit "/events/imports/new"
    fill_in "events_import_csv", with: csv_data
    click_on "Import"

    expect(page)
      .to have_content("will not be imported")
      .and have_content("not found")
      .and have_content("http://www.swingpatrol.co.uk/boogaloo-bounce/")
      .and have_content("09/01/2016, 23/01/2016")
  end


  def csv_data
    "http://www.swingpatrol.co.uk/boogaloo-bounce/,\"09/01/2016, 23/01/2016, 06/02/2016, 20/02/2016, 05/03/2016, 19/03/2016, 02/04/2016, 16/04/2016, 07/05/2016, 21/05/2016, 04/06/2016, 18/06/2016, 02/07/2016, 16/07/2016, 06/08/2016, 20/08/2016, 03/09/2016, 17/09/2016, 01/10/2016, 15/10/2016, 05/11/2016, 19/11/2016, 03/12/2016, 17/12/2016\"\nhttp://www.swingpatrol.co.uk/book-club-blues/,\"10/01/2016, 13/03/2016, 10/04/2016, 08/05/2016, 12/06/2016, 10/07/2016, 14/08/2016, 11/09/2016, 09/10/2016, 13/11/2016, 11/12/2016\""
  end
end
