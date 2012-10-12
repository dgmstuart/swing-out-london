require 'spec_helper'

describe Event do
  before(:each) do
    @event = Event.new
  end
  
  describe ".self.socials_dates" do
    
    context "when there is only one social" do
      it "returns the correct array when that social has only one date in the future" do
        one_date = Date.today + 7
        event = FactoryGirl.create(:intermittent_social, :dates => [one_date])
        Event.socials_dates(Date.today).length.should == 1
        Event.socials_dates(Date.today)[0][0].should == one_date
        Event.socials_dates(Date.today)[0][1].should == [event] 
      end
    
      it "returns the correct array when that social has two dates in the future" do
        later_date = Date.today + 7
        earlier_date = Date.today + 1
        event = FactoryGirl.create(:intermittent_social, :dates => [later_date,earlier_date])
        
        Event.socials_dates(Date.today).length.should == 2
        Event.socials_dates(Date.today)[0][0].should == earlier_date
        Event.socials_dates(Date.today)[0][1].should == [event]
        Event.socials_dates(Date.today)[1][0].should == later_date
        Event.socials_dates(Date.today)[1][1].should == [event]
      end
    
      it "returns the correct array when that social has one date today, one at the limit and one outside the limit" do
        lower_limit_date = Date.today
        upper_limit_date = Date.today + 13
        outside_limit_date = Date.today + 14
        event = FactoryGirl.create(:intermittent_social, :dates => [upper_limit_date, outside_limit_date, lower_limit_date])
        
        Event.socials_dates(Date.today).length.should == 2
        Event.socials_dates(Date.today).should == [[lower_limit_date,[event],[]],[upper_limit_date,[event],[]]] 
      end
    
      it "returns the correct array when that social has one date in the future and one in the past" do
        past_date = Date.today - 1.month
        future_date = Date.today + 5
        event = FactoryGirl.create(:intermittent_social, :dates => [past_date,future_date])
        
        Event.socials_dates(Date.today).length.should == 1
        Event.socials_dates(Date.today).should == [[future_date,[event],[]]] 
      end
    end
    
    pending "add more tests for socials_dates which return multiple events"
    pending "add tests including weekly events!"
    
    context "in a complex scenario" do
      
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
          [d(1),[event_d1],[]],
          [d(8),[event_1_d8, event_2_d8],[]],
          [d(10),[event_d10_d11],[]],
          [d(11),[event_d10_d11],[]]
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
    
    it "shouldn't create multiple instances of the same date" do
      event1 = FactoryGirl.create(:event)
      event1.date_array = "05/05/2005"
      event1.save!
      event2 = FactoryGirl.create(:event)
      event2.date_array = "05/05/2005"
      event2.save!
      SwingDate.where(:date => Date.new(2005,05,05)).length.should == 1
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
  
  require File.dirname(__FILE__) + '/../spec_helper'

  describe "active.classes" do
    it "should return classes with no 'last date'" do
      event = FactoryGirl.create(:class, last_date: nil)
      Event.active.classes.should == [event]
    end
    
    it "should not return classes with a 'last date' in the past" do
      FactoryGirl.create(:class, last_date: Date.today - 1)
      Event.active.classes.should == []
    end
    
    it "should not return non-classes" do
      FactoryGirl.create(:event, last_date: nil, has_class: "false")
      FactoryGirl.create(:event, last_date: nil, has_taster: "true")
      
      Event.active.classes.should == []
    end
    
    it "should return the correct list of classes" do
      FactoryGirl.create(:social, last_date: nil)
      FactoryGirl.create(:class, last_date: Date.today - 5)
      returned = [
        FactoryGirl.create(:class),
        FactoryGirl.create(:class, last_date: nil),
        FactoryGirl.create(:class, :last_date => Date.today + 1),
      ]
      FactoryGirl.create(:social)
      FactoryGirl.create(:event, has_class: "false", has_taster: "true")
      
      Event.active.classes.length.should == returned.length
      returned.should include(Event.active.classes[0])
      returned.should include(Event.active.classes[1])
      returned.should include(Event.active.classes[2])
    end
    
  end
  
  pending "test existing events functionality #{__FILE__}"
  
  describe "(validations)" do
    it "should be invalid if it has neither a class nor a social nor a taster" do
      FactoryGirl.build(:event, has_taster: false, has_social: false, has_class: false).should_not be_valid
    end
    it "should be invalid if it has a taster but no class or social" do
      FactoryGirl.build(:event, has_taster: true, has_social: false, has_class: false).should_not be_valid
    end
    it "should be valid if it has a class but no taster or social (and everything else is OK)" do
      FactoryGirl.build(:event, has_taster: false, has_social: false, has_class: true).should be_valid
    end
    it "should be valid if it has a social but no taster or class (and everything else is OK)" do
      FactoryGirl.build(:event, has_taster: false, has_social: true, has_class: false).should be_valid
    end
  end
end