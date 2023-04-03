# frozen_string_literal: true

class LastUpdated
  def initialize(scope = Event)
    @time = scope.last_updated_datetime
  end

  def time_in_words
    time.to_s(:last_updated)
  end

  def iso
    time.utc.iso8601
  end

  private

  attr_reader :time
end
