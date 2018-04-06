require 'rails_helper'

describe WebsiteController do
  describe "GET index" do
    def stub_classes
      relation = double('ActiveRecord::Relation')
      allow(relation).to receive(:includes)
      allow(Event).to receive(:listing_classes).and_return relation
    end
    def stub_event_methods
      stub_classes
      allow(Event).to receive(:socials_dates).and_return []
    end

    it "should assign the 'last updated' strings" do
      stub_event_methods
      get :index
      expect(assigns[:last_updated_time]).not_to be_blank
      expect(assigns[:last_updated_date]).not_to be_blank
    end
    it "should assign the last updated datetime" do
      stub_event_methods
      get :index
      expect(assigns[:last_updated_datetime]).to be_a(Time)
    end
    it "should assign today" do
      stub_event_methods
      get :index
      expect(assigns[:today]).to be_a(Date)
    end
    it "should assign a list of events to @classes" do
      # CALLS MODEL
      allow(Event).to receive(:socials_dates).and_return []
      FactoryBot.create(:class)
      get :index
      expect(assigns[:classes][0]).to be_an(Event)
    end
    it "should assign an array containing a list of events to @socials_dates" do
      # CALLS MODEL
      stub_classes
      FactoryBot.create(:social, frequency: 1, day: "Monday")
      get :index
      expect(assigns[:socials_dates][0][1][0]).to be_an(Event)
    end

    @classes = Event.listing_classes.includes(:venue, :class_organiser, :swing_cancellations)
    @socials_dates
  end

  describe "GET about" do
    it "should assign the last updated times" do
      get :about
      expect(assigns[:last_updated_time]).not_to be_blank
      expect(assigns[:last_updated_date]).not_to be_blank
    end
  end

  describe "GET listings_policy" do
    it "should assign the last updated times" do
      get :listings_policy
      expect(assigns[:last_updated_time]).not_to be_blank
      expect(assigns[:last_updated_date]).not_to be_blank
    end
  end
end
