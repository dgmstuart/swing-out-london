# frozen_string_literal: true

module System
  module FormHelper
    def autocomplete_select(option_text, from:)
      # If the dropdown has a value, then it won't show other values,
      # because it's trying to autocomplete based on the current value.
      # Because of this, we need to delete the value from the field first.
      input = empty_autocomplete_field(from)
      option = input.sibling(".autocomplete__menu").find("li", text: option_text)
      option.click
    end

    def empty_autocomplete_field(field_selector, value = "")
      # We can use find_field, since accessibleAutocomplete
      # sets the ID of the autocomplete input to the label target,
      # and changes the ID of the original select element
      # by appending "-select"
      autocomplete_dropdown = find_field(field_selector)
      autocomplete_dropdown.click
      autocomplete_dropdown.native.send_key(:backspace)
      autocomplete_dropdown.fill_in with: value
      autocomplete_dropdown
    end
  end
end
