# frozen_string_literal: true

class EventsImport
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :csv
  def persisted?
    false
  end
end
