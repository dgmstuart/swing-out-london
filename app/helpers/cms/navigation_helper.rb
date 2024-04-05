# frozen_string_literal: true

module Cms
  module NavigationHelper
    NavLink = Data.define(:name, :url)

    def navlinks
      navlinks = editor_navlinks
      navlinks += admin_navlinks if current_user.admin?
      navlinks
    end

    def editor_navlinks
      [
        NavLink.new(name: "New Event", url: new_event_path),
        NavLink.new(name: "Events", url: events_path),
        NavLink.new(name: "New Venue", url: new_venue_path),
        NavLink.new(name: "Venues", url: venues_path),
        NavLink.new(name: "New Organiser", url: new_organiser_path),
        NavLink.new(name: "Organisers", url: organisers_path)
      ]
    end

    def admin_navlinks
      [
        NavLink.new(name: "Users", url: admin_users_path),
        NavLink.new(name: "Audit Log", url: admin_audit_log_path),
        NavLink.new(name: "Cache", url: admin_cache_path)
      ]
    end
  end
end
