# frozen_string_literal: true

module MapHelper
  def map_update_control_link_item(url_helper, item)
    map_update_control_link(
      text: item.to_s,
      html_url: public_send(url_helper, item.to_param),
      json_url: public_send(url_helper, item.to_param, format: :json),
      selected: item.selected?
    )
  end

  def map_update_control_link_all(text, url_helper, selected:)
    map_update_control_link(
      text:,
      html_url: public_send(url_helper),
      json_url: public_send(url_helper, format: :json),
      selected:
    )
  end

  def map_update_control_link(text:, html_url:, json_url:, selected:)
    link_to text, html_url, {
      class: (:selected if selected),
      data: {
        action: "map#update:prevent map-menu#choose:prevent",
        map_menu_target: "updateControl",
        url: json_url
      }
    }
  end
end
