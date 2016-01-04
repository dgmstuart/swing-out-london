require 'rails_helper'

describe Tweet do
  describe '.message' do
    before(:each) do
      allow_any_instance_of(Logger).to receive(:error)
      allow_any_instance_of(Logger).to receive(:info)
    end
    # The following basically tests the behaviour of API cache a bit more than it should, but I don't entirely trust/understand the interface, so these specs are to help with that understanding
    context "when the cache is available" do
      before(:each) do
        @store = double("APICache::DalliStore")
        allow(@store).to receive(:exists?).and_return(true)
        allow(APICache).to receive(:store).and_return(@store)
      end
      context "and the cache is current" do
        before(:each) do
          allow_any_instance_of(APICache::Cache).to receive(:state).and_return(:current)
          allow(@store).to receive(:get).and_return(:bar)
        end
        it "should not try and retrieve the message" do
          expect(Tweet).not_to receive(:get_message)
          Tweet.message
        end
        it "should retrieve the message from the cache" do
          expect(Tweet.message).to eq(:bar)
        end
      end
      context "and the cache is not current" do
        before(:each) do
          allow_any_instance_of(APICache::API).to receive(:check_queryable!) # For the purposes of testing: assume the cache can be queried
        end
        context "and the message can be retrieved from Twitter" do
          before(:each) do
            allow_any_instance_of(APICache::Cache).to receive(:state).and_return(:invalid)
            allow(Tweet).to receive(:get_message).and_return(:foo)
            allow(@store).to receive(:set)
          end
          it "should return the message" do
            expect(Tweet.message).to eq(:foo)
          end
        end
        context "and the message cannot be retrieved from Twitter" do
          before(:each) do
            allow(Twitter).to receive(:user_timeline).and_raise(Exception)
          end
          context "and the cache has not expired" do
            before(:each) do
              allow_any_instance_of(APICache::Cache).to receive(:state).and_return(:refetch)
            end
            it "should fetch the message from the cache" do
              expect(@store).to receive(:get).and_return(:baz)
              allow(@store).to receive(:set) # It updates the last queried date
              expect(Tweet.message).to eq(:baz)
            end
          end
          context "and the cache has expired" do
            before(:each) do
              allow_any_instance_of(APICache::Cache).to receive(:state).and_return(:invalid)
            end
            it "should return nil" do
              pending "doesn't work - don't know why"
              expect(Tweet.message).to be_nil
            end
          end
        end
      end
    end
    context "when the cache is not available" do
      before(:each) do
        allow(APICache).to receive(:store).and_raise(Dalli::RingError)
      end
      it "should try and retrieve the message" do
        expect(Tweet).to receive(:get_message)
        Tweet.message
      end
      context "and the tweet was retrieved" do
        before(:each) do
          allow(Tweet).to receive(:get_message).and_return(:foo)
        end
        it "should return the retrieved tweet" do
          expect(Tweet.message).to eq(:foo)
        end
      end
      context "and the tweet was not retrieved" do
        before(:each) do
          allow(Twitter).to receive(:user_timeline).and_raise(Exception)
        end
        it "should_return_nil" do
          expect(Tweet.message).to be_nil
        end
      end
    end
    context "when an error occurred (not related to the cache)" do
      before(:each) do
        allow(APICache).to receive(:get).and_raise(APICache::APICacheError)
        allow(Tweet).to receive(:get_message)
      end
      it "should attempt to retrieve the message from Twitter" do
        expect(Tweet).to receive(:get_message)
        Tweet.message
      end
    end
  end
end
