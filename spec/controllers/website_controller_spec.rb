require 'spec_helper'

describe WebsiteController do
  describe "GET index" do
    def stub_classes
      relation = double('ActiveRecord::Relation')
      relation.stub(:includes)
      Event.stub(:listing_classes).and_return relation
    end
    def stub_event_methods
      stub_classes
      Event.stub(:socials_dates).and_return []
    end
      
    it "should assign the 'last updated' strings" do
      stub_event_methods
      get :index
      assigns[:last_updated_time].should_not be_blank
      assigns[:last_updated_date].should_not be_blank
    end
    it "should assign the last updated datetime" do
      stub_event_methods
      get :index
      assigns[:last_updated_datetime].should be_a(Time)
    end
    it "should assign today" do
      stub_event_methods
      get :index
      assigns[:today].should be_a(Date)
    end
    it "should assign a list of events to @classes" do
      # CALLS MODEL
      Event.stub(:socials_dates).and_return []
      FactoryGirl.create(:class)
      get :index
      assigns[:classes][0].should be_an(Event)
    end
    it "should assign an array containing a list of events to @socials_dates" do
      # CALLS MODEL
      stub_classes
      FactoryGirl.create(:social, frequency: 1, day: "Monday")
      get :index
      assigns[:socials_dates][0][1][0].should be_an(Event)
    end
    
    @classes = Event.listing_classes.includes(:venue, :class_organiser, :swing_cancellations)
    @socials_dates
  end
  
  describe "GET about" do
    it "should assign the last updated times" do
      get :about
      assigns[:last_updated_time].should_not be_blank
      assigns[:last_updated_date].should_not be_blank
    end
  end
  
  describe "GET listings_policy" do
    it "should assign the last updated times" do
      get :listings_policy
      assigns[:last_updated_time].should_not be_blank
      assigns[:last_updated_date].should_not be_blank
    end
  end
  
  describe "GET latest_tweet" do
    before(:each) do
      Tweet.stub(:message).and_return("Foo")
    end
    it "should assign the latest_tweet" do
      get :latest_tweet
      assigns[:tweet].should be_a (String)      
    end
  end
end