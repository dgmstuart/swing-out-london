class CreateSwingDates < ActiveRecord::Migration
  def self.up
    create_table :swing_dates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :swing_dates
  end
end
