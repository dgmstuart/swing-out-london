# frozen_string_literal: true

require "spec_helper"
require "app/models/auth_response"

RSpec.describe AuthResponse do
  it "works" do
    described_class.new(double)
  end

  describe "#id" do
    it "returns the UID from the auth hash" do
      request_env = {
        "omniauth.auth" => {
          "provider" => "facebook",
          "uid" => "72432833316128378",
          "info" => {
            "name" => "Felipe Goyette Jr.",
            "image" => "http://graph.facebook.com/v2.10/72432833316128378/picture"
          },
          "credentials" => {
            "token" => "0469a691b47c1df413e95edabd336ca3",
            "expires_at" => 1546086985,
            "expires" => true
          },
          "extra" => {
            "raw_info" => { "name" => "72432833316128378", "id" => "72432833316128378" }
          }
        }
      }

      response = described_class.new(request_env)

      expect(response.id).to eq "72432833316128378"
    end
  end

  describe "#name" do
    it "returns the name from the auth hash" do
      request_env = {
        "omniauth.auth" => {
          "provider" => "facebook",
          "uid" => "72432833316128378",
          "info" => {
            "name" => "Felipe Goyette Jr.",
            "image" => "http://graph.facebook.com/v2.10/72432833316128378/picture"
          },
          "credentials" => {
            "token" => "0469a691b47c1df413e95edabd336ca3",
            "expires_at" => 1546086985,
            "expires" => true
          },
          "extra" => {
            "raw_info" => { "name" => "72432833316128378", "id" => "72432833316128378" }
          }
        }
      }

      response = described_class.new(request_env)

      expect(response.name).to eq "Felipe Goyette Jr."
    end
  end

  describe "#token" do
    it "returns the token from the auth hash" do
      request_env = {
        "omniauth.auth" => {
          "provider" => "facebook",
          "uid" => "72432833316128378",
          "info" => {
            "name" => "Felipe Goyette Jr.",
            "image" => "http://graph.facebook.com/v2.10/72432833316128378/picture"
          },
          "credentials" => {
            "token" => "0469a691b47c1df413e95edabd336ca3",
            "expires_at" => 1546086985,
            "expires" => true
          },
          "extra" => {
            "raw_info" => { "name" => "72432833316128378", "id" => "72432833316128378" }
          }
        }
      }

      response = described_class.new(request_env)

      expect(response.token).to eq "0469a691b47c1df413e95edabd336ca3"
    end
  end
end
