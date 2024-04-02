# frozen_string_literal: true

# Presenter for showing an event as being associated with another record
# (eg. a {Venue})
class AssociatedEvent
  def initialize(event, summarizer: EventSummarizer.new, url_helpers: Rails.application.routes.url_helpers)
    @event = event
    @summarizer = summarizer
    @url_helpers = url_helpers
  end

  def summary
    summarizer.summarize(event)
  end

  def link
    url_helpers.event_path(event)
  end

  private

  attr_reader :event, :summarizer, :url_helpers
end
