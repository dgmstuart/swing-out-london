require 'rails_helper'

describe EventsController do
  http_login

  describe "GET show" do
    it "should assign @event" do
      event = FactoryBot.create(:event)
      get :show, id: event.to_param
      expect(assigns[:event]).to eq(event)
    end

    it "should set a message if there is no taster, class or social" do
      event = FactoryBot.build(:event, has_taster: false, has_class: false, has_social: false)
      event.save(validate: false)
      get :show, id: event.to_param
      expect(assigns[:warning]).not_to be_blank
    end

    it "should set a message if there is a taster but no class or social" do
      event = FactoryBot.build(:event, has_taster: true, has_class: false, has_social: false)
      event.save(validate: false)
      get :show, id: event.to_param
      expect(assigns[:warning]).not_to be_blank
    end
    it "should assign no message if there is a class or social" do
      event = FactoryBot.create(:class)
      get :show, id: event.to_param
      expect(assigns[:warning]).to be_nil
    end

  end

  describe "GET new" do
    context 'when a venue id is provided' do
      before { @venue = FactoryBot.create(:venue, id: 23) }
      context 'which matches a venue' do
        before { get :new, venue_id: 23 }
        it "creates an event at that venue" do
          expect(assigns(:event).venue).to eq @venue
        end
      end
      context "which doesn't match a venue" do
        [
          101011010,
          nil
        ].each do |vid|
          before { get :new, venue_id: vid }
          it "creates an event with a null venue" do
            expect(assigns(:event).venue).to be_nil
          end
        end
      end
    end

  end
end
