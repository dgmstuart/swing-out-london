# frozen_string_literal: true

class AddShortnameToOrganisers < ActiveRecord::Migration
  def self.up
    add_column :organisers, :shortname, :string
  end

  def self.down
    remove_column :organisers, :shortname
  end
end
