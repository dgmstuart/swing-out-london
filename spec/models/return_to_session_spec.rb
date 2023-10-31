# frozen_string_literal: true

require "spec_helper"
require "app/models/return_to_session"
# require "active_support/core_ext/object/blank"

RSpec.describe ReturnToSession do
  describe "store!" do
    it "sets the return path in the session" do
      session = {}
      request = instance_double("ActionDispatch::Request", session:)

      return_to_session = described_class.new(request)
      return_to_session.store!("/path/to/return/to")

      expect(session[:return_to]).to eq "/path/to/return/to"
    end

    it "only stores the path" do
      session = {}
      request = instance_double("ActionDispatch::Request", session:)

      return_to_session = described_class.new(request)
      return_to_session.store!("https://www.a_sketchy-host.com/path/to/return/to?sketchy_url_params")

      expect(session[:return_to]).to eq "/path/to/return/to"
    end

    it "ignores things which don't look like paths" do
      session = {}
      request = instance_double("ActionDispatch::Request", session:)

      return_to_session = described_class.new(request)
      return_to_session.store!(1)

      expect(session[:return_to]).to be_nil
    end
  end

  describe "path" do
    context "when no return path is set" do
      it "returns the fallback" do
        request = instance_double("ActionDispatch::Request", session: {})

        return_to_session = described_class.new(request)
        expect(return_to_session.path(fallback: "/home")).to eq "/home"
      end
    end

    context "when a return path has been set" do
      it "returns the path" do
        request = instance_double("ActionDispatch::Request", session: { return_to: "/path/to/return/to" })

        return_to_session = described_class.new(request)
        expect(return_to_session.path(fallback: double)).to eq "/path/to/return/to"
      end

      it "_only_ returns the path" do
        sketchy_url = "https://www.a_sketchy-host.com/path/to/return/to?sketchy_url_params"
        request = instance_double("ActionDispatch::Request", session: { return_to: sketchy_url })

        return_to_session = described_class.new(request)
        expect(return_to_session.path(fallback: double)).to eq "/path/to/return/to"
      end

      it "ignores things which don't look like paths" do
        request = instance_double("ActionDispatch::Request", session: { return_to: 1 })

        return_to_session = described_class.new(request)
        expect(return_to_session.path(fallback: "/home")).to eq "/home"
      end
    end
  end
end
