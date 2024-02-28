# frozen_string_literal: true

User = Data.define(:id, :admin?) do
  class << self
    def all
      config = Rails.configuration.x.facebook
      config.editor_user_ids.map { |id| new(id:, admin?: false) } +
        config.admin_user_ids.map { |id| new(id:, admin?: true) }
    end
  end
end
