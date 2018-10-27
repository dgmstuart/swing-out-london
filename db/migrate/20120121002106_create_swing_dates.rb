# frozen_string_literal: true

class CreateSwingDates < ActiveRecord::Migration
  def self.up
    create_table :swing_dates, &:timestamps
  end

  def self.down
    drop_table :swing_dates
  end
end
