# frozen_string_literal: true

module System
  module ClipboardHelper
    def clipboard_text
      page.evaluate_async_script("navigator.clipboard.readText().then(arguments[0])")
    end
  end
end
