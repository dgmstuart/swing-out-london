# frozen_string_literal: true

class UpdateEvent
  def initialize(params_commenter = EventParamsCommenter.new)
    @params_commenter = params_commenter
  end

  def update(event, update_params)
    params = update_params.merge!(params_commenter.comment(event, update_params))

    if event.update!(params)
      Success.new(event)
    else
      Failure.new
    end
  end

  attr_reader :params_commenter

  class Success
    attr_reader :updated_event

    def initialize(updated_event)
      @updated_event = updated_event
    end

    def success?
      true
    end
  end

  class Failure
    def success?
      false
    end
  end
end
