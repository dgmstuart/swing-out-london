# frozen_string_literal: true

require "rails_helper"

RSpec.describe ListingsHelper do
  describe "school_name" do
    context "when there is no organiser" do
      it "returns an empty string" do
        swingclass = build(:class, class_organiser: nil)
        expect(helper.school_name(swingclass)).to be_nil
      end
    end

    context "when there is a class organiser" do
      it "uses the name if the shortname doesn't exist" do
        organiser = build(:organiser, name: "foo", shortname: nil)
        swingclass = build(:class, class_organiser: organiser)
        expect(helper.school_name(swingclass)).to eq("foo")
      end

      it "uses the shortname as an abbreviation if it exists" do
        organiser = build(:organiser, name: "foo", shortname: "bar")
        swingclass = build(:class, class_organiser: organiser)
        expect(helper.school_name(swingclass)).to eq(%(<abbr title="foo">bar</abbr>))
      end
    end
  end
end
