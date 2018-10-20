# frozen_string_literal: true

class AddCourseLengthToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :course_length, :integer
  end

  def self.down
    remove_column :events, :course_length
  end
end
