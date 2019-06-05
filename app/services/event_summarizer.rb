# frozen_string_literal: true

class EventSummarizer
  def summarize(event)
    if event.has_social?
      "Social: #{event.title}"
    else
      "Class with #{event.class_organiser.name} on #{event.day.pluralize}"
    end
  end
end
