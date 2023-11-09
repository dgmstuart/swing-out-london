# frozen_string_literal: true

class EventCreator
  def initialize(repository = Event)
    @repository = repository
  end

  def create!(params)
    repository.create!(params)
  end

  private

  attr_reader :repository
end
