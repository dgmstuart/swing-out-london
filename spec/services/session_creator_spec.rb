# frozen_string_literal: true

require "spec_helper"
require "app/services/session_creator"

RSpec.describe SessionCreator do
  describe "#create" do
    context "when the user has a role in the system" do
      it "logs the user in" do
        authoriser = instance_double("described_class::Authoriser", authorised?: true)
        login_session = instance_double("LoginSession", log_in!: double)
        creator = described_class.new(authoriser:, login_session:, logger: fake_logger)

        user = instance_double(
          "AuthResponse",
          id: "abc123",
          name: "Wilda Crawford",
          token: "5up3r53cr3t",
          expires_at: "2024-01-01T01:01:01"
        )
        creator.create(user)

        expect(login_session).to have_received(:log_in!)
          .with(auth_id: "abc123", name: "Wilda Crawford", token: "5up3r53cr3t", token_expires_at: "2024-01-01T01:01:01")
      end

      it "returns true" do
        authoriser = instance_double("described_class::Authoriser", authorised?: true)
        login_session = instance_double("LoginSession", log_in!: double)
        creator = described_class.new(authoriser:, login_session:, logger: fake_logger)

        user = instance_double("AuthResponse", id: double, name: double, token: double, expires_at: double)
        result = creator.create(user)

        expect(result).to be true
      end
    end

    context "when the user doesn't have a role in the system" do
      it "does not log the user in" do
        authoriser = instance_double("described_class::Authoriser", authorised?: false)
        login_session = instance_double("LoginSession", log_in!: double)
        creator = described_class.new(authoriser:, login_session:, logger: fake_logger)

        user = instance_double("AuthResponse", id: double)
        creator.create(user)

        expect(login_session).not_to have_received(:log_in!)
      end

      it "returns false" do
        authoriser = instance_double("described_class::Authoriser", authorised?: false)
        login_session = instance_double("LoginSession", log_in!: double)
        creator = described_class.new(authoriser:, login_session:, logger: fake_logger)

        user = instance_double("AuthResponse", id: double)
        result = creator.create(user)

        expect(result).to be false
      end

      it "logs" do
        authoriser = instance_double("described_class::Authoriser", authorised?: false)
        login_session = instance_double("LoginSession", log_in!: double)
        logger = fake_logger
        creator = described_class.new(authoriser:, login_session:, logger:)

        user = instance_double("AuthResponse", id: "abc123")
        creator.create(user)

        expect(logger).to have_received(:warn)
          .with("Auth id abc123 tried to log in, but was not in the allowed list")
      end
    end
  end

  def fake_logger
    instance_double("Logger", warn: double)
  end
end
