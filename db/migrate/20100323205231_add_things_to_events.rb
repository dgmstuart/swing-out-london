class AddThingsToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :pricing_details, :string
    add_column :events, :timing_details, :string
    add_column :events, :date_array, :string
    add_column :events, :class_style, :string
    add_column :events, :music_style, :string
    add_column :events, :description, :string
  end

  def self.down
    remove_column :events, :pricing_details
    remove_column :events, :timing_details
    remove_column :events, :date_array
    remove_column :events, :class_style
    remove_column :events, :music_style
    remove_column :events, :description
  end
end
