require 'spec_helper'

describe Event do
  before(:each) do
    @event = Event.new
  end
  
  describe "modernise" do
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
  
    pending "multiple valid cancellations, one invalid date on the end"
    pending "multiple valid cancellations, one invalid date in the middle"
    pending "blanking out where there are existing cancellations"
    pending "fails to add an invalid date to an event"
  
    pending "save with an invalid cancellations array"

    pending "test with multiple cancellations, different orders, whitespace"
  end
  
  pending "test existing events functionality #{__FILE__}"
end