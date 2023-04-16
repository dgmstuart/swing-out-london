# frozen_string_literal: true

require "rails_helper"

describe EventsController do
  before { login }

  describe "GET show" do
    it "assigns @event" do
      event = create(:event)
      get :show, params: { id: event.to_param }
      expect(assigns[:event].title).to eq(event.title)
    end

    it "sets a message if there is no taster, class or social" do
      event = build(:event, has_taster: false, has_class: false, has_social: false)
      event.save(validate: false)
      get :show, params: { id: event.to_param }
      expect(assigns[:warning]).not_to be_blank
    end

    it "sets a message if there is a taster but no class or social" do
      event = build(:event, has_taster: true, has_class: false, has_social: false)
      event.save(validate: false)
      get :show, params: { id: event.to_param }
      expect(assigns[:warning]).not_to be_blank
    end

    it "assigns no message if there is a class or social" do
      event = create(:class)
      get :show, params: { id: event.to_param }
      expect(assigns[:warning]).to be_nil
    end
  end
end
