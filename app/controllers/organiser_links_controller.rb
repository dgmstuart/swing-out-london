# frozen_string_literal: true

class OrganiserLinksController < CmsBaseController
  def create
    @event = Event.find(params.fetch(:event_id))

    if @event.generate_organiser_token
      render "organiser_links/show"
    else
      logger.error "Failed to save organiser token for Event##{@event.id}"
      render "organiser_links/error"
    end
  end
end
