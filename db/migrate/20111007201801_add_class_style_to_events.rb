class AddClassStyleToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :class_style, :text
  end

  def self.down
    remove_column :events, :class_style
  end
end
