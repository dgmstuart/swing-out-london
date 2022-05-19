# frozen_string_literal: true

class OrganiserTokensController < CmsBaseController
  def create
    event = Event.find(params.fetch(:event_id))
    token = SecureRandom.hex

    respond_to do |format|
      if event.update(organiser_token: token)
        @url = edit_external_event_url(token)
        format.js
      else
        format.json { render json: event.errors, status: :unprocessable_entity }
      end
    end
  end
end
