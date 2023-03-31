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
end
