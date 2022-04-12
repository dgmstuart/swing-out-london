# frozen_string_literal: true

require 'rails_helper'

describe EventsController do
  before { login }

  describe 'GET show' do
    it 'assigns @event' do
      event = create(:event)
      get :show, params: { id: event.to_param }
      expect(assigns[:event].title).to eq(event.title)
    end

    it 'sets a message if there is no taster, class or social' do
      event = build(:event, has_taster: false, has_class: false, has_social: false)
      event.save(validate: false)
      get :show, params: { id: event.to_param }
      expect(assigns[:warning]).not_to be_blank
    end

    it 'sets a message if there is a taster but no class or social' do
      event = build(:event, has_taster: true, has_class: false, has_social: false)
      event.save(validate: false)
      get :show, params: { id: event.to_param }
      expect(assigns[:warning]).not_to be_blank
    end

    it 'assigns no message if there is a class or social' do
      event = create(:class)
      get :show, params: { id: event.to_param }
      expect(assigns[:warning]).to be_nil
    end
  end

  describe 'GET new' do
    context 'when a venue id is provided which matches a venue' do
      it 'creates an event at that venue' do
        venue = create(:venue, id: 23)
        get :new, params: { venue_id: 23 }
        expect(assigns(:event).venue).to eq venue
      end
    end

    context "when a venue id is provided which doesn't match a venue" do
      [
        23,
        nil
      ].each do |vid|
        it 'creates an event with a null venue' do
          get :new, params: { venue_id: vid }
          expect(assigns(:event).venue).to be_nil
        end
      end
    end
  end
end
