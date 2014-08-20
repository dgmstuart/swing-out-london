class ChangeVenuesToNewFormat < ActiveRecord::Migration
  def change
    change_column_null :venues, :name,     false
    change_column_null :venues, :address,  false
    change_column_null :venues, :postcode, false
    change_column_null :venues, :website,  false

    rename_column      :venues, :website, :url

    remove_column :venues, :nearest_tube
    remove_column :venues, :created_at
    remove_column :venues, :updated_at
    remove_column :venues, :area
    remove_column :venues, :compass
    remove_column :venues, :lat
    remove_column :venues, :lng

    add_column :venues, :created_at, :datetime
    add_column :venues, :updated_at, :datetime
  end
end
