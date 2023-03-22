# frozen_string_literal: true

module System
  module ClipboardHelper
    def grant_clipboard_permissions
      [
        {
          origin: page.server_url,
          permission: { name: 'clipboard-write' },
          setting: 'granted'
        },
        {
          origin: page.server_url,
          permission: { name: 'clipboard-read' },
          setting: 'granted'
        }
      ].each do |cdp_params|
        page.driver.browser.execute_cdp('Browser.setPermission', **cdp_params)
      end
    end

    def clipboard_text
      page.evaluate_async_script('navigator.clipboard.readText().then(arguments[0])')
    end
  end
end
