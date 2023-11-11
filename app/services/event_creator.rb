# frozen_string_literal: true

class EventCreator
  def initialize(repository = Event)
    @repository = repository
  end

  def create!(attrs)
    replace_key_with_swing_dates(attrs, :dates, :swing_dates)
    replace_key_with_swing_dates(attrs, :cancellations, :swing_cancellations)
    repository.create!(attrs)
  end

  private

  attr_reader :repository

  def replace_key_with_swing_dates(hash, old_key, new_key)
    replace_key(hash, old_key, new_key) { date_records(_1) }
  end

  def replace_key(hash, old_key, new_key, &)
    old_value = hash.delete(old_key) { return hash }
    new_value = yield(old_value)
    hash.merge!(new_key => new_value)
  end

  def date_records(dates)
    dates.map { |date| SwingDate.find_or_initialize_by(date:) }
  end
end
