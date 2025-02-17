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
end
