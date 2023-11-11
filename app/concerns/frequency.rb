# frozen_string_literal: true

module Frequency
  def weekly?
    frequency == 1
  end

  def infrequent?
    return false if frequency.nil?

    frequency.zero? || frequency >= 4
  end
end
