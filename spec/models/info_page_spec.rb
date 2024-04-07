# frozen_string_literal: true

require "spec_helper"
require "app/models/info_page"

RSpec.describe InfoPage do
  describe "#content_partials" do
    it "returns the list of content partials for the current city" do
      config = {
        dir_path: "foo/about",
        london: {
          content: %w[about_london london_history]
        },
        bristol: {
          content: %w[about_bristol bristol_history]
        }
      }
      pages = instance_double("InfoPages", page: config)

      page = described_class.new(:about, pages:, city: :london)

      aggregate_failures do
        partials = page.content_partials
        expect(partials[0].path).to eq "foo/about/about_london"
        expect(partials[0].name).to eq "about_london"
        expect(partials[1].path).to eq "foo/about/london_history"
        expect(partials[1].name).to eq "london_history"
      end
    end
  end

  describe "#sidebar_partials" do
    it "returns the list of content partials for the current city" do
      config = {
        dir_path: "foo/about",
        london: {
          sidebar: %w[lindy_hop about_us_london]
        },
        bristol: {
          sidebar: %w[lindy_hop about_us_bristol]
        }
      }
      pages = instance_double("InfoPages", page: config)

      page = described_class.new(:about, pages:, city: :bristol)

      aggregate_failures do
        partials = page.sidebar_partials
        expect(partials[0].path).to eq "foo/about/lindy_hop"
        expect(partials[0].name).to eq "lindy_hop"
        expect(partials[1].path).to eq "foo/about/about_us_bristol"
        expect(partials[1].name).to eq "about_us_bristol"
      end
    end
  end
end
