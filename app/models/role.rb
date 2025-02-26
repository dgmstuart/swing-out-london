# frozen_string_literal: true

class Role < ApplicationRecord
  ROLES = [
    ADMIN = "admin",
    EDITOR = "editor"
  ].freeze
  enum :role, {
    admin: ADMIN,
    editor: EDITOR
  }

  validates :facebook_ref, presence: true, uniqueness: true, numeric_string: { allow_blank: true }

  validates :role, presence: true

  class << self
    def real
      where.not(facebook_ref: Rails.configuration.x.facebook.test_user_app_id)
    end
  end
end
