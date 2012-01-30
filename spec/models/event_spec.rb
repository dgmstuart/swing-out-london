require 'spec_helper'

describe Event do
  before(:each) do
    @event = Event.new
  end
  
  describe ".self.socials_dates" do 
    describe "one social" do
      it "returns the correct array with one event with one social in the future" do
        one_date = Date.today + 7
        event = FactoryGirl.create(:intermittent_social, :dates => [one_date])
        Event.socials_dates(Date.today).should == [[one_date,[event]]] 
      end
    
      it "returns the correct array with one event with two socials in the future" do
        later_date = Date.today + 7
        earlier_date = Date.today + 1
        event = FactoryGirl.create(:intermittent_social, :dates => [later_date,earlier_date])
        Event.socials_dates(Date.today).should == [[earlier_date,[event]],[later_date,[event]]] 
      end
    
      it "returns the correct array with one event with one social today, one at the limit and one outside the limit" do
        lower_limit_date = Date.today
        upper_limit_date = Date.today + 13
        outside_limit_date = Date.today + 14
        event = FactoryGirl.create(:intermittent_social, :dates => [upper_limit_date, outside_limit_date, lower_limit_date])
        Event.socials_dates(Date.today).should == [[lower_limit_date,[event]],[upper_limit_date,[event]]] 
      end
    
      it "returns the correct array with one event with one social in the future and one in the past" do
        past_date = Date.today - 1.month
        future_date = Date.today + 5
        event = FactoryGirl.create(:intermittent_social, :dates => [past_date,future_date])
        Event.socials_dates(Date.today).should == [[future_date,[event]]] 
      end
    end
    
    pending "add more tests for socials_dates which return multiple events"
    pending "add tests including weekly events!"
    
    describe "complex examples" do
      
      def d(n)
        Date.today + n
      end
      
      pending "do more complex examples!"
      
      #class_with_social = FactoryGirl.create(:class, :event_type =>"class_with_social", :day => "Tuesday")
      
      it "returns the correct array with a bunch of classes and socials" do
        #create one class for each day, starting on monday. None of these should be included
        FactoryGirl.create_list(:class,7)
        
        # not included events:
        old_event_1 = FactoryGirl.create(:intermittent_social, :dates => [d(-10)])
        old_event_2 = FactoryGirl.create(:intermittent_social, :dates => [d(-370)])
        far_event_1 = FactoryGirl.create(:intermittent_social, :dates => [d(20)])
        
        # included events:
        event_d1 = FactoryGirl.create(:intermittent_social, :dates => [d(1)])
        event_d10_d11 = FactoryGirl.create(:social, :frequency => 4, :dates => [d(10),d(11)])
        event_1_d8 = FactoryGirl.create(:social, :frequency => 4, :dates => [d(8)])
        event_2_d8 = FactoryGirl.create(:social, :frequency => 2, :dates => [d(8)])

        Event.socials_dates(Date.today).should == [
          [d(1),[event_d1]],
          [d(8),[event_1_d8, event_2_d8]],
          [d(10),[event_d10_d11]],
          [d(11),[event_d10_d11]]
        ] 
      end
    end
  end
  
  
  
  describe ".modernise" do
    it "handles events with no dates" do
      @event[:date_array] = []
      @event.dates.should == []
      @event.modernise
      @event.dates.should == []
    end
    
    it "takes a date_array of strings and saves swing_dates" do
      @event[:date_array] = ["09/04/2011", "14/05/2011", "11/06/2011"]
      @event.dates.should == []
      @event[:cancellation_array] = ["14/05/2011"]
      @event.modernise
      @event.dates.should == [Date.new(2011,4,9), Date.new(2011,5,14), Date.new(2011,6,11)]
      @event.cancellations.should == [Date.new(2011,5,14)]
    end  
    
    it "takes a date_array of dates and saves swing_dates" do
      @event[:date_array] = [Date.new(2011,4,9), Date.new(2011,5,14), Date.new(2011,6,11)]
      @event.dates.should == []
      @event[:cancellation_array] = [Date.new(2011,6,11)]
      @event.modernise
      @event.dates.should == [Date.new(2011,4,9), Date.new(2011,5,14), Date.new(2011,6,11)]
      @event.cancellations.should == [Date.new(2011,6,11)]
    end
  end
  
  # ultimately do away with date_array and test .dates= instead" 
  describe ".date_array =" do
    
    describe "empty strings" do
      it "handles an event with with no dates and adding no dates" do
        @event.date_array = ""
        @event.swing_dates.should == []
      end
    
      it "handles an event with with no dates and adding nil dates" do
        @event.date_array = nil
        @event.swing_dates.should == []
      end
    
      it "handles an event with no dates and adding unknown dates" do
        @event.date_array = Event::UNKNOWN_DATE
        @event.swing_dates.should == []
      end
    
      it "handles an event with no dates and a weekly event" do
        @event.date_array = Event::WEEKLY
        @event.swing_dates.should == []
      end
    end

    it "successfully adds one valid date to an event" do
      @event.date_array = "01/02/2012"
      @event.dates.should == [Date.new(2012,02,01)]
    end
  
    it "successfully adds two valid dates to an event with no dates and orders them" do
      @event.date_array = "01/02/2012, 30/11/2011"
      @event.dates.should == [Date.new(2012,02,01), Date.new(2011,11,30)]
    end
  
    it "blanks out a date array where there existing dates" do 
      @event = FactoryGirl.create(:event, :date_array => "01/02/2012, 30/11/2011")
      @event.dates.should == [Date.new(2012,02,01), Date.new(2011,11,30)]
      @event.date_array=""
      @event.dates.should == []
    end
  
    pending "multiple valid dates, one invalid date on the end"
    pending "multiple valid dates, one invalid date in the middle"
    pending "blanking out where there are existing dates"
    pending "fails to add an invalid date to an event"
  
    pending "save with an invalid dates array"

    pending "test with multiple dates, different orders, whitespace"

  end

  describe ".cancellation_array = " do
    describe "empty strings" do
      it "handles an event with with no cancellations and adding no cancellations" do
        @event.cancellation_array = ""
        @event.swing_cancellations.should == []
      end
  
      it "handles an event with with no cancellations and adding nil cancellations" do
        @event.cancellation_array = nil
        @event.swing_cancellations.should == []
      end
  
      it "handles an event with no cancellations and adding unknown cancellations" do
        @event.cancellation_array = Event::UNKNOWN_DATE
        @event.swing_cancellations.should == []
      end
  
      it "handles an event with no cancellations and a weekly event" do
        @event.cancellation_array = Event::WEEKLY
        @event.swing_cancellations.should == []
      end
    end
  
    it "successfully adds one valid cancellation to an event with no cancellations" do
      @event.cancellation_array = "01/02/2012"
      @event.cancellations.should == [Date.new(2012,02,01)]
    end
  
    it "successfully adds two valid cancellations to an event with no cancellations and orders them" do
      @event.cancellation_array = "01/02/2012, 30/11/2011"
      @event.cancellations.should == [Date.new(2012,02,01), Date.new(2011,11,30)]
    end
    
    it "blanks out a cancellation array where there existing dates" do 
      event = FactoryGirl.create(:event, :cancellation_array => "01/02/2012")
      event.cancellations.should == [Date.new(2012,02,01)]
      event.cancellation_array=""
      event.cancellations.should == []
    end
  
    pending "multiple valid cancellations, one invalid date on the end"
    pending "multiple valid cancellations, one invalid date in the middle"
    pending "fails to add an invalid date to an event"
  
    pending "save with an invalid cancellations array"

    pending "test with multiple cancellations, different orders, whitespace"
  end
  
  pending "test existing events functionality #{__FILE__}"
end