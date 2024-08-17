# frozen_string_literal: true

module OrganiserLinkHelper
  def link_to_generate_organiser(text, event, html_options)
    html_options = {
      data: {
        "turbo-method": :post
      }
    }.deep_merge html_options

    link_to(
      text,
      event_organiser_link_path(event),
      html_options
    )
  end

  def organiser_event_url(event)
    edit_external_event_url(event.organiser_token)
  end
end
