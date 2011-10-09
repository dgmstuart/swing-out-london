class AddShortnameToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :shortname, :string
  end

  def self.down
    remove_column :events, :shortname
  end
end
