# frozen_string_literal: true

require "spec_helper"
require "action_view"
require "action_view/helpers" # for pluralize
require "app/presenters/access_token_expiry"

RSpec.describe AccessTokenExpiry do
  describe "#offset_string" do
    context "when the expiry time is exactly 60 days in the future (max life of a FB token)" do
      it "returns an expiry message" do
        user = instance_double("LoginSession::User", token_expires_at: (1709475483 + 5184000)) # 5184000 = 60 days
        now_in_seconds = 1709475483 # 1709475483 = 2024-03-03 15:18:03 +0100
        presenter = described_class.new(user:, now_in_seconds:)

        expect(presenter.offset_string).to eq("will expire in 60 days")
      end
    end

    context "when the expiry time is slightly less than 60 days in the future (max life of a FB token)" do
      it "still says 60 days" do
        user = instance_double("LoginSession::User", token_expires_at: (1709475483 + 5183999)) # 5183999
        now_in_seconds = 1709475483 # 1709475483 = 2024-03-03 15:18:03 +0100
        presenter = described_class.new(user:, now_in_seconds:)

        expect(presenter.offset_string).to eq("will expire in 60 days")
      end
    end

    context "when the expiry time is tomorrow" do
      it "returns an expiry message" do
        user = instance_double("LoginSession::User", token_expires_at: (1709475483 + 86400)) # 86400 = 1 day
        now_in_seconds = 1709475483 # 1709475483 = 2024-03-03 15:18:03 +0100
        presenter = described_class.new(user:, now_in_seconds:)

        expect(presenter.offset_string).to eq("will expire in 1 day")
      end
    end

    context "when the expiry time is in less than 24 hours" do
      it "returns an expiry message" do
        user = instance_double("LoginSession::User", token_expires_at: (1709475483 + 43200)) # 43200 = 12 hours
        now_in_seconds = 1709475483 # 1709475483 = 2024-03-03 15:18:03 +0100
        presenter = described_class.new(user:, now_in_seconds:)

        expect(presenter.offset_string).to eq("will expire in 1 day") # a little ambiguous, but close enough
      end
    end

    context "when the expiry time is in the past" do
      it "returns an expiry message" do
        user = instance_double("LoginSession::User", token_expires_at: (1709475483 - 86400)) # 86400 = 1 day
        now_in_seconds = 1709475483 # 1709475483 = 2024-03-03 15:18:03 +0100
        presenter = described_class.new(user:, now_in_seconds:)

        expect(presenter.offset_string).to eq("has expired")
      end
    end

    context "when the expiry time is less than 24 hours ago" do
      it "returns an expiry message" do
        user = instance_double("LoginSession::User", token_expires_at: (1709475483 - 43200)) # 43200 = 12 hours
        now_in_seconds = 1709475483 # 1709475483 = 2024-03-03 15:18:03 +0100
        presenter = described_class.new(user:, now_in_seconds:)

        expect(presenter.offset_string).to eq("has expired")
      end
    end
  end
end
