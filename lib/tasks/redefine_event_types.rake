desc "Populate the new columns whch hold class and social information"
task :redefine_event_types => :environment do
  unknowns = {}
  
  Event.all.each do |e|
    case e.event_type
    when 'class'
      e.has_taster = false
      e.has_class = true
      e.has_social = false
      e.event_type = :school
    when 'social'
      e.has_taster = false
      e.has_class = false
      e.has_social = true
      e.event_type = :dance_club
    when 'social with class'
      e.has_taster = true
      e.has_class = false
      e.has_social = true
      e.event_type = :dance_club
    when 'class with social'
      e.has_taster = false
      e.has_class = true
      e.has_social = true
      e.event_type = :school
    when 'vintage club'
      e.has_taster = false
      e.has_class = false
      e.has_social = true
      e.event_type = :vintage_club
    when 'gig'
      e.has_taster = false
      e.has_class = false
      e.has_social = true
      e.event_type = :gig
    when 'festival'
      e.has_taster = false
      e.has_class = false
      e.has_social = true
      e.event_type = :festival
    # Ignore events which have already been changed: 
    when 'school'
    when 'dance_club'
    when 'vintage_club'
    when 'unknown'
    else
      e.has_taster = false
      e.has_class = false
      e.has_social = false
      e.event_type = :unknown
      unknowns.merge({e.id => e.event_type})
    end
    e.save!
  end
  unknowns.each{|k,v| puts "Unknown event type for event id#{e.id}: #{e.event_type.inspect}"}
end