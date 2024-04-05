# frozen_string_literal: true

module MenuHelper
  def open_menu
    find("label", text: "Menu").click
  end
end
