# frozen_string_literal: true

# @private
module Frequency
  def weekly?
    frequency == 1
  end

  def infrequent?
    return false if frequency.nil?

    frequency.zero?
  end
end
