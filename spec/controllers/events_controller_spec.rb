require 'spec_helper'

describe EventsController do
  http_login
  
  describe "GET show" do
    it "should assign @event" do
      event = FactoryGirl.create(:event)
      get :show, :id => event.to_param
      assigns[:event].should == event
    end
    it "should set a message if there is no taster, class or social" do
      event = FactoryGirl.build(:event, has_taster: false, has_class: false, has_social: false)
      event.save(:validate => false)
      get :show, :id => event.to_param
      assigns[:warning].should_not be_blank
    end
    it "should set a message if there is a taster but no class or social" do
      event = FactoryGirl.build(:event, has_taster: true, has_class: false, has_social: false)
      event.save(:validate => false)
      get :show, :id => event.to_param
      assigns[:warning].should_not be_blank
    end
    it "should assign no message if there is a class or social" do
      event = FactoryGirl.create(:class)
      get :show, id: event.to_param
      assigns[:warning].should be_nil
    end
    
  end
end