# frozen_string_literal: true

require "spec_helper"
require "app/models/login_session"
require "active_support/core_ext/object/blank"

RSpec.describe LoginSession do
  describe "log_in!" do
    it "sets user data in the session" do
      session = {}
      request = instance_double("ActionDispatch::Request", session: session)
      token = double

      login_session = described_class.new(request, logger: fake_logger)
      login_session.log_in!(auth_id: 12345678901234567, name: "Willa Mae Ricker", token: token)

      aggregate_failures do
        expect(session[:user]["auth_id"]).to eq 12345678901234567
        expect(session[:user]["name"]).to eq "Willa Mae Ricker"
        expect(session[:user]["token"]).to eq token
      end
    end

    it "logs that the user logged in" do
      logger = instance_double("Logger", info: true)
      request = instance_double("ActionDispatch::Request", session: {})

      login_session = described_class.new(request, logger: logger)
      login_session.log_in!(auth_id: 12345678901234567, name: "Willa Mae Ricker", token: double)

      expect(logger).to have_received(:info).with("Logged in as auth id 12345678901234567")
    end
  end

  describe "log_out!" do
    it "resets the session" do
      session = { user: { "auth_id" => double } }
      request = instance_double("ActionDispatch::Request", session: session, reset_session: double)

      login_session = described_class.new(request, logger: fake_logger)
      login_session.log_out!

      expect(request).to have_received(:reset_session)
    end

    it "logs that the user logged out" do
      logger = instance_double("Logger", info: true)
      session = { user: { "auth_id" => 12345678901234567 } }
      request = instance_double("ActionDispatch::Request", session: session, reset_session: double)

      login_session = described_class.new(request, logger: logger)
      login_session.log_out!

      expect(logger).to have_received(:info).with("Logged out as auth id 12345678901234567")
    end
  end

  describe "#user.logged_in" do
    context "when the session has been set" do
      it "is true" do
        session = { user: { auth_id: 12345678901234567 } }
        request = instance_double("ActionDispatch::Request", session: session)

        login_session = described_class.new(request, logger: fake_logger)
        expect(login_session.user.logged_in?).to be true
      end
    end

    context "when the session has not been set" do
      it "is false" do
        request = instance_double("ActionDispatch::Request", session: {})

        login_session = described_class.new(request, logger: fake_logger)
        expect(login_session.user.logged_in?).to be false
      end
    end
  end

  describe "#user.name" do
    context "when the session has been set" do
      it "is the name from the session" do
        session = { user: { "name" => "Leon James" } }
        request = instance_double("ActionDispatch::Request", session: session)

        login_session = described_class.new(request, logger: fake_logger)
        expect(login_session.user.name).to eq "Leon James"
      end
    end

    context "when the session has not been set" do
      it "is guest" do
        request = instance_double("ActionDispatch::Request", session: {})

        login_session = described_class.new(request, logger: fake_logger)
        expect(login_session.user.name).to eq "Guest"
      end
    end
  end

  describe "#user.auth_id" do
    context "when the session has been set" do
      it "is the id from the session" do
        session = { user: { "auth_id" => 76543210987654321 } }
        request = instance_double("ActionDispatch::Request", session: session)

        login_session = described_class.new(request, logger: fake_logger)
        expect(login_session.user.auth_id).to eq 76543210987654321
      end
    end

    context "when the session has not been set" do
      it "is a string representing that there is no id" do
        request = instance_double("ActionDispatch::Request", session: {})

        login_session = described_class.new(request, logger: fake_logger)
        expect(login_session.user.auth_id).to eq "NO ID"
      end
    end
  end

  describe "#user.token" do
    context "when the session has been set" do
      it "is the token from the session" do
        token = double
        session = { user: { "token" => token } }
        request = instance_double("ActionDispatch::Request", session: session)

        login_session = described_class.new(request, logger: fake_logger)
        expect(login_session.user.token).to eq token
      end
    end

    context "when the session has not been set" do
      it "is a string representing that there is no token" do
        request = instance_double("ActionDispatch::Request", session: {})

        login_session = described_class.new(request, logger: fake_logger)
        expect(login_session.user.token).to eq "NO TOKEN"
      end
    end
  end

  def fake_logger
    instance_double("Logger", info: true)
  end
end
