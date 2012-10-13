require 'spec_helper'

describe WebsiteController do
  describe "GET index" do
    before(:each) do
      relation = double('ActiveRecord::Relation')
      relation.stub(:includes)
      Event.stub(:listing_classes).and_return relation
      Event.stub(:socials_dates).and_return []
      
      get :index
    end
    it "should assign the 'last updated' strings" do
      assigns[:last_updated_time].should_not be_blank
      assigns[:last_updated_date].should_not be_blank
    end
    it "should assign the last updated datetime" do
      assigns[:last_updated_datetime].should be_a(Time)
    end
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
end