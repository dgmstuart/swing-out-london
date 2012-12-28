require 'spec_helper'

describe Tweet do
  describe '.message' do
    before(:each) do
      Logger.any_instance.stub(:error)
      Logger.any_instance.stub(:info)
    end
    # The following basically tests the behaviour of API cache a bit more than it should, but I don't entirely trust/understand the interface, so these specs are to help with that understanding
    context "when the cache is available" do
      before(:each) do
        @store = double("APICache::DalliStore")
        @store.stub(:exists?).and_return(true)
        APICache.stub(:store).and_return(@store)
      end
      context "and the cache is current" do
        before(:each) do
          APICache::Cache.any_instance.stub(:state).and_return(:current)
          @store.stub(:get).and_return(:bar)
        end
        it "should not try and retrieve the message" do
          Tweet.should_not_receive(:get_message)
          Tweet.message
        end
        it "should retrieve the message from the cache" do
          Tweet.message.should == :bar
        end
      end
      context "and the cache is not current" do
        before(:each) do
          APICache::API.any_instance.stub(:check_queryable!) # For the purposes of testing: assume the cache can be queried
        end
        context "and the message can be retrieved from Twitter" do
          before(:each) do
            APICache::Cache.any_instance.stub(:state).and_return(:invalid)
            Tweet.stub(:get_message).and_return(:foo)
            @store.stub(:set)
          end
          it "should return the message" do
            Tweet.message.should == :foo
          end
        end
        context "and the message cannot be retrieved from Twitter" do
          before(:each) do
            Twitter.stub(:user_timeline).and_raise(Exception)
          end
          context "and the cache has not expired" do
            before(:each) do
              APICache::Cache.any_instance.stub(:state).and_return(:refetch)
            end
            it "should fetch the message from the cache" do
              @store.should_receive(:get).and_return(:baz)
              @store.stub(:set) # It updates the last queried date
              Tweet.message.should == :baz
            end
          end
          context "and the cache has expired" do
            before(:each) do
              APICache::Cache.any_instance.stub(:state).and_return(:invalid)
            end
            it "should return nil" do
              pending "doesn't work - don't know why"
              Tweet.message.should be_nil
            end
          end
        end
      end
    end
    context "when the cache is not available" do
      before(:each) do
        APICache.stub(:store).and_raise(Dalli::RingError)
      end
      it "should try and retrieve the message" do
        Tweet.should_receive(:get_message)
        Tweet.message
      end
      context "and the tweet was retrieved" do
        before(:each) do
          Tweet.stub(:get_message).and_return(:foo)
        end
        it "should return the retrieved tweet" do
          Tweet.message.should == :foo
        end
      end
      context "and the tweet was not retrieved" do
        before(:each) do
          Twitter.stub(:user_timeline).and_raise(Exception)
        end
        it "should_return_nil" do
          Tweet.message.should be_nil
        end
      end
    end
    context "when an error occurred (not related to the cache)" do
      before(:each) do
        APICache.stub(:get).and_raise(APICache::RuntimeError)
        Tweet.stub(:get_message)
      end
      it "should attempt to retrieve the message from Twitter" do
        Tweet.should_receive(:get_message)
        Tweet.message
      end
    end
  end
end