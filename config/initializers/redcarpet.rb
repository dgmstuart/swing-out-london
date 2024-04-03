# frozen_string_literal: true

# Custom handler to allow markdown files to be used as partials
class MarkdownHandler
  def initialize
    renderer = Redcarpet::Render::HTML
    options = { autolink: true, space_after_headers: true }
    @markdown = Redcarpet::Markdown.new(renderer, options)
    @base_handler = ActionView::Template::Handlers::Raw.new
  end

  def call(template, source)
    @base_handler.call(template, @markdown.render(source))
  end
end

module ActionView
  class Template # :nodoc:
    register_template_handler(:md, MarkdownHandler.new)
    register_template_handler(:mdown, MarkdownHandler.new)
    register_template_handler(:markdown, MarkdownHandler.new)
  end
end
