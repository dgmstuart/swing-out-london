# frozen_string_literal: true

class NameClashController < ApplicationController
  layout "name_clash"

  def index
    scope = Event.socials
    records = scope.where.not(event_type: "gig").or(scope.where(event_type: nil))
    names = records.pluck(:title)

    @names = names.map do |s|
      s.gsub(
        /(FREE:|FREE|GIG:|SOLD OUT| with.*| (f|F)eat.*|)/, ""
      ).gsub(
        /(- $|-$)/, ""
      ).strip
    end.uniq.sort
  end
end
