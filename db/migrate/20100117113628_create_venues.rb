class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name
      t.text :address
      t.string :postcode
      t.string :nearest_tube
      t.string :website

      t.timestamps
    end
  end

  def self.down
    drop_table :venues
  end
end
