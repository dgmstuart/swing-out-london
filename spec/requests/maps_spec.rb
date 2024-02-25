# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Maps" do
  describe "/classes" do
    context "when the url contains a string which is not a day name" do
      it "redirects to the main classes page" do
        expect(get("/map/classes/fuseday"))
          .to redirect_to("/map/classes")
      end
    end
  end

  describe "/socials" do
    context "when the url contains a date outside the displayed range" do
      it "redirects to the main socials page" do
        Timecop.freeze(Date.new(2012, 12, 20)) do
          expect(get("/map/socials/2013-12-23"))
            .to redirect_to("/map/socials")
        end
      end
    end

    context "when the url string doesn't represent a date" do
      it "redirects to the main socials page" do
        expect(get("/map/socials/notadate"))
          .to redirect_to("/map/socials")
      end
    end
  end
end
