# frozen_string_literal: true

module ActionView
  # @private
  class Template
    # Custom handler to allow markdown files to be used as partials
    markdown_handler = Class.new do
      def initialize
        renderer = Redcarpet::Render::HTML
        options = { autolink: true, space_after_headers: true }
        @markdown = Redcarpet::Markdown.new(renderer, options)
        @base_handler = ActionView::Template::Handlers::Raw.new
      end

      def call(template, source)
        @base_handler.call(template, @markdown.render(source))
      end
    end.new

    register_template_handler(:md, markdown_handler)
    register_template_handler(:mdown, markdown_handler)
    register_template_handler(:markdown, markdown_handler)
  end
end
