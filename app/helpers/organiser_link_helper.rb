# frozen_string_literal: true

module OrganiserLinkHelper
  def link_to_generate_organiser(text, event, html_options)
    html_options = html_options.merge(
      method: :post,
      remote: true
    )

    link_to(
      text,
      event_organiser_tokens_path(event),
      html_options
    )
  end
end
