# frozen_string_literal: true

class Editor
  def self.build(audit)
    return UnknownEditor.new unless audit
    return MissingEditor.new unless audit.username

    RealEditor.new(audit.username)
  end

  class RealEditor
    def initialize(user)
      @user = user
    end

    def name
      user.fetch('name')
    end

    def auth_id
      user.fetch('auth_id')
    end

    private

    attr_reader :user
  end

  class UnknownEditor
    def name
      'Unknown name'
    end

    def auth_id
      'Unknown auth id'
    end
  end

  class MissingEditor
    def name
      'Missing name'
    end

    def auth_id
      'Missing auth id'
    end
  end
end
