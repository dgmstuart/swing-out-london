# frozen_string_literal: true

require "spec_helper"
require "app/models/auth_response"

RSpec.describe AuthResponse do
  describe "#id" do
    it "returns the UID from the auth hash" do
      request_env = {
        "omniauth.auth" => {
          "provider" => "slack",
          "uid" => "72432833316128378",
          "info" => {
            "name" => "Felipe Goyette Jr."
          },
          "credentials" => {
            "token" => "0469a691b47c1df413e95edabd336ca3"
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
          "provider" => "slack",
          "uid" => "72432833316128378",
          "info" => {
            "name" => "Felipe Goyette Jr."
          },
          "credentials" => {
            "token" => "0469a691b47c1df413e95edabd336ca3"
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
            "name" => "Felipe Goyette Jr."
          },
          "credentials" => {
            "token" => "0469a691b47c1df413e95edabd336ca3"
          }
        }
      }

      response = described_class.new(request_env)

      expect(response.token).to eq "0469a691b47c1df413e95edabd336ca3"
    end
  end
end
