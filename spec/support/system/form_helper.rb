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

    def have_autocomplete_field(field_selector, value)
      HaveAutocompleteField.new(field_selector, value)
    end
  end

  class HaveAutocompleteField
    def initialize(field_selector, value)
      @field_selector = field_selector
      @value = value
    end

    def matches?(page)
      @autocomplete_dropdown = page.find_field(field_selector)
      @autocomplete_dropdown.value == value
    end

    def failure_message
      "expected page to contain an autocomplete field with label \"#{field_selector}\" " \
        "and value \"#{value}\", but it had value \"#{@autocomplete_dropdown.value}\""
    end

    def failure_message_when_negated
      "expected page not to contain an autocomplete field with label \"#{field_selector}\" " \
        "and value \"#{value}\", but found such a field"
    end

    private

    attr_reader :field_selector, :value
  end
end
