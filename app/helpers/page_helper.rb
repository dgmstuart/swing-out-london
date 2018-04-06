module PageHelper

  # Switching h1 and h2 in the header
  def heading_hn(action, *args, &block)
    if action == "index" then
      hn = :h1
    else
      hn = :h2
    end
    
    content_tag hn, *args, &block
  end
  
  # Links for navigation
  def nav_link(name, options={}, html_options={})
    icon_class = html_options.delete(:icon_class)
    content = ""
    content += content_tag(:i, nil, :class => icon_class) if icon_class
    content += name
    
    # Render the link...
    link_to_unless_current(raw(content), options, html_options) do 
      # ...but if the page was current, render a span instead
      content_tag :span, raw(content), :class => "current"
    end
  end
end