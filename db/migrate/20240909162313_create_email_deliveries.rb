# frozen_string_literal: true

class CreateEmailDeliveries < ActiveRecord::Migration[7.1]
  def change
    create_table :email_deliveries do |t|
      t.references :event, null: false, foreign_key: true
      t.string :recipient, null: false

      t.timestamps
    end
  end
end
