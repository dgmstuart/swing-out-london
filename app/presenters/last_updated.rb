# frozen_string_literal: true

# Presenter for creating a message describing when any data on the site was
# last updated
class LastUpdated
  def initialize(scope = Audit)
    time = scope.last_updated_at
    @time =
      if time
        ActualTime.new(time)
      else
        Never.new
      end
  end

  delegate :time_in_words, :iso, to: :time

  private

  attr_reader :time

  # @private
  class ActualTime
    def initialize(time)
      @time = time
    end

    def time_in_words
      I18n.l(time, format: :last_updated)
    end

    def iso
      time.utc.iso8601
    end

    attr_reader :time
  end

  # @private
  class Never
    def time_in_words
      "never"
    end

    def iso
      nil
    end
  end
end
