class NameClashController < ApplicationController
  layout 'name_clash'

  def index
    names = Event.socials.where("event_type <> ?", 'gig').pluck(:title)

    @names = names.map{|s|
      s.gsub(
        /(FREE:|FREE|GIG:|\(.*\)|SOLD OUT| with.*| (f|F)eat.*|)/, ""
      ).gsub(
        /(- $|-$)/, ""
      ).strip }.uniq.sort
  end
end