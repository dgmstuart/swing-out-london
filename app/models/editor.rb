# frozen_string_literal: true

class Editor
  def self.build(audit)
    return UnknownEditor.new unless audit

    RealEditor.new(audit)
  end

  class RealEditor
    def initialize(audit)
      @audit = audit
    end

    def name
      user.fetch('name')
    end

    def auth_id
      user.fetch('auth_id')
    end

    private

    attr_reader :audit

    def user
      audit.username
    end
  end

  class UnknownEditor
    def name
      'Unknown name'
    end

    def auth_id
      'Unknown auth id'
    end
  end
end
