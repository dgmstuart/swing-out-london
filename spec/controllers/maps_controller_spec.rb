require 'spec_helper'

describe MapsController do
  describe "GET classes" do
    context "when there is no 'date' parameter" do
      context "when there are no venues to display" do
        before(:each) do
          # TEMP
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
    end
  end
  
  
  describe "get_day" do
    it "should return nil if the input is nil" do
      controller.get_day(nil).should be_nil
    end
   
    it "should return a capitalised string if the input is a day name" do
      controller.get_day("tuesday").should == "Tuesday"
    end
    it "should raise a 404 if the input is not a day name" do
      expect { controller.get_day("fuseday") }.to raise_error(ActiveRecord::RecordNotFound)
    end
    context "when the day is described in words" do
      before(:each) do
        controller.stub(:today).and_return(Date.new(2012,10,11)) # A thursday
      end
      it "should return today's day name (capitalised) if the string is 'today'" do
        controller.get_day("today").should == "Thursday"
      end
      it "should return tomorrow's day name (capitalised) if the string is 'tomorrow'" do
        controller.get_day("tomorrow").should == "Friday"
      end
      it "should raise a 404 if the string is 'yesterday'" do
        expect { controller.get_day("yesterday") }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end 
  
  describe "get_date" do
    it "should return nil if the input is nil" do
      controller.get_date(nil).should be_nil
    end
    context "when the string represents a date" do
      before(:each) do
        @date_string = "2012-12-23"
        @date = Date.new(2012,12,23)
      end
    
      it "should return a date if the date is in the listing dates" do
        Event.stub(:listing_dates).and_return([@date])
        controller.get_date(@date_string).should == @date
      end
      it "should raise a 404 if the date is not in the listing dates" do
        Event.stub(:listing_dates).and_return([])
        expect { controller.get_date(@date_string) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end    
    context "when the date is described in words" do
      before(:each) do
        @date = Date.new
        controller.stub(:today).and_return(@date)
      end
      it "should return today's date if the input is 'today'" do
        controller.get_date("today").should == @date
      end
      it "should return tomorrow's date if the input is 'tomorrow'" do
        controller.get_date("tomorrow").should == @date + 1
      end
      it "should raise a 404 if the input is 'yesterday'" do
        expect { controller.get_date("yesterday") }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    it "should raise a 404 if the input doesn't represent a date" do
      expect { controller.get_date("asfasfasf") }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end