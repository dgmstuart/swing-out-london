# frozen_string_literal: true

class Editor
  def self.build(version)
    return UnknownEditor.new unless version

    RealEditor.new(version)
  end

  class RealEditor
    def initialize(version)
      @version = version
    end

    def name
      version.user_name
    end

    def auth_id
      version.whodunnit
    end

    private

    attr_reader :version
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
