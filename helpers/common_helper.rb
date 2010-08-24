module CommonHelper
  
  def nav_link(name, *args)
    # Render the link...
    link_to_unless_current(name, *args) do 
      # ...but if the page was current, render a span instead
      content_tag :span, name, :class => "current"
    end 
  end
  
end
