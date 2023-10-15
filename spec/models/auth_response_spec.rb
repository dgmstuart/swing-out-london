# frozen_string_literal: true

require "spec_helper"
require "app/models/auth_response"
require "faker"
require "lib/faker/auth0"

RSpec.describe AuthResponse do
  describe "#email" do
    it "returns the email from the auth hash" do
      id = Faker::Auth0.uid
      request_env = {
        "omniauth.auth" => {
          "provider" => "auth0",
          "uid" => id,
          "info" => {
            # info from the specific auth provider?
          },
          "credentials" => {
            "token" => "0469a691b47c1df413e95edabd336ca3",
            "expires_at" => 1697414660,
            "expires" => true,
            "id_token" => Faker::Auth0.id_token,
            "token_type" => "Bearer",
            "refresh_token" => nil
          },
          "extra" => {
            "raw_info" => { # raw_info is the data normalized by Auth0
              "given_name" => "Felipe",
              "family_name" => "Goyette",
              "nickname" => "feli",
              "name" => "Felipe Goyette Jr.",
              "picture" => "https://example.com/picture",
              "locale" => "en-GB",
              "updated_at" => "2023-10-14T23:20:47.941Z",
              "email" => "felig@example.com",
              "email_verified" => true,
              "iss" => "https://dev-zkufvtd16kyxi2x1.uk.auth0.com/", # auth0 domain
              "aud" => "be70560439f3c35adb6828fed79c1542",
              "iat" => 1697328260, # expiry
              "exp" => 1697364260, # also expiry?
              "sub" => id,
              "sid" => "1783f72c80f7fff6a5aa39c22012fcd8",
              "nonce" => "a1ab77d90ded3027fdd217a57f23af4e"
            }
          }
        }
      }

      response = described_class.new(request_env)

      expect(response.email).to eq "felig@example.com"
    end
  end

  describe "#name" do
    it "returns the name from the auth hash" do
      id = Faker::Auth0.uid
      request_env = {
        "omniauth.auth" => {
          "provider" => "auth0",
          "uid" => id,
          "info" => {
            # info from the specific auth provider?
          },
          "credentials" => {
            "token" => "0469a691b47c1df413e95edabd336ca3",
            "expires_at" => 1697414660,
            "expires" => true,
            "id_token" => Faker::Auth0.id_token,
            "token_type" => "Bearer",
            "refresh_token" => nil
          },
          "extra" => {
            "raw_info" => { # raw_info is the data normalized by Auth0
              "given_name" => "Felipe",
              "family_name" => "Goyette",
              "nickname" => "feli",
              "name" => "Felipe Goyette Jr.",
              "picture" => "https://example.com/picture",
              "locale" => "en-GB",
              "updated_at" => "2023-10-14T23:20:47.941Z",
              "email" => "felig@example.com",
              "email_verified" => true,
              "iss" => "https://dev-zkufvtd16kyxi2x1.uk.auth0.com/", # auth0 domain
              "aud" => "be70560439f3c35adb6828fed79c1542",
              "iat" => 1697328260, # expiry
              "exp" => 1697364260, # also expiry?
              "sub" => id,
              "sid" => "1783f72c80f7fff6a5aa39c22012fcd8",
              "nonce" => "a1ab77d90ded3027fdd217a57f23af4e"
            }
          }
        }
      }

      response = described_class.new(request_env)

      expect(response.name).to eq "Felipe Goyette Jr."
    end
  end

  describe "#token" do
    it "returns the token from the auth hash" do
      id = Faker::Auth0.uid
      request_env = {
        "omniauth.auth" => {
          "provider" => "auth0",
          "uid" => id,
          "info" => {
            # info from the specific auth provider?
          },
          "credentials" => {
            "token" => "0469a691b47c1df413e95edabd336ca3",
            "expires_at" => 1697414660,
            "expires" => true,
            "id_token" => Faker::Auth0.id_token,
            "token_type" => "Bearer",
            "refresh_token" => nil
          },
          "extra" => {
            "raw_info" => { # raw_info is the data normalized by Auth0
              "given_name" => "Felipe",
              "family_name" => "Goyette",
              "nickname" => "feli",
              "name" => "Felipe Goyette Jr.",
              "picture" => "https://example.com/picture",
              "locale" => "en-GB",
              "updated_at" => "2023-10-14T23:20:47.941Z",
              "email" => "felig@example.com",
              "email_verified" => true,
              "iss" => "https://dev-zkufvtd16kyxi2x1.uk.auth0.com/", # auth0 domain
              "aud" => "be70560439f3c35adb6828fed79c1542",
              "iat" => 1697328260, # expiry
              "exp" => 1697364260, # also expiry?
              "sub" => id,
              "sid" => "1783f72c80f7fff6a5aa39c22012fcd8",
              "nonce" => "a1ab77d90ded3027fdd217a57f23af4e"
            }
          }
        }
      }

      response = described_class.new(request_env)

      expect(response.token).to eq "0469a691b47c1df413e95edabd336ca3"
    end
  end
end
