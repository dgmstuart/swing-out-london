# frozen_string_literal: true

module PageHelper
  # Switching h1 and h2 in the header
  def heading_hn(action, *args, &block)
    hn = if action == 'index'
           :h1
         else
           :h2
         end

    content_tag hn, *args, &block
  end

  # Links for navigation
  def nav_link(name, options = {}, html_options = {})
    icon_class = html_options.delete(:icon_class)
    content = capture do
      concat tag.i(nil, class: icon_class) if icon_class
      concat name
    end

    # Render the link...
    link_to_unless_current(content, options, html_options) do
      # ...but if the page was current, render a span instead
      tag.span(content, class: 'current')
    end
  end
end
