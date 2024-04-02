# frozen_string_literal: true

# Creates a short summary string of an {Event}
class EventSummarizer
  def summarize(event)
    if event.has_social?
      "Social: #{event.title}"
    else
      "Class with #{event.class_organiser.name} on #{event.day.pluralize}"
    end
  end
end
