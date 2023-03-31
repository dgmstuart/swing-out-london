# frozen_string_literal: true

class AddClassOrganiserAndSocialOrganiserToEvents < ActiveRecord::Migration
  def up
    # Some of the index names are too long so we need to rename them:
    rename_index :events, "index_events_on_frequency_and_day_and_has_class", "index_events_on_fq_and_day_and_has_class"
    rename_index :events, "index_events_on_frequency_and_day_and_has_social", "index_events_on_fq_and_day_and_has_social"
    rename_index :events, "index_events_on_frequency_and_has_class", "index_events_on_fq_and_has_class"
    rename_index :events, "index_events_on_last_date_and_frequency_and_has_class", "index_events_on_last_date_and_fq_and_has_class"

    add_column :events, :class_organiser_id, :integer
    add_column :events, :social_organiser_id, :integer
    Event.all.each do |event|
      event.update(class_organiser_id: event.organiser_id) if event.has_class || event.has_taster
      event.update(social_organiser_id: event.organiser_id) if event.has_social
    end
    remove_column :events, :organiser_id
  end

  def down
    add_column :events, :organiser_id, :integer
    Event.all.each do |event|
      org_id = event.class_organiser_id || event.social_organiser_id
      event.update(organiser_id: org_id)
    end
    remove_column :events, :class_organiser_id
    remove_column :events, :social_organiser_id

    rename_index :events, "index_events_on_fq_and_day_and_has_class", "index_events_on_frequency_and_day_and_has_class"
    rename_index :events, "index_events_on_fq_and_day_and_has_social", "index_events_on_frequency_and_day_and_has_social"
    rename_index :events, "index_events_on_fq_and_has_class", "index_events_on_frequency_and_has_class"
    rename_index :events, "index_events_on_last_date_and_fq_and_has_class", "index_events_on_last_date_and_frequency_and_has_class"
  end
end
