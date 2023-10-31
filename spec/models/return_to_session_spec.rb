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
  end

  describe "path" do
    context "when no return path is set" do
      it "is nil" do
        request = instance_double("ActionDispatch::Request", session: {})

        return_to_session = described_class.new(request)
        expect(return_to_session.path).to be_nil
      end
    end

    context "when a return path has been set" do
      it "returns the path" do
        request = instance_double("ActionDispatch::Request", session: { return_to: "/path/to/return/to" })

        return_to_session = described_class.new(request)
        expect(return_to_session.path).to eq "/path/to/return/to"
      end
    end
  end

  #   it "logs that the user logged in" do
  #     logger = instance_double("Logger", info: true)
  #     request = instance_double("ActionDispatch::Request", session: {})

  #     return_to_session = described_class.new(request, logger:)
  #     return_to_session.log_in!(auth_id: 12345678901234567, name: "Willa Mae Ricker", token: double, role: :editor)

  #     expect(logger).to have_received(:info).with("Logged in as auth id 12345678901234567")
  #   end

  #   context "when the role was :admin" do
  #     it "sets admin in the session" do
  #       session = {}
  #       request = instance_double("ActionDispatch::Request", session:)

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       return_to_session.log_in!(auth_id: 12345678901234567, name: "Willa Mae Ricker", token: double, role: :admin)

  #       expect(session[:user]["admin"]).to be true
  #     end

  #     it "logs that the user logged in as an admin" do
  #       logger = instance_double("Logger", info: true)
  #       request = instance_double("ActionDispatch::Request", session: {})

  #       return_to_session = described_class.new(request, logger:)
  #       return_to_session.log_in!(auth_id: 12345678901234567, name: "Willa Mae Ricker", token: double, role: :admin)

  #       expect(logger).to have_received(:info).with("Logged in as auth id 12345678901234567 with Admin permissions")
  #     end
  #   end
  # end

  # describe "log_out!" do
  #   it "resets the session" do
  #     session = { user: { "auth_id" => double } }
  #     request = instance_double("ActionDispatch::Request", session:, reset_session: double)

  #     return_to_session = described_class.new(request, logger: fake_logger)
  #     return_to_session.log_out!

  #     expect(request).to have_received(:reset_session)
  #   end

  #   it "logs that the user logged out" do
  #     logger = instance_double("Logger", info: true)
  #     session = { user: { "auth_id" => 12345678901234567 } }
  #     request = instance_double("ActionDispatch::Request", session:, reset_session: double)

  #     return_to_session = described_class.new(request, logger:)
  #     return_to_session.log_out!

  #     expect(logger).to have_received(:info).with("Logged out as auth id 12345678901234567")
  #   end
  # end

  # describe "#user.logged_in" do
  #   context "when the session has been set" do
  #     it "is true" do
  #       session = { user: { auth_id: 12345678901234567 } }
  #       request = instance_double("ActionDispatch::Request", session:)

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.logged_in?).to be true
  #     end
  #   end

  #   context "when the session has not been set" do
  #     it "is false" do
  #       request = instance_double("ActionDispatch::Request", session: {})

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.logged_in?).to be false
  #     end
  #   end
  # end

  # describe "#user.name" do
  #   context "when the session has been set" do
  #     it "is the name from the session" do
  #       session = { user: { "name" => "Leon James" } }
  #       request = instance_double("ActionDispatch::Request", session:)

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.name).to eq "Leon James"
  #     end
  #   end

  #   context "when the session has not been set" do
  #     it "is guest" do
  #       request = instance_double("ActionDispatch::Request", session: {})

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.name).to eq "Guest"
  #     end
  #   end
  # end

  # describe "#user.admin?" do
  #   context "when the session has been set as a non-admin" do
  #     it "is the just the name from the session" do
  #       session = { user: { "admin" => false } }
  #       request = instance_double("ActionDispatch::Request", session:)

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.admin?).to be false
  #     end
  #   end

  #   context "when the session has been set as an admin" do
  #     it "is the just the name from the session" do
  #       session = { user: { "admin" => true } }
  #       request = instance_double("ActionDispatch::Request", session:)

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.admin?).to be true
  #     end
  #   end

  #   context "when the session has not been set" do
  #     it "is false" do
  #       request = instance_double("ActionDispatch::Request", session: {})

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.admin?).to be false
  #     end
  #   end

  #   context "when the session doesn't contain an 'admin' key" do
  #     it "is false" do
  #       session = { user: { name: "Jimmy Valentine" } }
  #       request = instance_double("ActionDispatch::Request", session:)

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.admin?).to be false
  #     end
  #   end
  # end

  # describe "#user.name_with_role" do
  #   context "when the session has been set" do
  #     it "is the just the name from the session" do
  #       session = { user: { "name" => "Leon James", "admin" => false } }
  #       request = instance_double("ActionDispatch::Request", session:)

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.name_with_role).to eq "Leon James"
  #     end
  #   end

  #   context "when the session has been set as an admin" do
  #     it "is the just the name from the session" do
  #       session = { user: { "name" => "Herbert White", "admin" => true } }
  #       request = instance_double("ActionDispatch::Request", session:)

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.name_with_role).to eq "Herbert White (Admin)"
  #     end
  #   end

  #   context "when the session has not been set" do
  #     it "is guest" do
  #       request = instance_double("ActionDispatch::Request", session: {})

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.name_with_role).to eq "Guest"
  #     end
  #   end
  # end

  # describe "#user.auth_id" do
  #   context "when the session has been set" do
  #     it "is the id from the session" do
  #       session = { user: { "auth_id" => 76543210987654321 } }
  #       request = instance_double("ActionDispatch::Request", session:)

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.auth_id).to eq 76543210987654321
  #     end
  #   end

  #   context "when the session has not been set" do
  #     it "is a string representing that there is no id" do
  #       request = instance_double("ActionDispatch::Request", session: {})

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.auth_id).to eq "NO ID"
  #     end
  #   end
  # end

  # describe "#user.token" do
  #   context "when the session has been set" do
  #     it "is the token from the session" do
  #       token = double
  #       session = { user: { "token" => token } }
  #       request = instance_double("ActionDispatch::Request", session:)

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.token).to eq token
  #     end
  #   end

  #   context "when the session has not been set" do
  #     it "is a string representing that there is no token" do
  #       request = instance_double("ActionDispatch::Request", session: {})

  #       return_to_session = described_class.new(request, logger: fake_logger)
  #       expect(return_to_session.user.token).to eq "NO TOKEN"
  #     end
  #   end
  # end

  # def fake_logger
  #   instance_double("Logger", info: true)
  # end
end
