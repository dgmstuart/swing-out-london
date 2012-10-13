require 'spec_helper'

describe MapsController do
  describe "GET classes" do
    describe "assigns days correctly:" do
      before(:each) do
        Venue.stub(:all_with_classes_listed_on_day)
        Venue.stub(:all_with_classes_listed)
      end
      it "@day should be nil if the url contained no date part" do
        get :classes
        assigns[:day].should be_nil
      end

      it "@day should be a capitalised string if the url contained a day name" do
        get :classes, day: "tuesday"
        assigns[:day].should == "Tuesday"
      end
      it "should raise a 404 if the url contained a string which was a day name" do
        expect { get :classes, day: "fuseday" }.to raise_error(ActiveRecord::RecordNotFound)
      end
      context "when the day is described in words" do
        before(:each) do
          controller.stub(:today).and_return(Date.new(2012,10,11)) # A thursday
        end
        it "@day should be today's day name (capitalised) if the url contained 'today'" do
          get :classes, day: "today"
          assigns[:day].should == "Thursday"
        end
        it "@day should be tomorrow's day name (capitalised) if the url contained 'tomorrow'" do
          get :classes, day: "tomorrow"
          assigns[:day].should == "Friday"
        end
        it "should raise a 404 if the url contained 'yesterday'" do
          expect { get :classes, day: "yesterday" }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
    
    context "when there are no venues to display" do
      def map_is_centred_on_london
        assigns[:map_options][:center_latitude].should == 51.5264
        assigns[:map_options][:center_longitude].should == -0.0878
      end
      after(:each) do
        map_is_centred_on_london
      end
      context "and there is a day" do
        before(:each) do
          controller.stub(:get_day).and_return("Monday")
        end
        after(:each) do
          get :classes, day: "Monday"
        end
        it "should centre map on London (empty array)" do
          Venue.stub(:all_with_classes_listed_on_day).and_return([])
        end
        it "should render an empty map (nil array)" do
          Venue.stub(:all_with_classes_listed_on_day).and_return(nil)
        end
      end
      context "and there is no day" do
        after(:each) do
          get :classes
        end
        it "should centre map on London (empty array)" do
          Venue.stub(:all_with_classes_listed).and_return([])
        end
        it "should render an empty map (nil array)" do
          Venue.stub(:all_with_classes_listed).and_return(nil)
        end
      end   
    end
    context "when there is exactly one venue" do
      before(:each) do
        venue = FactoryGirl.create(:venue)
        Venue.stub(:all_with_classes_listed).and_return([venue])
        relation = double("Array")
        relation.stub(:includes)
        Event.stub(:listing_classes_at_venue).and_return(relation)
        get :classes
      end
      it "should set the zoom level to 14" do
        assigns[:map_options][:zoom].should == 14
      end
      it "should disable auto zoom" do
        assigns[:map_options][:auto_zoom].should == false
      end
    end
    # it "assigns @teams" do
    #   team = Team.create
    #   get :index
    #   assigns(:teams).should eq([team])
    # end
    # 
    # it "renders the index template" do
    #   get :index
    #   response.should render_template("index")
    # end
  end
  
  describe "GET socials" do
    it "should assign an array of dates to @listings dates" do
      #Stub out irrelevant logic:
      controller.stub(:get_date)
      Event.stub(:socials_dates).and_return([])
      
      Event.stub(:listing_dates).and_return([Date.new])
      
      get :socials
      assigns[:listing_dates].should be_an(Array)
      assigns[:listing_dates][0].should be_a(Date)
    end
    
    describe "assigns dates correctly:" do
      before(:each) do
        Event.stub(:socials_on_date).and_return([])
        Event.stub(:socials_dates).and_return([])
      end
      it "@date should be nil if the url contained no date" do
        get :socials
        assigns[:day].should be_nil
      end
      context "when the url contains a string representing a date" do
        before(:each) do
          @date_string = "2012-12-23"
          @date = Date.new(2012,12,23)
        end
        it "@date should be a date if that date is in the listing dates" do
          Event.stub(:listing_dates).and_return([@date])
          get :socials, date: @date_string 
          assigns[:date].should == @date
        end
        it "should raise a 404 if the date is not in the listing dates" do
          Event.stub(:listing_dates).and_return([])
          expect { get :socials, date: @date_string }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end    
      context "when the url contains a date described in words" do
        before(:each) do
          @date = Date.today
          controller.stub(:today).and_return(@date)
        end
        it "@date should be today's date if the description is 'today'" do
          get :socials, date: "today"
          assigns[:date].should == @date
        end
        it "@date should be tomorrow's date if the description is 'tomorrow'" do
          get :socials, date: "tomorrow"
          assigns[:date].should == @date + 1
        end
        it "should raise a 404 if the description is 'yesterday'" do
          expect { get :socials, date: "yesterday" }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
      it "should raise a 404 if the url contains as string which doesn't represent a date" do
        expect { get :socials, date: "asfasfasf" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    context "when there is exactly one venue" do
      before(:each) do
        event = FactoryGirl.create(:social)
        Event.stub(:socials_dates).and_return([[nil,event]])
        get :socials
      end
      it "should set the zoom level to 14" do
        assigns[:map_options][:zoom].should == 14
      end
      it "should disable auto zoom" do
        assigns[:map_options][:auto_zoom].should == false
      end
    end
  end

end