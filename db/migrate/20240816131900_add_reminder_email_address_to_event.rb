# frozen_string_literal: true

class AddReminderEmailAddressToEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :reminder_email_address, :string
  end
end
