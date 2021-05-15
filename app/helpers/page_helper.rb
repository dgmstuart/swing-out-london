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
    # Render the link...
    link_to_unless_current(name, options, html_options) do
      # ...but if the page was current, render a span instead
      tag.span(name, class: 'current')
    end
  end
end
