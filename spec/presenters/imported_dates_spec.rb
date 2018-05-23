require 'spec_helper'
require 'date'
require 'app/presenters/imported_dates'

RSpec.describe ImportedDates do
  describe "#name" do
    it "defers to the passed in object" do
      presenter = ImportedDates.new(instance_double("EventsImporter::Success", name: "frank chimes"))
      expect(presenter.name).to eq "frank chimes"
    end
  end

  describe "#dates_to_import" do
    it "formats the dates nicely" do
      presenter = ImportedDates.new(instance_double("EventsImporter::Success", dates_to_import: ["03/01/2016", "10/01/2016"]))
      expect(presenter.dates_to_import).to eq "Sunday 3 Jan 2016, Sunday 10 Jan 2016"
    end
  end
end
