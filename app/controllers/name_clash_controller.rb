# frozen_string_literal: true

class NameClashController < ApplicationController
  layout 'name_clash'

  def index
    names = Event.socials.where('event_type <> ?', 'gig').pluck(:title)

    @names = names.map do |s|
      s.gsub(
        /(FREE:|FREE|GIG:|SOLD OUT| with.*| (f|F)eat.*|)/, ''
      ).gsub(
        /(- $|-$)/, ''
      ).strip
    end .uniq.sort
  end
end
