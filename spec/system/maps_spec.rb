# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Maps" do
  describe "Classes" do
    context "when no day is specified" do
      it "renders page metadata without a day" do
        visit "/map/classes"

        expect(page).to have_title("Swing Out London's Lindy Map: Classes\n")
        expect(page).to have_description_matching(/A map of all the Lindy Hop classes in London\s+also classes /)
      end
    end

    context "when a day is specified" do
      it "renders page metadata with a day" do
        visit "/map/classes/tuesday"

        expect(page).to have_title(/Swing Out London's Lindy Map: Classes\s+on Tuesdays/)
        expect(page).to have_description_matching(/A map of all the Lindy Hop classes in London\s+on Tuesdays,\s+also class/)
      end
    end

    context "when the day is 'today'" do
      it "renders page metadata with a day" do
        allow(SOLDNTime).to receive(:today).and_return(Date.new(2012, 10, 11)) # A thursday
        visit "/map/classes/today"

        expect(page).to have_title(/Swing Out London's Lindy Map: Classes\s+on Thursdays/)
      end
    end

    context "when the day is 'tomorrow'" do
      it "renders page metadata with a day" do
        allow(SOLDNTime).to receive(:today).and_return(Date.new(2012, 10, 11)) # A thursday
        visit "/map/classes/tomorrow"

        expect(page).to have_title(/Swing Out London's Lindy Map: Classes\s+on Fridays/)
      end
    end
  end

  describe "Socials" do
    context "when no date is specified" do
      it "renders page metadata without a day" do
        visit "/map/socials"

        expect(page).to have_title("Swing Out London's Lindy Map: Socials\n")
        expect(page).to have_description_matching("A map of all the opportunities to dance")
      end
    end

    context "when the url contains a date within the displayed range" do
      it "exposes that date" do
        Timecop.freeze(Date.new(2012, 12, 20)) do
          visit "/map/socials/2012-12-23"

          expect(page).to have_title(/Swing Out London's Lindy Map: Socials\s+on Sunday 23rd December/)
          expect(page).to have_description_matching("A map of all the opportunities to dance")
          expect(page).to have_description_matching("on Sunday 23rd December")
        end
      end
    end
  end
end
