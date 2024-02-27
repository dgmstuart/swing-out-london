# frozen_string_literal: true

module ShareButtonHelper
  def donate_button
    alt_text = "Donate to help keep #{tc('site_name')} running"

    link_to "Donate",
            Rails.configuration.x.donate_link,
            title: alt_text,
            alt: alt_text,
            target: "_blank",
            class: "share_button donate_button", rel: "noopener"
  end
end
