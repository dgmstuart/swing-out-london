# frozen_string_literal: true

class RemoveNearestTubeFromVenues < ActiveRecord::Migration[5.2]
  def change
    remove_column :venues, :nearest_tube, :string
  end
end
