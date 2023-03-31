# frozen_string_literal: true

require "rails_helper"

describe MapsController do
  describe "GET classes" do
    describe "assigns days correctly:" do
      before do
        allow(Venue).to receive(:all_with_classes_listed_on_day)
        allow(Venue).to receive(:all_with_classes_listed)
      end

      it "@day should be nil if the url contained no date part" do
        get :classes
        expect(assigns[:day]).to be_nil
      end

      it "@day should be a capitalised string if the url contained a day name" do
        get :classes, params: { day: "tuesday" }
        expect(assigns[:day]).to eq("Tuesday")
      end

      context "when the url contains a string which is not a day name" do
        it "redirects to the main classes page" do
          expect(get(:classes, params: { day: "fuseday" })).to redirect_to("/map/classes")
        end

        it "shows a flash message" do
          get :classes, params: { day: "fuseday" }
          expect(flash[:warn]).to eq "We can only show you classes for days of the week"
        end
      end

      context "when the day is described in words" do
        before do
          allow(controller).to receive(:today).and_return(Date.new(2012, 10, 11)) # A thursday
        end

        it "@day should be today's day name (capitalised) if the url contained 'today'" do
          get :classes, params: { day: "today" }
          expect(assigns[:day]).to eq("Thursday")
        end

        it "@day should be tomorrow's day name (capitalised) if the url contained 'tomorrow'" do
          get :classes, params: { day: "tomorrow" }
          expect(assigns[:day]).to eq("Friday")
        end

        context "the url contained 'yesterday'" do
          it "redirects to the main classes page" do
            expect(get(:classes, params: { day: "yesterday" })).to redirect_to("/map/classes")
          end

          it "shows a flash message" do
            get :classes, params: { day: "fuseday" }
            expect(flash[:warn]).to eq "We can only show you classes for days of the week"
          end
        end
      end
    end
  end

  describe "GET socials" do
    describe "@map_dates.selected_date" do
      subject(:selected_date) { assigns[:map_dates].selected_date }

      context "when the url contained no date" do
        it "is nil" do
          get :socials

          expect(selected_date).to be_nil
        end
      end

      context "when the url contains a date within the displayed range" do
        it "exposes that date" do
          Timecop.freeze(Date.new(2012, 12, 20)) do
            get :socials, params: { date: "2012-12-23" }

            expect(selected_date).to eq(Date.new(2012, 12, 23))
          end
        end
      end

      context "when the url contains a date outside the displayed range" do
        it "redirects to the main socials page" do
          Timecop.freeze(Date.new(2012, 12, 20)) do
            expect(get(:socials, params: { date: "2013-12-23" }))
              .to redirect_to("/map/socials")
          end
        end
      end

      context "when the url string doesn't represent a date" do
        it "redirects to the main socials page" do
          expect(get(:socials, params: { date: "asfasfasf" })).to redirect_to("/map/socials")
        end

        it "shows a flash message" do
          get :socials, params: { date: "asfasfasf" }
          expect(flash[:warn]).to eq "We can only show you events for the next 14 days"
        end
      end
    end
  end
end
