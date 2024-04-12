# frozen_string_literal: true

module MapHelper
  def map_update_control_link(text, query, selected:, url:)
    link_to text, query, {
      class: (:selected if selected),
      data: {
        action: "map#update:prevent map-menu#choose:prevent",
        map_target: "updateControl",
        url:
      }
    }
  end
end
