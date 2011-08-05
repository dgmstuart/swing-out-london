class RemoveFieldsFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :description
    remove_column :events, :music_style
    remove_column :events, :class_style
    remove_column :events, :timing_details
    remove_column :events, :pricing_details
  end

  def self.down
    add_column :events, :description, :string
    add_column :events, :music_style, :string
    add_column :events, :class_style, :string
    add_column :events, :timing_details, :string
    add_column :events, :pricing_details, :string
  end
end
