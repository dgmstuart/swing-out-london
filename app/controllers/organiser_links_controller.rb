# frozen_string_literal: true

class OrganiserLinksController < CmsBaseController
  def create
    @event = Event.find(params.fetch(:event_id))

    if @event.update(organiser_token: SecureRandom.hex)
      render "organiser_links/show"
    else
      logger.error "Failed to save organiser token for Event##{@event.id}"
      render "organiser_links/error"
    end
  end
end
